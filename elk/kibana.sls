{% set kibana_version = "3.0.1" %}
{% set kibana_md5 = "210e66901b22304a2bada3305955b115" %}

elastic_htpasswd:
  file.managed:
    - name: {{ elastic_htpasswd_file }}
    - contents_pillar: elastic:htpasswd
    - group: www-data
    - mode: 640

# Get the kibana tarball
/tmp/kibana-{{ kibana_version }}.tar.gz:
  file.managed:
    - source: https://download.elasticsearch.org/kibana/kibana/kibana-{{ kibana_version }}.tar.gz
    - source_hash: md5={{ kibana_md5 }}
unzip_kibana:
  cmd.run:
    - name: tar -zxf kibana-{{ kibana_version }}.tar.gz
    - cwd: /tmp
    - require:
      - file: /tmp/kibana-{{ kibana_version }}.tar.gz
kibana_static_dir:
  file.directory:
    - name: {{ kibana_wwwroot }}
    - user: www-data
    - group: www-data
    - makedirs: True
move_kibana_files:
  cmd.run:
    - name: mv kibana-{{ kibana_version }}/* {{ kibana_wwwroot }}
    - cwd: /tmp
    - require:
      - cmd: unzip_kibana
      - file: kibana_static_dir
kibana_config_js:
  file.managed:
    - name: '{{ kibana_wwwroot }}config.js'
    - template: jinja
    - source: salt://elk-formula/files/kibana/config.js
    - context:
       kibana_port: {{ kibana_port }}

nginx_static_site:
  pkg.installed:
    - name: nginx
    - require:
      - file: nginx_static_site
      - file: kibana_static_dir
      - file: elastic_htpasswd

  service.running:
    - name: nginx
    - reload: True
    - enable: True
    - watch:
      - file: nginx_static_site
    - require:
      - service: elasticsearch

  file.managed:
    - template: jinja
    - source: salt://elk-formula/files/nginx_kibana_site
    - name: /etc/nginx/sites-enabled/kibana
    - mode: 644
    - context:
       kibana_port: {{ kibana_port }}
       server_name: {{ server_name }}
       kibana_wwwroot: {{ kibana_wwwroot }}
       elastic_htpasswd_file: {{ elastic_htpasswd_file }}



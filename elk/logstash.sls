{% with logstash_repo_loc = 'http://packages.elasticsearch.org/logstash/1.4/debian' %}
{% with repo_key_file = '/root/logstash_repo.key' %}

{% endwith %}
{% endwith %}

logstash_repo:
  pkgrepo.managed:
    - humanname: Logstash Repo
    - name: deb http://packages.elasticsearch.org/logstash/1.5/debian stable main
    - gpgkey: https://packages.elasticsearch.org/GPG-KEY-elasticsearch

logstash_soft:
  pkg.installed:
    - name: logstash
    - refresh: True
    - require:
      - file: logstash_repo

logstash_service:
  service.running:
    - name: logstash
    - enable: True
    - require:
      - pkg: logstash_soft
    - watch:
      - file: /etc/logstash/conf.d/*

/etc/logstash/conf.d/simple_syslog.conf:
  file.managed:
    - template: jinja
    - source: salt://elk-formula/files/logstash/simple_syslog.conf
    - mode: 644
    - user: logstash
    - group: logstash

/etc/logstash/conf.d/simple_http.conf:
  file.managed:
    - template: jinja
    - source: salt://elk-formula/files/logstash/simple_http.conf
    - mode: 644
    - user: logstash
    - group: logstash
elasticsearch-logstash-kibana
=============================

Saltstack formulae for installing logstash server with kibana and logstash shippers on your other machines.
Requires at least 1 standalone haproxy, alongside 1 node with elasticsearch, kibana and logstash.
ELK roles can be applied to as many servers as desired and be split up or combined.

** Nothing will show up in Kibana until you configure a server to send syslog events to haproxy node on port 5544 or create your own logstash config. (See logstash info below) **




Kibana
------
runs on port 8080 (this can be changed via pillar). In the UI the "Sample Dashboard" is a good place to start.

Logstash 
--------
has an example config that listens for syslog events on 5544 and saves them to elasticsearch. To make this work rsyslog should be configured on some node to ship logs to haproxy node on 5544 (this will load balance between available logstash nodes). There is also another simple example for logstash that listens to /var/log/nginx/access.log but it needs nginx to be installed. To configure rsyslog to forward logs some examples can be found at the following links:
https://community.ulyaoth.net/threads/how-to-install-logstash-kibana-on-fedora-using-rsyslog-as-shipper.11/
http://capnjosh.com/blog/forwarding-logs-to-logstash-1-4-with-rsyslog-working-nginx-logs-too/



/etc/rsyslog.d/logstash.conf
$ModLoad imfile

$InputFileName /var/log/nginx/error.log
$InputFileTag nginx-errorlog:
$InputFileStateFile state-nginx-errorlog
$InputRunFileMonitor

$InputFileName /var/log/nginx/access.log
$InputFileTag nginx-accesslog:
$InputFileStateFile state-nginx-accesslog
$InputRunFileMonitor

$InputFilePollInterval 10

if $programname == ‘nginx-errorlog’ then @{{ haproxy_ip }}:5544
if $programname == ‘nginx-errorlog’ then ~
if $programname == ‘nginx-accesslog’ then @{{ haproxy_ip }}:5544
if $programname == ‘nginx-accesslog’ then ~










Elasticsearch
-------------
nodes automatically become part of a cluster and listen on 9200 and 9300



.. note::

    See the full `Salt Formulas installation and usage instructions
    <http://docs.saltstack.com/en/latest/topics/development/conventions/formulas.html>`_.

#### How to use
If applying from a top file:
```shell
salt <sync-targets> state.highstate
```
Or if applying explicitly:
```shell
salt <sync-targets> state.sls elk-formula.elk
```

#### Helpful links
* [ELK](http://www.elasticsearch.org/overview/)
* [RSYSLOG_FORWARDING] (https://community.ulyaoth.net/threads/how-to-install-logstash-kibana-on-fedora-using-rsyslog-as-shipper.11/)
* [RSYSLOG_FORWARDING2] (http://capnjosh.com/blog/forwarding-logs-to-logstash-1-4-with-rsyslog-working-nginx-logs-too/)
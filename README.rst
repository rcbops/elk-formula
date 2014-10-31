elasticsearch-logstash-kibana
=============================

Saltstack formulae for installing logstash server with kibana and logstash shippers on your other machines

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

The Kibana UI will run on port 8080 (This is editable via pillar kibana:httpport)
From here the Simple UI will is a good place to start viewing data.

#### Helpful links
* [ELK](http://www.elasticsearch.org/overview/)

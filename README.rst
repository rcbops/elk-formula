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

#### Helpful links
* [ELK](http://www.elasticsearch.org/overview/)

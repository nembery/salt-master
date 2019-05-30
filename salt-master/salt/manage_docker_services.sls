# this state will create a new docker-compose file and populate with at least one service
{% set service_def = pillar['service_definition']|load_json %}
{% set service_def_path = '/srv/salt/dockercompose/' + pillar['name'] %}

create_compose_file:
  module.run:
    - dockercompose.create
      - name: {{ service_def_path }}
      - content: {{ service_def|yaml(False) }}
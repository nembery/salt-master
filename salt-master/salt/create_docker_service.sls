# this state will create a new docker-compose file, populate with at least one service, and start it
{% set service_def = pillar['service_definition']|base64_decode %}
{% set service_def_path = '/srv/salt/dockercompose/' + pillar['name'] + '.yaml' %}

ensure_dir_exists:
  file.directory:
    - name: /srv/salt/dockercompose
    - user: root
    - group: root
    - dir_mode: 755
    - file_mode: 744
    - makedirs: true

create_compose_file:
  module.run:
    - name: dockercompose.create
    - path: {{ service_def_path }}
    - docker_compose: {{ service_def|yaml(False) }}
    - requires:
       - ensure_dir_exists

pull_images:
  module.run:
    - name: dockercompose.pull
    - path: {{ service_def_path }}
    - requires:
       - create_compose_file

start_all_services:
  module.run:
    - name: dockercompose.up
    - path: {{ service_def_path }}
    - requires:
      - pull_images

ensure_compare_script:
  file.managed:
    - name: /srv/salt/check_container_image.sh
    - source: salt://scripts/check_container_image.sh
    - user: root
    - group: root
    - mode: 644
    - order: 1

pull_image:
  docker_image.present:
    - name: {{ pillar['image'] }}
    - force: true
    - order: 2

remove_if_necessary:
  cmd.run:
    - name: docker stop {{ pillar['container'] }} && docker rm -f {{ pillar['container'] }}
    - unless: /srv/salt/check_container_image.sh {{ pillar['container'] }} {{ pillar['image'] }}
    - order: 3

start_container:
  docker_container.running:
    - name: {{ pillar['container'] }}
    - image: {{ pillar['image'] }}
    - port_bindings:
      - {{ pillar['port_bindings'] }}
    {% if pillar['volumes'] is defined %}
    - volumes:
      - {{ pillar['volumes'] }}
    {% endif %}
    - order: 4

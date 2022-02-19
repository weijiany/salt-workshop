base:
  '*':
    - node-exporter
  'roles:prometheus':
    - match: grain
    - prometheus

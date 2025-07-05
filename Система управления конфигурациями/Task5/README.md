# Ansible Role: Vector

An Ansible role that installs and configures [Vector](https://vector.dev/) log collector on Linux servers.

## Requirements

- Ansible >= 2.10
- Debian/Ubuntu or RHEL/CentOS

## Role Variables

### Installation Variables

| Variable | Default | Description |
|----------|---------|-------------|
| `vector_version` | `0.28.X` | Vector version to install |
| `vector_download_url` | `"https://packages.timber.io/vector/{{ vector_version }}/vector-{{ vector_version }}-amd64.deb"` | Download URL for Vector package |
| `vector_install_method` | `package` | Installation method (package or archive) |

### Configuration Variables

| Variable | Default | Description |
|----------|---------|-------------|
| `vector_config_dir` | `/etc/vector` | Path to Vector configuration directory |
| `vector_config_file` | `vector.yml` | Main configuration filename |
| `vector_sources` | `{}` | Dictionary of input sources |
| `vector_transforms` | `{}` | Dictionary of transform configurations |
| `vector_sinks` | `{}` | Dictionary of output sinks |

### Service Variables

| Variable | Default | Description |
|----------|---------|-------------|
| `vector_service_state` | `started` | Service state (started, stopped) |
| `vector_service_enabled` | `true` | Whether to enable service on boot |

## Example Playbook

```yaml
- hosts: all
  roles:
    - role: vector
      vars:
        vector_sources:
          syslog:
            type: syslog
            mode: tcp
            address: "0.0.0.0:514"
        vector_sinks:
          clickhouse:
            type: clickhouse
            inputs: ["syslog"]
            host: "clickhouse-server"
            database: "logs"
            table: "system_logs"
```          

### License
-------

BSD

### Author Information
------------------

shvirtd-19.            
Ansible Role: Lighthouse
=========

An Ansible role that installs and configures [Lighthouse](https://github.com/VKCOM/lighthouse) web interface with Nginx.

## Requirements

- Ansible >= 2.10
- Ubuntu/Debian or RHEL/CentOS
- Nginx (installed automatically as dependency)

## Role Variables

### Installation Variables

| Variable | Default | Description |
|----------|---------|-------------|
| `lighthouse_version` | `master` | Branch/tag to checkout |
| `lighthouse_repo` | `https://github.com/VKCOM/lighthouse.git` | Git repository URL |
| `lighthouse_dir` | `/opt/lighthouse` | Installation directory |

### Nginx Configuration

| Variable | Default | Description |
|----------|---------|-------------|
| `lighthouse_nginx_conf_dir` | `/etc/nginx/conf.d` | Nginx config directory |
| `lighthouse_nginx_port` | `80` | Port to listen on |
| `lighthouse_nginx_server_name` | `_` | Server name |
| `lighthouse_nginx_ssl_enabled` | `false` | Enable SSL configuration |
| `lighthouse_nginx_ssl_cert` | `""` | SSL certificate path |
| `lighthouse_nginx_ssl_key` | `""` | SSL key path |

## Example Playbook

```yaml
- hosts: monitoring
  roles:
    - role: lighthouse
      vars:
        lighthouse_nginx_server_name: "lighthouse.example.com"
        lighthouse_nginx_ssl_enabled: true
        lighthouse_nginx_ssl_cert: "/etc/ssl/certs/lighthouse.crt"
        lighthouse_nginx_ssl_key: "/etc/ssl/private/lighthouse.key"
```

### License
-------

BSD

### Author Information
------------------

shvirtd-19.       
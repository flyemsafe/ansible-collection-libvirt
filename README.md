# RHDC.Libvirt Collection

This collection provides roles for managing libvirt hosts, networks, storage, and virtual machines.

## Roles

- **libvirt_host_setup**: Configure a host for libvirt (permissions, networking, etc.)
- **libvirt_network**: Manage libvirt networks
- **libvirt_storage**: Manage libvirt storage pools and volumes
- **libvirt_vm**: Create and manage VMs
- **libvirt_permissions**: Configure user permissions for libvirt access

## Installation

```bash
ansible-galaxy collection install /path/to/ansible-collection-libvirt -f
```

## Usage

See the documentation in the `docs` directory for detailed usage instructions.

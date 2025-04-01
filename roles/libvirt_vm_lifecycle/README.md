# Libvirt VM Lifecycle Role

This role provides tasks for managing the lifecycle of libvirt virtual machines, including checking status, starting, stopping, and restarting VMs.

## Requirements

- Ansible 2.9 or higher
- libvirt installed on the target system
- community.libvirt collection installed (can be installed with `ansible-galaxy collection install community.libvirt`)
- SELinux properly configured for libvirt operations

## Role Variables

### Main Variables

| Variable | Description | Default |
|----------|-------------|---------|
| `libvirt_vm_action` | Action to perform on VMs (status, start, stop, restart) | `status` |
| `libvirt_vm_debug` | Enable debug output | `false` |
| `libvirt_vm_selinux_enabled` | Whether to apply SELinux contexts for VM operations | `true` |

### Inventory Configuration

| Variable | Description | Default |
|----------|-------------|---------|
| `libvirt_vm_use_inventory` | Whether to use inventory at all for VM targeting (if false, will use libvirt directly) | `true` |
| `libvirt_vm_inventory_file` | Optional path to a custom inventory file (if empty, uses the playbook's inventory) | `""` |
| `libvirt_vm_group` | Group name in inventory containing VMs (only used if libvirt_vm_use_inventory is true) | `kvm_vms` |
| `libvirt_vm_target` | Target VMs: 'all', 'group', or specific VM name | `all` |

### VM Selection

| Variable | Description | Default |
|----------|-------------|---------|
| `libvirt_vm_list` | List of specific VMs to manage (overrides libvirt_vm_target if provided) | `[]` |
| `libvirt_vm_manage_all` | Whether to manage all VMs when no specific list is provided | `false` |

### VM Shutdown Options

| Variable | Description | Default |
|----------|-------------|---------|
| `libvirt_vm_shutdown_timeout` | Seconds to wait for graceful shutdown | `300` |
| `libvirt_vm_force_shutdown` | Whether to force shutdown if graceful shutdown fails | `false` |

## Dependencies

- community.libvirt collection

## Example Playbook

```yaml
- name: Manage VM Lifecycle
  hosts: libvirt_hosts
  become: true
  gather_facts: true
  
  tasks:
    - name: Get VM status
      ansible.builtin.import_role:
        name: rhdc.libvirt.libvirt_vm_lifecycle
      vars:
        libvirt_vm_action: "status"
        libvirt_vm_debug: true
        
    - name: Stop all VMs
      ansible.builtin.import_role:
        name: rhdc.libvirt.libvirt_vm_lifecycle
      vars:
        libvirt_vm_action: "stop"
        libvirt_vm_shutdown_timeout: 180
        
    - name: Start all VMs
      ansible.builtin.import_role:
        name: rhdc.libvirt.libvirt_vm_lifecycle
      vars:
        libvirt_vm_action: "start"
        
    - name: Manage specific VMs
      ansible.builtin.import_role:
        name: rhdc.libvirt.libvirt_vm_lifecycle
      vars:
        libvirt_vm_action: "restart"
        libvirt_vm_list:
          - web01
          - db01
```

## License

MIT

## Author Information

Rodhouse Datacenter Team

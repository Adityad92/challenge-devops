### 2. Managing System Packages and Ensuring They're Up to Date  
   
**Project Overview:**  
Update system packages to the latest available versions.  
   
**Ansible Concepts to Use:**  
- `ansible.builtin.package` module or specific package modules like `ansible.builtin.apt` and `ansible.builtin.yum`.  
- Facts to gather information about the system.  
   
**Example Playbook for Updating System Packages:**  
```yaml  
---  
- name: Update all system packages to the latest version  
  hosts: all  
  become: yes  
  tasks:  
    - name: Update system packages (Debian/Ubuntu)  
      ansible.builtin.apt:  
        upgrade: dist  
        update_cache: yes  
      when: ansible_os_family == "Debian"  
  
    - name: Update system packages (RedHat/CentOS)  
      ansible.builtin.yum:  
        name: "*"  
        state: latest  
      when: ansible_os_family == "RedHat"  
```
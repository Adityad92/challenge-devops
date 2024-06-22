### 3. Configuring a Firewall  
   
**Project Overview:**  
Set up basic firewall rules to control the flow of traffic to the system.  
   
**Ansible Concepts to Use:**  
- `ansible.posix.firewalld` module for managing firewalld on RedHat/CentOS systems.  
- `ansible.builtin.ufw` module for managing Uncomplicated Firewall (UFW) on Debian/Ubuntu systems.  
- Variables to define allowed services and ports.  
   
**Example Playbook for Configuring firewalld:**  
```yaml  
---  
- name: Configure firewalld firewall rules  
  hosts: servers  
  become: yes  
  vars:  
    allowed_services:  
      - http  
      - https  
  tasks:  
    - name: Install firewalld  
      ansible.builtin.package:  
        name: firewalld  
        state: present  
  
    - name: Start firewalld  
      ansible.builtin.service:  
        name: firewalld  
        state: started  
        enabled: yes  
  
    - name: Allow defined services through the firewall  
      ansible.posix.firewalld:  
        service: "{{ item }}"  
        permanent: yes  
        state: enabled  
      loop: "{{ allowed_services }}"  
      notify: reload firewalld  
  
  handlers:  
    - name: reload firewalld  
      ansible.posix.firewalld: 
      state: reloaded  
```  
   
In this example, the `ansible.posix.firewalld` module is used to set up basic firewall rules using the `firewalld` service available on RedHat/CentOS systems. The playbook ensures that `firewalld` is installed, started, and enabled to run at boot. It then iterates over the `allowed_services` list, enabling firewall rules for each service. Lastly, a handler is triggered to reload `firewalld` if any changes are made.  
   
**Note:** The `ansible.posix.firewalld` module is used for RedHat/CentOS systems. For Debian/Ubuntu systems, you might use the `ansible.builtin.ufw` module for Uncomplicated Firewall (UFW) with similar logic.  
   
**Example Playbook for Configuring UFW:**  
```yaml  
---  
- name: Configure UFW firewall rules  
  hosts: servers  
  become: yes  
  vars:  
    allowed_ports:  
      - "22"  
      - "80"  
      - "443"  
  tasks:  
    - name: Install UFW  
      ansible.builtin.package:  
        name: ufw  
        state: present  
  
    - name: Enable UFW  
      ansible.builtin.ufw:  
        state: enabled  
  
    - name: Allow defined ports through the firewall  
      ansible.builtin.ufw:  
        rule: allow  
        port: "{{ item }}"  
        proto: tcp  
      loop: "{{ allowed_ports }}"  
```  
   
In this example, the `ansible.builtin.ufw` module is used for Debian/Ubuntu systems to manage UFW. Similar to the previous playbook, it ensures that UFW is installed and enabled, and then it creates allow rules for the specified ports.  
   
By applying the 80-20 principle to these projects, you focus on the most impactful tasks that provide the foundational setup for each respective area. You can build upon these examples and customize them further to match your specific requirements. Remember to test your playbooks in a safe environment before rolling them out to production, and use Ansible's idempotence to your advantage, which ensures that running your playbooks multiple times does not have unintended side effects.
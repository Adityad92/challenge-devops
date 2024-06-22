### 1. Setting up a Web Server with Nginx or Apache  
   
**Project Overview:**  
Install and configure a web server software (Nginx or Apache) on a managed node.  
   
**Ansible Concepts to Use:**  
- `ansible.builtin.package` module for installing packages (platform-agnostic).  
- `ansible.builtin.template` module for configuring the web server.  
- `ansible.builtin.service` module for managing the service state.  
- Variables to customize the installation and configuration.  
   
**Example Playbook for Setting up Nginx:**  
```yaml  
---  
- name: Set up Nginx web server  
  hosts: webservers  
  become: yes  
  vars:  
    nginx_port: 80  
  tasks:  
    - name: Install Nginx  
      ansible.builtin.package:  
        name: nginx  
        state: latest  
  
    - name: Deploy Nginx configuration template  
      ansible.builtin.template:  
        src: nginx.conf.j2  
        dest: /etc/nginx/nginx.conf  
      notify: restart nginx  
  
    - name: Ensure Nginx is running and enabled  
      ansible.builtin.service:  
        name: nginx  
        state: started  
        enabled: yes  
  
  handlers:  
    - name: restart nginx  
      ansible.builtin.service:  
        name: nginx  
        state: restarted  
```    

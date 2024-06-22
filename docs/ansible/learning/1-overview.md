**1. What is Ansible?**  
Ansible is an open-source tool designed for automation. It is used for configuration management, application deployment, task automation, and also for orchestration of multi-tier IT environments.  

**2. How does Ansible work?**  
Ansible works by connecting to your nodes (servers, virtual machines, cloud instances) and pushing out small programs called "Ansible modules." These programs are written to be resource models of the desired state of the system. Ansible then executes these modules over SSH and removes them when finished.  
   
**3. Inventory:**  
The inventory is a file (by default located at `/etc/ansible/hosts`) where you define the hosts and groups of hosts upon which commands, modules, and tasks in a playbook operate. You can specify variables within the inventory file to configure your host dynamically.  
   
Example of an inventory file:  
```  
[webservers]  
webserver1.example.com  
webserver2.example.com  
   
[dbservers]  
dbserver.example.com  
```  
   
**4. Ad-hoc Commands:**  
Ansible allows you to execute simple one-liner commands that can perform a wide variety of tasks. These are great for tasks that you repeat rarely.  
   
Example:  
```  
ansible all -m ping  
```  
This command checks the connection to all hosts in your inventory.  
   
**5. Playbooks:**  
Playbooks are Ansible's configuration, deployment, and orchestration language. They are written in YAML format and describe the tasks that need to be executed.  
   
Example of a simple playbook (`myplaybook.yml`) that ensures Apache is installed:  
```yaml  
---  
- name: Ensure Apache is at the latest version  
  hosts: webservers  
  tasks:  
  - name: Install apache  
    yum:  
      name: httpd  
      state: latest  
```  
   
To run this playbook:  
```  
ansible-playbook myplaybook.yml  
```  
   
**6. Roles:**  
Roles are units of organization in Ansible. Think of a role as a bundle of automation that can be reused and shared. A role can include variables, tasks, files, templates, and modules.  
   
**7. Modules:**  
Modules are the tools in your toolbox. Each module is a piece of code that serves a specific purpose, like managing system packages with the `yum` module or controlling services with the `service` module.  
   
**8. Variables:**  
Variables are used to deal with differences between systems. You can define variables in playbooks, in inventory, in reusable files, or at the command line.  
   
**9. Facts:**  
Facts are pieces of information derived from speaking with your remote systems. You can use Ansible facts to get system properties like network interfaces, operating system, IP addresses, etc.  
   
**10. Handlers:**  
Handlers are tasks that only run when notified. They are typically used to handle system service status changes, like restarting or stopping a service.
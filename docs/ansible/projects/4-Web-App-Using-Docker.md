### Project: Deploy a Simple Web Application Using Docker and Ansible  
   
**Project Overview:**  
The goal is to use Ansible to automate the deployment of a simple web application running inside a Docker container on a host machine.  
   
**Steps for the Project:**  
   
1. **Install Docker**: Use Ansible to install Docker on the target host.  
2. **Build a Docker Image**: Create a Dockerfile for your web application and use Ansible to build the image on the host.  
3. **Run Docker Containers**: Use Ansible to run containers from the built image.  
4. **Manage Container State**: Ensure the container is started and restarted automatically if it fails.  
   
**Ansible Concepts to Use:**  
   
- `community.docker.docker_image` module to manage Docker images.  
- `community.docker.docker_container` module to manage Docker containers.  
- `ansible.builtin.copy` module to transfer files, like the Dockerfile, to the host.  
- Variables for configurable parameters like image tags and container names.  
   
**Example Ansible Playbook:**  
   
```yaml  
---  
- name: Deploy a web application using Docker  
  hosts: docker-hosts  
  become: yes  
  vars:  
    app_name: my-web-app  
    image_name: my-web-app-image  
    image_tag: v1.0  
    dockerfile_path: ./Dockerfile  
    container_port: 80  
  
  tasks:  
    - name: Install Docker  
      ansible.builtin.package:  
        name: docker  
        state: present  
  
    - name: Start Docker service  
      ansible.builtin.service:  
        name: docker  
        state: started  
        enabled: yes  
  
    - name: Copy the Dockerfile to the host  
      ansible.builtin.copy:  
        src: "{{ dockerfile_path }}"  
        dest: "/tmp/Dockerfile"  
  
    - name: Build the Docker image  
      community.docker.docker_image:  
        build:  
          path: "/tmp"  
        name: "{{ image_name }}"  
        tag: "{{ image_tag }}"  
        source: build  
  
    - name: Run the Docker container  
      community.docker.docker_container:  
        name: "{{ app_name }}"  
        image: "{{ image_name }}:{{ image_tag }}"  
        state: started  
        restart_policy: unless-stopped  
        published_ports:  
          - "{{ container_port }}:80"  
```  
   
**Notes:**  
   
- The `community.docker.docker_image` and `community.docker.docker_container` modules are part of the `community.docker` collection. You might need to install this collection using the `ansible-galaxy` command if it's not already available:  
    
  ```sh  
  ansible-galaxy collection install community.docker  
  ```  
   
- The playbook assumes you have a Dockerfile at the specified `dockerfile_path` that defines how to build your web application image.  
   
- The `ansible.builtin.package` and `ansible.builtin.service` tasks are generic and may need to be adjusted based on the target host's operating system and the method you wish to use for installing and starting Docker.  
   
- The `published_ports` setting in the `community.docker.docker_container` task maps the container's internal port to a port on the host so that the web application can be accessed externally.  
   
By working through this project, you'll gain hands-on experience using Ansible to manage Docker containers and images, which is a valuable skill set for modern DevOps practices. This example is a starting point, and you can expand upon it by adding more complex configuration, such as mounting volumes, setting environment variables, and integrating with orchestration tools like Docker Compose or Kubernetes.
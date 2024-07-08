Certainly! Below is an example Docker Compose project configuration (`docker-compose.yml`) that sets up three Nginx servers as backends and one Nginx server as a reverse proxy (load balancer). The `ipam` configuration is used to assign fixed IPs to each container within the custom network.  

## Reference: https://nginx.org/en/docs/http/load_balancing.html

```yaml  
version: '3.8'  
   
services:  
  # First Nginx Server  
  nginx1:  
    image: nginx:latest  
    container_name: nginx1  
    ports:  
      - "8081:80"  
    volumes:  
      - ./server1/index.html:/usr/share/nginx/html/index.html  
    networks:  
      webapp_network:  
        ipv4_address: 10.5.0.2  
  
  # Second Nginx Server  
  nginx2:  
    image: nginx:latest  
    container_name: nginx2  
    ports:  
      - "8082:80"  
    volumes:  
      - ./server2/index.html:/usr/share/nginx/html/index.html  
    networks:  
      webapp_network:  
        ipv4_address: 10.5.0.3  
  
  # Third Nginx Server  
  nginx3:  
    image: nginx:latest  
    container_name: nginx3  
    ports:  
      - "8083:80"  
    volumes:  
      - ./server3/index.html:/usr/share/nginx/html/index.html  
    networks:  
      webapp_network:  
        ipv4_address: 10.5.0.4  
  
  # Client Nginx Server (Load Balancer)  
  nginx_client:  
    image: nginx:latest  
    container_name: nginx_client  
    ports:  
      - "80:80"  
    volumes:  
      - ./nginx_client/nginx.conf:/etc/nginx/nginx.conf  
    networks:  
      webapp_network:  
        ipv4_address: 10.5.0.10  
   
networks:  
  webapp_network:  
    driver: bridge  
    ipam:  
      config:  
        - subnet: 10.5.0.0/16  
```  
   
In the `nginx_client` service, the `nginx.conf` file should be configured with the `upstream` directive that points to the internal IPs or service names defined by Docker Compose.  
   
Here's an example of what the `nginx.conf` could look like:  
   
```nginx  
events {}  
   
http {  
    upstream myapp1 {  
        server nginx1:80;  
        server nginx2:80;  
        server nginx3:80;  
    }  
  
    server {  
        listen 80;  
  
        location / {  
            proxy_pass http://myapp1;  
        }  
    }  
}  
```  
   
Save this configuration to a file named `nginx.conf` inside a directory named `nginx_client` at the root of your project folder.  
   
Please ensure that you create the `index.html` files in directories named `server1`, `server2`, and `server3` in your project folder before starting the containers. Also, create the `nginx_client` directory and place your `nginx.conf` file there.  
   
To start the project, run:  
   
```sh  
docker-compose up -d  
```  
   
This will start all the services defined in the Docker Compose file. Requests to port 80 on the host will be load-balanced across the three backend Nginx servers running on ports 8081, 8082, and 8083, respectively. Each backend server's index page can be customized to verify that the load balancing is working correctly.
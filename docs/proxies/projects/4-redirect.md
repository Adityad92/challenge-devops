To create a simple project that uses Nginx to redirect traffic from one domain to another using Docker Compose, follow the steps below.  
   
1. **Create the project directory structure:**  
   
```sh  
mkdir -p nginx-redirect  
cd nginx-redirect  
```  
   
2. **Create an Nginx configuration file (`redirect.conf`):**  
   
Inside the `nginx-redirect` directory, create a file named `redirect.conf` with the following content:  
   
```nginx  
# nginx-redirect/redirect.conf  
server {  
    listen 80;  
    server_name olddomain.com www.olddomain.com;  
  
    # Redirect all traffic to the new domain  
    return 301 https://newdomain.com$request_uri;  
}  
```  
   
This configuration listens for HTTP requests on port 80 for `olddomain.com` and `www.olddomain.com` and redirects them with an HTTP 301 (Moved Permanently) status code to `https://newdomain.com`, preserving the request URI.  
   
3. **Create a `docker-compose.yml` file:**  
   
In the same directory, create a `docker-compose.yml` file with the following content:  
   
```yaml  
# nginx-redirect/docker-compose.yml  
version: '3.8'  
   
services:  
  nginx:  
    image: nginx:alpine  
    container_name: nginx_redirect  
    ports:  
      - "80:80"  
    volumes:  
      - ./redirect.conf:/etc/nginx/conf.d/default.conf:ro  
```  
   
This `docker-compose.yml` file defines a single service using the `nginx:alpine` image. It maps port 80 on the host to port 80 in the container and mounts the `redirect.conf` file to the default configuration directory of Nginx inside the container.  
   
4. **Start the project:**  
   
Run the following command in the root of the `nginx-redirect` directory to start the Nginx container:  
   
```sh  
docker-compose up -d  
```  
   
After running this command, Nginx will start, and any requests to `http://olddomain.com` or `http://www.olddomain.com` will be redirected to `https://newdomain.com`.  
   
Please note that to test this locally, you'll need to modify your `hosts` file to point `olddomain.com` and `www.olddomain.com` to your local machine's IP address (usually `127.0.0.1`). Additionally, `newdomain.com` should be a domain that you can access, either a local development domain or an actual live domain.  
   
To add entries to your `hosts` file, you would add lines like:  
   
```  
127.0.0.1   olddomain.com  
127.0.0.1   www.olddomain.com  
```  
   
Remember, this is a basic example for demonstration purposes. In a production environment, you would handle SSL/TLS termination, use domain names that you own, and manage DNS settings to point those domains to your server's IP address.
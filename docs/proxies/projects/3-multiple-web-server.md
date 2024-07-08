To use Nginx as a web server to serve multiple static websites, you can create a Docker Compose setup where each website has its own service and volume for content. In this setup, Nginx will serve as a web server with server blocks (similar to virtual hosts in Apache) to handle multiple domains or subdomains.  
   
First, create a directory structure for your project:  
   
```sh  
mkdir -p nginx-multi-static/sites/site1  
mkdir -p nginx-multi-static/sites/site2  
cd nginx-multi-static  
```  
   
In each `site` directory, create a simple `index.html` file:  
   
```html  
<!-- nginx-multi-static/sites/site1/index.html -->  
<!DOCTYPE html>  
<html lang="en">  
<head>  
    <meta charset="UTF-8">  
    <title>Site 1</title>  
</head>  
<body>  
    <h1>Welcome to Site 1!</h1>  
</body>  
</html>  
```  
   
```html  
<!-- nginx-multi-static/sites/site2/index.html -->  
<!DOCTYPE html>  
<html lang="en">  
<head>  
    <meta charset="UTF-8">  
    <title>Site 2</title>  
</head>  
<body>  
    <h1>Welcome to Site 2!</h1>  
</body>  
</html>  
```  
   
Next, create the Nginx configuration. In the root of the `nginx-multi-static` directory, create a `nginx.conf` file:  
   
```nginx  
# nginx-multi-static/nginx.conf  
events {}  
   
http {  
    include       mime.types;  
    default_type  application/octet-stream;  
    sendfile        on;  
    keepalive_timeout  65;  
  
    server {  
        listen 80;  
        server_name site1.local;  
  
        location / {  
            root /usr/share/nginx/site1;  
            index index.html index.htm;  
        }  
    }  
  
    server {  
        listen 80;  
        server_name site2.local;  
  
        location / {  
            root /usr/share/nginx/site2;  
            index index.html index.htm;  
        }  
    }  
}  
```  
   
Now, create the `docker-compose.yml` file in the root of the `nginx-multi-static` directory:  
   
```yaml  
# nginx-multi-static/docker-compose.yml  
version: '3.8'  
   
services:  
  nginx:  
    image: nginx:alpine  
    container_name: nginx_static_websites  
    ports:  
      - "80:80"  
    volumes:  
      - ./nginx.conf:/etc/nginx/nginx.conf:ro  
      - ./sites/site1:/usr/share/nginx/site1  
      - ./sites/site2:/usr/share/nginx/site2  
    networks:  
      - web_network  
   
networks:  
  web_network:  
    driver: bridge  
```  
   
This `docker-compose.yml` file defines a single Nginx service with two volumes mounted, each containing the static content for a different website. The custom `nginx.conf` is also mounted to define the server blocks for each site.  
   
To start the project, run the following command in the root of the `nginx-multi-static` directory:  
   
```sh  
docker-compose up -d  
```  
   
After the container starts, you can access each static site using the server name specified in the `nginx.conf` file (e.g., `site1.local` and `site2.local`). You'll need to add entries to your hosts file (`/etc/hosts` on Linux and macOS, `C:\Windows\System32\drivers\etc\hosts` on Windows) to resolve these domains to your localhost for testing:  
   
```  
127.0.0.1   site1.local  
127.0.0.1   site2.local  
```  
   
Now, navigating to `http://site1.local` or `http://site2.local` in a browser should display the respective static site's content.  
   
Keep in mind that in a real production setup, you would likely be using actual domain names and SSL/TLS certificates, and you would need
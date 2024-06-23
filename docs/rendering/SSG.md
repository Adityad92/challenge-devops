**Static Site Generation (SSG)**

1. Build the Next.js app for production:

```bash
npm run build
```

This will generate a static version of your Next.js app in the `.next/static` folder.

2. Create an Nginx configuration file (`nginx.conf`):

```nginx
events {
  worker_connections 1024;
}

http {
  server {
    listen 80;
    server_name example.com;

    root /usr/share/nginx/html;
    index index.html;

    location / {
      try_files $uri $uri/ /index.html;
    }
  }
}
```

This Nginx configuration serves the static files from the `.next/static` folder and handles client-side routing correctly.

3. Create a Dockerfile:

```dockerfile
FROM nginx:latest

COPY .next/static /usr/share/nginx/html
COPY nginx.conf /etc/nginx/conf.d/default.conf
```

This Dockerfile copies the `.next/static` folder to the appropriate location inside the Nginx image and replaces the default Nginx configuration with the one we created.

4. Build and run the Docker container:

```bash
docker build -t my-ssg-app .
docker run -p 80:80 my-ssg-app
```

This will build the Docker image and run a container that serves the statically generated Next.js app on `http://localhost`.
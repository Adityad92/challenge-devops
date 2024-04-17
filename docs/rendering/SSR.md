
**Server-Side Rendering (SSR) with Next.js**

For the SSR example, we'll use Next.js, which provides both server-side rendering and static file serving.

1. Build the Next.js app for production:

```bash
npm run build
```

This will generate an optimized production build in the `.next` folder.

2. Create an Nginx configuration file (`nginx.conf`):

```nginx
events {
  worker_connections 1024;
}

http {
  server {
    listen 80;
    server_name example.com;

    location / {
      proxy_pass http://localhost:3000;
      proxy_http_version 1.1;
      proxy_set_header Upgrade $http_upgrade;
      proxy_set_header Connection 'upgrade';
      proxy_set_header Host $host;
      proxy_cache_bypass $http_upgrade;
    }
  }
}
```

This Nginx configuration proxies all requests to the Next.js server running on `http://localhost:3000`.

3. Create a Dockerfile:

```dockerfile
FROM node:14-alpine

WORKDIR /app

COPY package*.json ./
RUN npm install

COPY . .

RUN npm run build

ENV NODE_ENV production

CMD ["npm", "start"]

FROM nginx:latest

COPY --from=0 /app/.next /app/.next
COPY --from=0 /app/nginx.conf /etc/nginx/conf.d/default.conf
```

This multi-stage Dockerfile first builds the Next.js app using the Node.js base image, and then copies the built `.next` folder and the Nginx configuration to the Nginx image.

4. Build and run the Docker container:

```bash
docker build -t my-ssr-app .
docker run -p 80:80 my-ssr-app
```

This will build the Docker image and run a container that serves the SSR app on `http://localhost`. Nginx will proxy requests to the Next.js server, which will render pages on the server and serve them to the client.

Note that in the SSR example, we're running both Nginx and the Next.js server inside the same Docker container. In a production environment, you might want to separate them into different containers for better scalability and resource management.

These examples should give you a good starting point for setting up production-ready CSR and SSR applications using Docker and Nginx. You can further customize the configurations based on your specific requirements, such as adding HTTPS support, configuring caching, or setting up a reverse proxy.

Sure, here's an example of how you can set up a production-ready environment for Static Site Generation (SSG) and Incremental Static Regeneration (ISR) using Next.js and Nginx.


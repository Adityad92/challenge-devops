**Client-Side Rendering (CSR) with Create React App**

For the CSR example, we'll use Create React App, which provides a production build process that generates optimized static files.

1. Build the React app for production:

First, let's create a new React app using create-react-app:
```bash
npx create-react-app my-csr-app
cd my-csr-app
```

```bash
npm run build
```

This will generate a `build` folder containing the optimized static files.

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

This Nginx configuration serves the static files from the `build` folder and handles client-side routing correctly.

3. Create a Dockerfile:

```dockerfile
FROM nginx:latest

COPY build /usr/share/nginx/html
COPY nginx.conf /etc/nginx/conf.d/default.conf
```

This Dockerfile copies the `build` folder to the appropriate location inside the Nginx image and replaces the default Nginx configuration with the one we created.

4. Build and run the Docker container:

```bash
docker build -t my-csr-app .
docker run -p 80:80 my-csr-app
```

```bash
version: '3'
services:
  app:
    build: .
    ports:
      - '3000:3000'
    volumes:
      - ./:/app
      - /app/node_modules
```


This will build the Docker image and run a container that serves the CSR app on `http://localhost`.


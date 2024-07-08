An Ingress controller in Kubernetes is a component that manages external access to services within a cluster, typically HTTP and HTTPS traffic. Instead of exposing each service on a separate port on the host machine, an Ingress controller provides a single entry point for external traffic and can route that traffic to various services within the cluster based on rules defined in Ingress resources.  
   
Here's how an Ingress controller can help manage access to multiple services without exposing a range of ports:  
   
1. **Single Entry Point:** The Ingress controller is typically exposed on standard HTTP and HTTPS ports (80 and 443). All incoming traffic enters through these ports.  
   
2. **Host or Path-Based Routing:** Ingress rules determine how traffic should be routed to different services. You can route traffic based on the requested host (e.g., `service1.example.com` goes to `Service1`, `service2.example.com` goes to `Service2`) or the URL path (e.g., `example.com/service1` goes to `Service1`, `example.com/service2` goes to `Service2`).  
   
3. **Centralized Management:** Ingress makes it easier to manage access to services, providing features such as SSL/TLS termination, name-based virtual hosting, and path-based routing, all from a centralized resource.  
   
4. **Reduced Complexity:** Instead of managing many port mappings and external IPs, you manage a single set of Ingress rules for all your services.  
   
Here is an example of how you might define an Ingress resource to route traffic to two different services based on the path:  
   
```yaml  
apiVersion: networking.k8s.io/v1  
kind: Ingress  
metadata:  
  name: example-ingress  
  annotations:  
    nginx.ingress.kubernetes.io/rewrite-target: /  
spec:  
  rules:  
  - http:  
      paths:  
      - path: /service1  
        pathType: Prefix  
        backend:  
          service:  
            name: service1  
            port:  
              number: 80  
      - path: /service2  
        pathType: Prefix  
        backend:  
          service:  
            name: service2  
            port:  
              number: 80  
```  
   
In this example, requests to `http://<ingress-controller-ip>/service1` are routed to `Service1`, and requests to `http://<ingress-controller-ip>/service2` are routed to `Service2`.  
   
To use Ingress in KIND, you would typically:  
   
1. Set up a cluster with an Ingress controller installed. KIND has built-in support for Ingress, and you can install popular Ingress controllers like Nginx or Traefik.  
2. Define Ingress resources as shown above to route external traffic to your services.  
   
Keep in mind that Ingress is generally used for HTTP and HTTPS traffic. If you need to manage non-HTTP/S traffic or require exposing a range of ports, Ingress might not be the right solution, and you will need to look into other options such as NodePort, LoadBalancer, or HostPort services.
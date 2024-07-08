Below are examples of advanced Kubernetes ConfigMap and Secret YAML files with comments explaining each section.  
   
**ConfigMap:**  
   
```yaml  
apiVersion: v1                        # The API version for the ConfigMap  
kind: ConfigMap                       # The kind of the Kubernetes resource  
metadata:  
  name: mywebapp-config               # The name of the ConfigMap  
  namespace: mywebapp-namespace       # The namespace that the ConfigMap belongs to  
data:  
  # Literal values  
  database_url: jdbc:mysql://db.example.com:3306/mydb  
  feature_flag: "true"  
    
  # File-like data can be represented using multi-line strings  
  app_properties: |  
    color.good=purple  
    color.bad=yellow  
    allow.user.creation=true  
  
  # Another file-like entry  
  log_config.json: |  
    {  
      "level": "info",  
      "format": "text"  
    }  
```  
   
This ConfigMap contains both literal key-value pairs and multi-line string data that can represent file contents. The `data` section can be used by Pods as environment variables or as files when mounted into a Pod's volume.  
   
**Secret:**  
   
```yaml  
apiVersion: v1                        # The API version for the Secret  
kind: Secret                          # The kind of the Kubernetes resource  
metadata:  
  name: mywebapp-secret               # The name of the Secret  
  namespace: mywebapp-namespace       # The namespace that the Secret belongs to  
type: Opaque                          # The type of the Secret (Opaque is the default; other types include kubernetes.io/service-account-token, kubernetes.io/dockercfg, etc.)  
data:  
  # Secrets must be base64 encoded  
  # Use echo -n 'value' | base64 to encode the values before adding them to the data field  
  username: dXNlcm5hbWU=              # Base64 representation of 'username'  
  password: cGFzc3dvcmQ=              # Base64 representation of 'password'  
    
  # File-like data encoded in base64  
  ssl_cert.pem: LS0tLS1CRUdJTiBDRVJUSUZJQ0... (certificate data)  
  ssl_key.pem: LS0tLS1CRUdJTiBQUklWQVRFIEtF... (key data)  
```  
   
The Secret resource is similar to a ConfigMap but is used to store sensitive information such as passwords, OAuth tokens, and SSH keys. The values in the `data` field are base64 encoded to maintain the byte format and should not be considered encryption. When using these secrets, they can be mounted as volumes or exposed as environment variables to be used by containers in a Pod.  
   
**Important Note:** Secrets should be managed carefully. You should not commit them to source control in plain text and should consider using a secret management tool or encrypting them if they are to be stored in a repository.  
   
Both ConfigMaps and Secrets can be used in Pods in the following ways:  
   
- As files in a volume mounted on one or more of its containers.  
- As environment variables for containers to consume.  
- For Secrets, additionally as command-line arguments for containers.  
   
To use these resources, reference them in the Pod specification according to your needs.

---

**Here's an example of how you can reference ConfigMaps and Secrets in a Pod specification. This example demonstrates using a ConfigMap to set environment variables and mount configuration files, and using a Secret to set environment variables and mount sensitive files:**
   
```yaml  
apiVersion: v1  
kind: Pod  
metadata:  
  name: mywebapp-pod  
  namespace: mywebapp-namespace  
spec:  
  containers:  
    - name: mywebapp-container  
      image: mywebapp:latest  
      ports:  
        - containerPort: 8080  
      env: # Set environment variables from ConfigMap and Secret  
        - name: DATABASE_URL  
          valueFrom:  
            configMapKeyRef:  
              name: mywebapp-config  
              key: database_url  
        - name: FEATURE_FLAG  
          valueFrom:  
            configMapKeyRef:  
              name: mywebapp-config  
              key: feature_flag  
        - name: USERNAME  
          valueFrom:  
            secretKeyRef:  
              name: mywebapp-secret  
              key: username  
        - name: PASSWORD  
          valueFrom:  
            secretKeyRef:  
              name: mywebapp-secret  
              key: password  
      volumeMounts: # Mount ConfigMap and Secret as volumes  
        - name: config-volume  
          mountPath: /etc/config  
        - name: secret-volume  
          mountPath: /etc/secret  
          readOnly: true # It's good practice to mount secrets as read-only  
  volumes:  
    - name: config-volume  
      configMap:  
        name: mywebapp-config  
        items:  
          - key: app_properties  
            path: app.properties  
          - key: log_config.json  
            path: log_config.json  
    - name: secret-volume  
      secret:  
        secretName: mywebapp-secret  
        items:  
          - key: ssl_cert.pem  
            path: ssl_cert.pem  
          - key: ssl_key.pem  
            path: ssl_key.pem  
```  
   
This Pod specification includes the following:  
   
- Environment variables populated from a ConfigMap (`DATABASE_URL` and `FEATURE_FLAG`) and from a Secret (`USERNAME` and `PASSWORD`).  
- A volume named `config-volume` that is created from the `mywebapp-config` ConfigMap. Two files (`app.properties` and `log_config.json`) are mounted from the ConfigMap keys into the `/etc/config` directory inside the container.  
- A volume named `secret-volume` that is created from the `mywebapp-secret` Secret. Two files (`ssl_cert.pem` and `ssl_key.pem`) are mounted from the Secret keys into the `/etc/secret` directory inside the container. The `readOnly: true` attribute is set because it's a best practice to make secret volumes read-only to prevent accidental modification.  
   
Remember to base64 encode your Secret data and to ensure that the ConfigMap and Secret exist in the specified namespace before creating the Pod that references them.
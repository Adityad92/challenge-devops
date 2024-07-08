Here's the complete YAML file for a Kubernetes Deployment, including comments that explain each section:  
   
```yaml  
apiVersion: apps/v1                  # The API version for the Deployment  
kind: Deployment                     # The kind of the Kubernetes resource  
metadata:  
  name: mywebapp-deployment          # The name of the Deployment  
  labels:  
    app: mywebapp                    # The labels to apply to the Deployment for identification  
spec:  
  replicas: 3                        # The number of desired pod replicas  
  selector:                          # The label selector used to identify the Pods managed by this Deployment  
    matchLabels:  
      app: mywebapp  
  strategy:                          # The strategy for updating Pods  
    type: RollingUpdate              # The rolling update strategy ensures no downtime during updates  
    rollingUpdate:  
      maxUnavailable: 1              # The maximum number of Pods that can be unavailable during the update  
      maxSurge: 1                    # The maximum number of Pods that can be created over the desired number of Pods  
  template:                          # The pod template that the Deployment will manage  
    metadata:  
      labels:  
        app: mywebapp                # The labels to apply to the Pods  
    spec:  
      containers:  
      - name: webapp-container       # The name of the container within the Pod  
        image: mywebapp:1.2.3        # The container image to use  
        ports:  
        - containerPort: 8080        # The container port to expose  
        readinessProbe:              # The probe to check if the container is ready to serve traffic  
          httpGet:  
            path: /ready             # The HTTP path for the readiness probe  
            port: 8080               # The container port for the readiness probe  
          initialDelaySeconds: 5     # Delay before the readiness probe is initiated  
          periodSeconds: 10          # How often to perform the probe  
        livenessProbe:               # The probe to check if the container is alive and healthy  
          httpGet:  
            path: /live              # The HTTP path for the liveness probe  
            port: 8080               # The container port for the liveness probe  
          initialDelaySeconds: 15    # Delay before the liveness probe is initiated  
          periodSeconds: 20          # How often to perform the probe  
        env:                         # The environment variables for the container  
        - name: ENV_VAR_NAME  
          value: "value"  
        - name: SECRET_KEY           # An example of using a Kubernetes Secret as an environment variable  
          valueFrom:  
            secretKeyRef:  
              name: mywebapp-secret  # The name of the Secret resource  
              key: secret_key        # The key within the Secret resource  
        volumeMounts:                # The volume mounts for the container  
        - name: config-volume  
          mountPath: /etc/config     # The mount path for the ConfigMap volume  
      volumes:                       # The volumes available for mounting into containers  
      - name: config-volume  
        configMap:  
          name: mywebapp-config      # The name of the ConfigMap to mount as a volume  
  minReadySeconds: 5                 # How long a Pod should be ready without crashing to be considered available  
  revisionHistoryLimit: 10           # The number of old ReplicaSets to keep for rollback  
  progressDeadlineSeconds: 600       # The timeout for the Deployment to be marked as failed if no progress  
    affinity:                               # Rules that specify which nodes the Pods should be placed on  
    nodeAffinity:                         # Node affinity is conceptually similar to `nodeSelector` but allows for more expressive rules  
        requiredDuringSchedulingIgnoredDuringExecution: # If the affinity requirements specified by this field are not met at scheduling time, the pod will not be scheduled onto the node  
        nodeSelectorTerms:  
        - matchExpressions:  
            - key: disktype  
            operator: In  
            values:  
            - ssd                             # This example requires the node to have a label with key `disktype` and value `ssd`  
        preferredDuringSchedulingIgnoredDuringExecution: # The scheduler will try to enforce these but will not guarantee it  
        - weight: 1  
        preference:  
            matchExpressions:  
            - key: another-node-label-key  
            operator: Exists                  # This example prefers nodes with the label `another-node-label-key` regardless of its value  
    tolerations:                             # Tolerations allow (but do not require) the Pods to schedule onto nodes with matching taints  
    - key: "key"  
    operator: "Equal"  
    value: "value"  
    effect: "NoSchedule"                    # This toleration allows Pods to be scheduled on nodes with a taint of `key=value:NoSchedule`  
    resources:                               # Define resource requests and limits for the container  
    requests:  
        cpu: "500m"                          # The container requests 500 milli CPU units  
        memory: "128Mi"                      # The container requests 128 MiB of memory  
    limits:  
        cpu: "1000m"                         # The container is limited to 1000 milli CPU units  
        memory: "256Mi"                      # The container is limited to 256 MiB of memory  
    securityContext:                        # Security options the Pod should run with  
    runAsUser: 1000                        # The UID to run the entrypoint of the container process  
    runAsGroup: 3000                       # The GID to run the entrypoint of the container process  
    fsGroup: 2000                          # The GID associated with the container's filesystem  
    readOnlyRootFilesystem: true           # Mount the container's root filesystem as read-only  
    serviceAccountName: mywebapp-sa          # The name of the ServiceAccount to use to run this Pod  
    imagePullSecrets:                        # An array of references to secret resources containing credentials for pulling the container image  
    - name: my-image-pull-secret  
```  
    
This additional configuration provides more advanced features, such as:  
    - `affinity` and `tolerations`, which control where Pods are scheduled based on node labels and taints.  
    - `resources`, which specify the CPU and memory that the container requests for scheduling and the maximum resources it can consume.  
    - `securityContext`, which defines the security-related settings for the Pod, like user/group ID and file system permissions.  
    - `serviceAccountName`, which specifies the ServiceAccount under which the Pods will run.  
    - `imagePullSecrets`, which allows specifying Docker registry credentials for pulling private images.  

Keep in mind that this deployment specification is just an example, and the actual details would depend on the specific requirements of your application, the infrastructure of your Kubernetes cluster, and your organization's policies.  

Before using this template, you would need to create the necessary `ConfigMap`, `Secret`, `ServiceAccount`, and `imagePullSecret` objects referenced in the deployment. Additionally, you should adjust the resource requests and limits to suit your
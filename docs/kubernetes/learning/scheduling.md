Advanced scheduling and node management in Kubernetes involve several concepts including node selectors, affinity and anti-affinity, taints and tolerations, and custom scheduler implementation. Let’s go through some examples that illustrate these concepts:  
   
**Node Selector:**  
   
Node selectors allow you to constrain Pods to run on specific nodes. Here’s an example of using a node selector to schedule a Pod onto a node with specific labels:  
   
```yaml  
apiVersion: v1  
kind: Pod  
metadata:  
  name: with-node-selector  
spec:  
  containers:  
  - name: nginx-container  
    image: nginx  
  nodeSelector: # Key-value pairs must match node labels  
    disktype: ssd  
    department: finance  
```  
   
In this example, the Pod will only be scheduled onto a node that has both labels `disktype=ssd` and `department=finance`.  
   
**Affinity and Anti-affinity:**  
   
Affinity and anti-affinity provide more granular control over node selection than node selectors. They allow you to specify rules that limit which nodes your Pod can be scheduled on based on the labels on nodes and other Pods.  
   
```yaml  
apiVersion: v1  
kind: Pod  
metadata:  
  name: with-affinity  
spec:  
  containers:  
  - name: nginx-container  
    image: nginx  
  affinity: # More expressive way to specify scheduling preferences  
    nodeAffinity:  
      requiredDuringSchedulingIgnoredDuringExecution: # Hard requirement  
        nodeSelectorTerms:  
        - matchExpressions:  
          - key: disktype  
            operator: In  
            values:  
            - ssd  
      preferredDuringSchedulingIgnoredDuringExecution: # Soft requirement  
      - weight: 1  
        preference:  
          matchExpressions:  
          - key: department  
            operator: In  
            values:  
            - finance  
    podAntiAffinity: # Prefer not to co-locate with other nginx pods  
      preferredDuringSchedulingIgnoredDuringExecution:  
      - weight: 100  
        podAffinityTerm:  
          labelSelector:  
            matchExpressions:  
            - key: app  
              operator: In  
              values:  
              - nginx  
          topologyKey: kubernetes.io/hostname  
```  
   
**Taints and Tolerations:**  
   
Taints and tolerations work together to ensure that Pods are not scheduled onto inappropriate nodes. Taints are applied to nodes, and tolerations are applied to Pods.  
   
Node taint example (to be applied with `kubectl taint nodes`):  
```  
kubectl taint nodes node1 key=value:NoSchedule  
```  
   
This taint will prevent any Pods from being scheduled on `node1` unless they have a matching toleration.  
   
Pod toleration example:  
   
```yaml  
apiVersion: v1  
kind: Pod  
metadata:  
  name: with-tolerations  
spec:  
  containers:  
  - name: nginx-container  
    image: nginx  
  tolerations: # Allows a pod to schedule onto nodes with matching taints  
  - key: "key"  
    operator: "Equal"  
    value: "value"  
    effect: "NoSchedule"  
```  
   
**Custom Scheduler:**  
   
You can also write your own scheduler if the default Kubernetes scheduler does not meet your needs. To use your custom scheduler, specify its name in the `schedulerName` field.  
   
```yaml  
apiVersion: v1  
kind: Pod  
metadata:  
  name: with-custom-scheduler  
spec:  
  containers:  
  - name: nginx-container  
    image: nginx  
  schedulerName: my-custom-scheduler # Name of the custom scheduler  
```  
   
A custom scheduler requires you to write a program that watches for new Pods and assigns them to nodes according to your custom logic. This program runs alongside the default scheduler or replaces it entirely.  
   
These are just a few examples of the advanced scheduling and node management features available in Kubernetes. Understanding these
Volumes and Persistent Storage in Kubernetes are extensive topics, encompassing various types of volumes, storage classes, persistent volume claims (PVCs), and stateful workloads. Here is an example of an advanced PersistentVolume (PV), a PersistentVolumeClaim (PVC), and a Pod that uses the PVC. These examples come with comments to explain the various configurations.  
   
**PersistentVolume (PV):**  
   
```yaml  
apiVersion: v1  
kind: PersistentVolume  
metadata:  
  name: mywebapp-pv  
  labels:  
    type: local  
spec:  
  capacity:  
    storage: 10Gi # The size of the volume  
  accessModes:  
    - ReadWriteOnce # The volume can be mounted as read-write by a single node  
  persistentVolumeReclaimPolicy: Retain # What happens to the PV data after the PVC is released (other options: Delete, Recycle)  
  storageClassName: mywebapp-storage-class # The name of the StorageClass associated with this PV  
  local: # Type of the volume (local, nfs, iscsi, etc.)  
    path: /mnt/disks/ssd1 # The path to the volume on the node  
  nodeAffinity: # Node labels for setting constraints on which nodes this volume can be accessed  
    required:  
      nodeSelectorTerms:  
      - matchExpressions:  
        - key: kubernetes.io/hostname  
          operator: In  
          values:  
          - my-node-name  
```  
   
**PersistentVolumeClaim (PVC):**  
   
```yaml  
apiVersion: v1  
kind: PersistentVolumeClaim  
metadata:  
  name: mywebapp-pvc  
  namespace: mywebapp-namespace  
spec:  
  accessModes:  
    - ReadWriteOnce # Must match the access modes of the PV  
  resources:  
    requests:  
      storage: 10Gi # Size of the storage requested; should be less than or equal to the PV size  
  storageClassName: mywebapp-storage-class # Should match the storage class of the PV  
```  
   
**Pod that uses the PVC:**  
   
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
      volumeMounts: # Mount the PVC to the Pod  
        - name: mywebapp-storage  
          mountPath: "/var/www/html" # The path inside the container  
  volumes: # Define the PVC as a volume  
    - name: mywebapp-storage  
      persistentVolumeClaim:  
        claimName: mywebapp-pvc # The name of the PVC to use  
```  
   
These YAML files give you an advanced example of how to create a PersistentVolume that is tied to a specific node using node affinity, a PersistentVolumeClaim that requests storage from the PersistentVolume, and a Pod that mounts the PersistentVolumeClaim.  
   
A few important notes:  
- The `storageClassName` in both the PV and PVC should match. This is how the PVC knows which PV to bind to. A `StorageClass` provides a way for administrators to describe the "classes" of storage they offer.  
- The `accessModes` and requested `storage` size in the PVC should be compatible with the PV for the binding process to be successful.  
- The `persistentVolumeReclaimPolicy` dictates what happens to the data after the PVC that is bound to the PV is deleted. `Retain` will keep the data, `Delete` will remove it, and `Recycle` (deprecated) will scrub the data from the volume.  
- The `nodeAffinity` in the PV example ensures that the PV can only be mounted by a Pod running on a node with the specified label (`my-node-name


**StorageClass:**  
   
To fully understand the dynamic provisioning of storage, you should also be familiar with `StorageClass` resources. A `StorageClass` allows you to define different classes of storage, which can be dynamically provisioned as needed. Here's an example of a `StorageClass`:  
   
```yaml  
apiVersion: storage.k8s.io/v1  
kind: StorageClass  
metadata:  
  name: mywebapp-storage-class  
provisioner: kubernetes.io/no-provisioner # or specify your storage provisioner, e.g., kubernetes.io/aws-ebs  
volumeBindingMode: WaitForFirstConsumer # or Immediate  
reclaimPolicy: Delete # or Retain  
```  
   
- `provisioner`: The name of the volume plugin that can provision the storage. Use `kubernetes.io/no-provisioner` for local volumes or specify a provisioner that matches your environment, like `kubernetes.io/gce-pd` for Google Compute Engine persistent disks.  
- `volumeBindingMode`: `WaitForFirstConsumer` means that the volume binding and dynamic provisioning occur once the Pod using the PVC is scheduled. `Immediate` means that the volume binding and dynamic provisioning occur upon PVC creation.  
- `reclaimPolicy`: Defines the policy for retaining volumes once the PVC is deleted. `Delete` will delete the volume, while `Retain` will keep it.  
   
When a `StorageClass` is defined, you can create a PVC that dynamically provisions a new PV as needed:  
   
```yaml  
apiVersion: v1  
kind: PersistentVolumeClaim  
metadata:  
  name: mywebapp-pvc  
  namespace: mywebapp-namespace  
spec:  
  accessModes:  
    - ReadWriteOnce  
  resources:  
    requests:  
      storage: 10Gi  
  storageClassName: mywebapp-storage-class # Name of the StorageClass  
```  
   
If the `storageClassName` is set to an empty string (`storageClassName: ""`), dynamic provisioning is disabled. If the `storageClassName` is omitted, the default `StorageClass` is used, if one exists.  
   
**Using PV and PVC in a Pod:**  
   
The PVC created above can be used by a Pod as a volume. The volume will persist independently of the Pod's lifecycle. Here's how to reference the PVC in a Pod:  
   
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
    volumeMounts:  
    - name: mywebapp-storage  
      mountPath: "/var/www/html"  
  volumes:  
  - name: mywebapp-storage  
    persistentVolumeClaim:  
      claimName: mywebapp-pvc  
```  
   
In this Pod specification:  
- `volumeMounts`: This section mounts the volume inside the container at the specified `mountPath`.  
- `volumes`: This section defines the volumes available to the Pod and references the PVC by its `claimName`.  
   
When this Pod is created, the container will have access to the storage provided by the `mywebapp-pvc`. If the PVC is dynamically provisioned, the storage will be created according to the specifications in the `StorageClass`.  
   
It's important to note that the actual provisioning of the storage depends on the environment where your Kubernetes cluster is running and the `provisioner` specified in the `StorageClass`. The provisioner interacts with the underlying cloud or storage system to allocate the resources.
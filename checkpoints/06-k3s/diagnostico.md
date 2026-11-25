tarte@DESKTOP-FCU0IKS:~/dev/trilha-terminal$ kubectl -n trilha-debug get pods
NAME                        READY   STATUS             RESTARTS      AGE
quebrado-595c6d4769-ngj95   1/1     Running            3 (18m ago)   54m
quebrado-84bb7cf887-sp6ln   0/1     ImagePullBackOff   0             52m
tarte@DESKTOP-FCU0IKS:~/dev/trilha-terminal$ kubectl describe pod quebrado-84bb7cf887-sp6ln -n trilha
trilha        trilha-debug  
tarte@DESKTOP-FCU0IKS:~/dev/trilha-terminal$ kubectl describe pod quebrado-84bb7cf887-sp6ln -n trilha-debug 
Name:             quebrado-84bb7cf887-sp6ln
Namespace:        trilha-debug
Priority:         0
Service Account:  default
Node:             desktop-fcu0iks/172.24.109.217
Start Time:       Wed, 25 Nov 2026 11:02:40 -0300
Labels:           app=quebrado
                  pod-template-hash=84bb7cf887
Annotations:      <none>
Status:           Pending
IP:               10.42.0.30
IPs:
  IP:           10.42.0.30
Controlled By:  ReplicaSet/quebrado-84bb7cf887
Containers:
  app:
    Container ID:   
    Image:          trilha-app:9.9.9
    Image ID:       
    Port:           3000/TCP
    Host Port:      0/TCP
    State:          Waiting
      Reason:       ImagePullBackOff
    Ready:          False
    Restart Count:  0
    Readiness:      http-get http://:3000/healthz delay=0s timeout=1s period=5s #success=1 #failure=3
    Environment:    <none>
    Mounts:
      /var/run/secrets/kubernetes.io/serviceaccount from kube-api-access-tgsnv (ro)
Conditions:
  Type                        Status
  PodReadyToStartContainers   True 
  Initialized                 True 
  Ready                       False 
  ContainersReady             False 
  PodScheduled                True 
Volumes:
  kube-api-access-tgsnv:
    Type:                    Projected (a volume that contains injected data from multiple sources)
    TokenExpirationSeconds:  3607
    ConfigMapName:           kube-root-ca.crt
    Optional:                false
    DownwardAPI:             true
QoS Class:                   BestEffort
Node-Selectors:              <none>
Tolerations:                 node.kubernetes.io/not-ready:NoExecute op=Exists for 300s
                             node.kubernetes.io/unreachable:NoExecute op=Exists for 300s
Events:
  Type     Reason          Age                   From               Message
  ----     ------          ----                  ----               -------
  Normal   Scheduled       54m                   default-scheduler  Successfully assigned trilha-debug/quebrado-84bb7cf887-sp6ln to desktop-fcu0iks
  Normal   Pulling         51m (x5 over 54m)     kubelet            Pulling image "trilha-app:9.9.9"
  Warning  Failed          51m (x5 over 54m)     kubelet            Failed to pull image "trilha-app:9.9.9": failed to pull and unpack image "docker.io/library/trilha-app:9.9.9": failed to resolve reference "docker.io/library/trilha-app:9.9.9": pull access denied, repository does not exist or may require authorization: server message: insufficient_scope: authorization failed
  Warning  Failed          51m (x5 over 54m)     kubelet            Error: ErrImagePull
  Normal   BackOff         50m (x12 over 54m)    kubelet            Back-off pulling image "trilha-app:9.9.9"
  Warning  Failed          50m (x12 over 54m)    kubelet            Error: ImagePullBackOff
  Normal   SandboxChanged  40m                   kubelet            Pod sandbox changed, it will be killed and re-created.
  Normal   Pulling         40m                   kubelet            Pulling image "trilha-app:9.9.9"
  Warning  Failed          40m                   kubelet            Failed to pull image "trilha-app:9.9.9": failed to pull and unpack image "docker.io/library/trilha-app:9.9.9": failed to resolve reference "docker.io/library/trilha-app:9.9.9": pull access denied, repository does not exist or may require authorization: server message: insufficient_scope: authorization failed
  Warning  Failed          40m                   kubelet            Error: ErrImagePull
  Normal   BackOff         40m                   kubelet            Back-off pulling image "trilha-app:9.9.9"
  Warning  Failed          40m                   kubelet            Error: ImagePullBackOff
  Normal   SandboxChanged  33m                   kubelet            Pod sandbox changed, it will be killed and re-created.
  Normal   Pulling         30m (x5 over 33m)     kubelet            Pulling image "trilha-app:9.9.9"
  Warning  Failed          30m (x5 over 33m)     kubelet            Failed to pull image "trilha-app:9.9.9": failed to pull and unpack image "docker.io/library/trilha-app:9.9.9": failed to resolve reference "docker.io/library/trilha-app:9.9.9": pull access denied, repository does not exist or may require authorization: server message: insufficient_scope: authorization failed
  Warning  Failed          30m (x5 over 33m)     kubelet            Error: ErrImagePull
  Normal   BackOff         28m (x21 over 33m)    kubelet            Back-off pulling image "trilha-app:9.9.9"
  Warning  Failed          28m (x21 over 33m)    kubelet            Error: ImagePullBackOff
  Normal   SandboxChanged  20m                   kubelet            Pod sandbox changed, it will be killed and re-created.
  Normal   Pulling         17m (x5 over 20m)     kubelet            Pulling image "trilha-app:9.9.9"
  Warning  Failed          17m (x5 over 20m)     kubelet            Failed to pull image "trilha-app:9.9.9": failed to pull and unpack image "docker.io/library/trilha-app:9.9.9": failed to resolve reference "docker.io/library/trilha-app:9.9.9": pull access denied, repository does not exist or may require authorization: server message: insufficient_scope: authorization failed
  Warning  Failed          17m (x5 over 20m)     kubelet            Error: ErrImagePull
  Normal   BackOff         4m31s (x64 over 20m)  kubelet            Back-off pulling image "trilha-app:9.9.9"
  Warning  Failed          4m31s (x64 over 20m)  kubelet            Error: ImagePullBackOff





------ Aparte acima são os comando que usei para ver o que está acontecendo mais eu consegui achar com a menssagem após usar o ./trilha check06 que indicou 
que a imagem está com dois erros.

os healthz  assim que eu corrigi tirando os z o pod voltou a funcionar.

Passo excutado com sucesso!!!


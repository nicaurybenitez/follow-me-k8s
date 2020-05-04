
**Key configuration strategies**

**kube-apiserver.**

   

>  High availability using a node-native nginx layer 4 transparent
> proxy.
>     Close non-secure port 8080 and anonymous access.
>     Receive HTTPS requests on secure port 6443.
>     Stringent certification and authorization policies (x509, token, RBAC).
>     Open bootstrap token certification to support kubelet TLS bootstrapping.
>     Use https to access kubelet, etcd, encrypt communication.

**kube-controller-manager.**

>     3. Highly available nodes.
>     Close the non-secure port and receive HTTPS requests on secure port 10252.
>     Use kubeconfig to access the apiserver's secure port.
>     Automatic approve kubelet certificate signature request (CSR) and automatic rotation after certificate expiration.
>     Each controller uses its own ServiceAccount to access the apiserver.

**kube-scheduler.**


>  3. Highly available nodes.
>     Use kubeconfig to access the apiserver's secure port.

**kubelet.**

>     Use kubeadm to create bootstrap tokens dynamically, rather than statically configured in the apiserver.
>     Automatic generation of client and server certificates using the TLS bootstrap mechanism, and automatic rotation after expiration.
>     Configure the main parameters in a JSON file of the KubeletConfiguration type.
>     Close the read-only port, receive HTTPS requests on secure port 10250, authenticate and authorize the requests, and deny anonymous and
> unauthorized access.
>     Use kubeconfig to access the apiserver's secure port.

**kube-proxy.**

>     Use kubeconfig to access the apiserver's secure port.
>     Configure the main parameters in a JSON file of the KubeProxyConfiguration type.
>     Use of the IPVS proxy model.

**Cluster plug-ins.**

>     DNS: use of functional, better performing coredns.
>     Dashboard: supports login authentication.
>     Metric: metrics-server, using https to access the kubelet security port
>     Log: Elasticsearch, Fluend, Kibana.
>     Registry repositories: docker-registry, harbor.
> 
> 
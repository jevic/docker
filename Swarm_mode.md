Swarm mode 核心概念
------
### Swarm
> Docker Engine 内置的集群管理和编排功能是利用 SwarmKit 实现的。集群中的 Engine 在 swarm 模式下运行。你可以通过初始化一个 swarm 集群或者加入一个存在的 swarm 集群来激活 Engine 的 swarm 模式。
Swarm 是你部署服务的一个集群。 Docker Engine CLI 已经内置了swarm 管理的相关命令，像添加，删除节点等。 CLI 也内置了在 swarm 上部署服务以及管理服务编排的命令。
在非 swarm mode 下，你只能执行容器命令。在 swarm mode 下，你可以编排服务。

### Node
> Node 是 Docker Engine 加入到 swarm 的一个实例。
你可以通过向 manager node 提交一个服务描述来部署应用到 swarm 集群。manager node 调度工作单元--任务，到 worker node。
Manager node 也负责提供维护 swarm 状态所需要的编排和集群管理功能。 Manager node 选举一个 leader 来管理任务编排。
Worker node 接收并执行从 manager node 调度过来的任务。
在默认情况下， manager node 同时也是 worker node，当然你可以配置 manager node 只充当管理角色不参与任务执行。Manager 根据 agent 提供的任务当前状态来维护目标状态。

### Services and tasks
> service 指的是在 worker node 上执行的任务的描述。service 是 swarm 系统的中心架构，是用户跟 swarm 交互的基础。
在你创建 service 时， 你需要指定容器镜像，容器里面执行的命令等。
在 replicated service 模式下， swarm 根据你设置的 scale(副本) 数部署在集群中部署指定数量的任务副本。
在 global service 模式下， swarm 在集群每个可用的机器上运行一个 service 的任务。
task 指的是一个 Docker 容器以及需要在该容器内运行的命令。 task 是 swarm 的最小调度单元。 manager node 根据 service scale 的副本数量将 task 分配到 worker node 上。 
被分配到一个 node 上的 task 不会被莫名移到另一个 node 上，除非运行失败。

### Load balancing
> swarm manager 用 ingress load balancing 来对外暴露 service 。 swarm manager 能够自动的为 service 分配对外端口，当然，你也可以为 service 在 30000-32767 范围内指定端口。+
外部组件，譬如公有云的负载均衡器，都可以通过集群中任何主机的上述端口来访问 service ，无论 service 的 task 是否正运行在这个主机上。 
swarm 中的所有主机都可以路由 ingress connections 到一个正在运行着的 task 实例上。
* Swarm mode 有一个内部的 DNS 组件来自动为每个 service 分配 DNS 入口。 swarm manager 根据 service 在集群中的 DNS name 使用内部负载均衡来分发请求。

## 参考文档
> [Docker 1.12迎来内置编排机制](http://dockone.io/article/1442)
[Docker 1.12: Now With Built-In Orchestration!](https://blog.docker.com/2016/06/docker-1-12-built-in-orchestration/)
[Swarm mode overview](https://docs.docker.com/engine/swarm/)
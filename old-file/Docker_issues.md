#### Docker Swarm 相关问题 #
#### Docker 多宿主网络怎么配置？ #
#### 配置示例
	https://gist.github.com/twang2218/def4097648deac398a949b58e2a31610
	其中两个脚本:
	带swarm一起玩 overlay：build-overlay-with-swarm.sh
	不带swarm玩，直接构建overlay：build-overlay-without-swarm.sh

#### Swarm环境中怎么指定某个容器在指定的宿主上运行呢？ #
	每个 Docker Host 建立时都可以通过 --label 指定其 Docker Daemon 的标签，比如：
	docker daemon \
		--label com.example.environment="production" \
		--label com.example.storage="ssd"
	注意，上面的配置参数应该配置在 docker daemon 的配置文件里，如 docker.service，而不是简单的命令行执行……
	然后运行容器时，使用环境变量约束调度即可。可以使用 Compose 文件的 environment 配置，也可以使用 docker run 的 -e 环境变量参数。
	下面以 Compose 配置文件为例：
	version: "2"
	services:
	mongodb:
		image: mongo:latest
		environment:
		- "constraint:com.example.storage==ssd"
	这样这个 mongodb 的服务就会运行在标记为 com.example.storage="ssd" 的宿主上运行。

#### Label 和metadata ？
	1、label 就是 metadata 的一部分。
	2、Docker 很多东西都可以加 label, 比如镜像、容器、Docker engine, Swarm Node, Service, Network, 卷等等。
	对应的 ps/ls 的时候可以过滤。而且运行容器的时候也可以过滤。这样才可以控制所要操作的具体是集群中的哪一部分资源。
	https://docs.docker.com/engine/userguide/labels-custom-metadata/

#### Docker daemon：
	https://docs.docker.com/engine/reference/commandline/dockerd/



# hadoop 单机/伪分布式部署
## 运行示例

```

docker run -d --name hadoop \
-p 50070:50070 -p 9000:9000 -p 2222:22 \
-v /data/hadoop/dfs:/opt/hadoop/tmp \
hadoop:[tag]

```


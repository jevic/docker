## 基于企业微信号、钉钉 API接口 二次封装用于做报警接口的应用

### 配置说明
- 指定报警媒介:
    - APP = ALL   同时启用企业微信号及钉钉配置信息
    - APP = dingding 只启用钉钉
    - APP = weixin  只启用企业微信
- 企业微信号(weixin)
    -  CORPID   企业微信 CorpID
    -  SECRET   微信应用 Secret
    -  AGENTID  微信应用 AgentId
- 钉钉(dingding)
    - DTOKEN  钉钉接口Token


### 接口说明
- /weixin?content=test 企业微信号
- /dingding?content=test 钉钉
- /send_message?content=test 同时发送到企业微信号和钉钉
- /upload 文件上传(只支持企业微信号)

### 运行示例
```
docker run -d \
--name alarm \
-e APP=all
-e SECRET="xxxx" \
-e CORPID="xxxx" \
-e AGENTID=xxx \
-e DTOKEN="xxxx" \
-p 51001:51001 \
jevic/alarm:latest

```

#### Shell

```
#!/bin/bash
wechat()
{
                DT_ADDR='127.0.0.1:51001'
                #处理下编码，用于合并告警内容的标题和内容
                #中文需要utf8编码并进行urlencode
                message=$(echo -e "$title\n$content"|od -t x1 -A n -v -w1000000000 | tr " " %)
                DT_URL="http://$DT_ADDR/send_message?content=$message"
                /usr/bin/curl $DT_URL
}

#title=test
#content=test
#wechat

```

### Python

```
#!/usr/bin/python
# coding: utf-8
#
from urllib import quote
import urllib2
import sys

reload(sys)
sys.setdefaultencoding('utf-8')

def wechat(title,content):
        Title = quote(title.encode('utf8'))
        Content = quote(content.encode('utf8'))
        API_URL="http://127.0.0.1:51001/send_message?content=%s%s" % (Title,Content)
        try:
            req = urllib2.Request(API_URL)
            result = urllib2.urlopen(req)
            res = result.read()
        except:
            print "error"


```

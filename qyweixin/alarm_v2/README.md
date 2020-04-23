## Python

```
import requests

url = "http://192.168.1.12:5100/alarm"

payload = "{\"msg\":\"xxxx页面访问异常\"}"
headers = {
    'Content-Type': "application/json",
    }

response = requests.request("POST", url, data=payload, headers=headers)

print(response.text)
```

## Shell

```
#!/bin/bash

wechat(){
curl -X POST \
  http://127.0.0.1:5100/alarm \
  -H 'Content-Type: application/json' \
  -d '{
    "msg": "'$msg'"
}'
}

msg='test'
wechat
```

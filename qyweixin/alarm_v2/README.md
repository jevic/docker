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
curl -X POST \
  http://192.168.1.12:5100/alarm \
  -H 'Content-Type: application/json' \
  -d '{"msg":"xxx页面访问异常"}'
```

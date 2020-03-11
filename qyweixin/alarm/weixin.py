# -*- coding:utf-8 -*-

import urllib3
import json,sys
from os.path import sep,getsize

urllib3.disable_warnings()
http = urllib3.PoolManager()

def Weixin(TOKEN,content):
        SendMessage_API = "https://qyapi.weixin.qq.com/cgi-bin/webhook/send?key=%s" % TOKEN
        Bodys = {
        "msgtype": "text",
        "text": {
            "content": "%s" % content
        }
        }
        try:
            enbody = json.dumps(Bodys).encode('utf-8')
            req = http.request('POST',SendMessage_API,body=enbody,headers={'Content-Type':'application/json'})
        except Exception as e:
            return e



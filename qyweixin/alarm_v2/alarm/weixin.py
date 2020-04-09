# -*- coding:utf-8 -*-
import requests
import json

url = "https://qyapi.weixin.qq.com/cgi-bin/webhook/send"

def Weixin(content):
	querystring = {"key":"TOKEN"}

	payload = {
	        "msgtype": "text",
	        "text": {
	            "content": "%s" % content
	        }
	        }

	headers = {
	    'Content-Type': "application/json",
	    }

	response = requests.request("POST", url, data=json.dumps(payload), headers=headers, params=querystring)

	print(response.text)

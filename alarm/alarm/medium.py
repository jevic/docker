# -*- coding:utf-8 -*-

import urllib3
import json,sys
from os.path import sep,getsize 


urllib3.disable_warnings()
http = urllib3.PoolManager()

class Alarm:
    def __init__(self,Corpid,Corpsecret):
        self.Gettoken = "https://qyapi.weixin.qq.com/cgi-bin/gettoken?corpid=%s&corpsecret=%s" % (Corpid,Corpsecret)
        self.Sends = "https://qyapi.weixin.qq.com/cgi-bin/message/send?access_token="

    @property
    def Token(self):
        '''获取token'''
        try:
            response = http.request('GET',self.Gettoken)
            Datas = response.data
            return json.loads(Datas).get('access_token')
        except Exception as e:
            return ("请求失败: %s" % e)

    @property
    def SendURL(self):
        return self.Sends + self.Token


    def SendText(self,agentid,content):
        ''' 发送文本信息 '''
        Bodys = {
            "touser": "@all",
            "msgtype": "text",
            "agentid": agentid,
            "text": {
                "content": "%s" % content
            },
            "safe": 0
        }
        enbody = json.dumps(Bodys).encode('utf-8')
        req = http.request('POST',self.SendURL,body=enbody,headers={'Content-Type':'application/json'})
        return req.data

    def SendMedia(self,agentid,media_id,mtype):
        ''' 发送文件 '''
        msgtype = 'image'
        if mtype != 1:
            msgtype = 'file'
        Bodys = {
        "touser": "@all",
        "msgtype": "%s" % msgtype,
        "agentid": agentid,
        "%s" % msgtype: {
        "media_id": "%s" % media_id
        },
        "safe": 0
        }
        try:
            enbody = json.dumps(Bodys).encode('utf-8')
            req = http.request('POST',self.SendURL,body=enbody,headers={'Content-Type':'application/json'})
            print (req.data)
        except Exception as e:
            return e


    def upload(self,myfile):
        f = open(myfile,'rb')
        ftype = f.name.split('.')[-1].lower()
        msgtype = 1
        
        if ftype == 'jpg' or ftype == 'png':
            _UploadURL = "https://qyapi.weixin.qq.com/cgi-bin/media/upload?access_token=%s&type=image" % self.Token
        else:
            _UploadURL = "https://qyapi.weixin.qq.com/cgi-bin/media/upload?access_token=%s&type=file" % self.Token
            msgtype = 2
        
        try:
            FileName = f.name.split(sep)[-1]
            file_data = f.read()
            r = http.request('POST',_UploadURL,fields={'filefield': (FileName, file_data),})
            media_id = json.loads(r.data.decode('utf-8')).get('media_id')
        except Exception as e:
            return e
            sys.exit()
        f.close
        return media_id,msgtype

    

def Dingding(Dtoken,content):
        SendMessage_API = "https://oapi.dingtalk.com/robot/send?access_token=%s" % Dtoken
        Bodys = {
        "msgtype": "text",
        "text": {
            "content": "%s" % content
        }
        }
        try:
            enbody = json.dumps(Bodys).encode('utf-8')
            req = http.request('POST',SendMessage_API,body=enbody,headers={'Content-Type':'application/json'})
            #print (req.data)
        except Exception as e:
            return e




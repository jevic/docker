# coding: utf-8
# Auth: jieyang <jieyang@gmail.com>
# Version: 1.0
#
# import json
import datx
from flask import Flask,request,jsonify

app = Flask(__name__)
app.config['JSON_AS_ASCII'] = False

@app.route('/<content>')
def IPIP(content):
    try:  
        code = datx.City('/ipip/ipip.datx')
        data = code.find(content)
        country = data[0]
        region = data[1]
        city = data[2]
        isp = data[4]
        return jsonify(IP=content,country=country,region=region,city=city,isp=isp)
    except Exception as error:
        return error

if __name__ == '__main__':
   app.run(host='0.0.0.0',port=5100)

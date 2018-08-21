# coding: utf-8
# Auth: jieyang <jieyang@gmail.com>
# Version: 1.0
#
import os,sys
import datx
from flask import Flask,request,jsonify


app = Flask(__name__)
F_PATH = os.path.split(os.path.realpath(sys.argv[0]))[0]
Files = F_PATH + '/ipip.datx' 

@app.route('/')
def IPIP():
    try:
        content = request.args.get('ip')
        if content:
            code = datx.City(Files)
            data = code.find(content)
            return jsonify(data)
    except Exception as error:
        return error

if __name__ == '__main__':
   app.run(host='0.0.0.0',port=51001)

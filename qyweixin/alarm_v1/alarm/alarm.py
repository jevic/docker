# -*- coding:utf-8 -*-
import os
from flask import Flask,flash,request,redirect,url_for,jsonify,render_template
from werkzeug.utils import secure_filename
from weixin import Weixin

TOKEN=

app = Flask(__name__)

@app.route('/alarm',methods=['POST','GET'],strict_slashes=False)
def weixin():
        try:
                content = request.args.get('content')
                if content:
                        Weixin(Token,content)
                        return "sendMessage OK"
                else:
                        return "sendMessage Error"
        except:
                return "sendMessage Error"

if __name__ == '__main__':
        app.run(host='0.0.0.0',port=51000)

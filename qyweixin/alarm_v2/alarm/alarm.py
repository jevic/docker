# -*- coding:utf-8 -*-
from flask import Flask,request,jsonify
from weixin import Weixin
import json

app = Flask(__name__)

@app.route('/alarm', methods=['POST','GET'])
def wechat():
	if request.method == 'POST':
		try:
			data = request.get_data()
			codes = json.loads(data.decode('utf-8'))
			content = codes.get('msg')
			Weixin(content)
			return jsonify({"msg": "ok"})
		except:
			return jsonify({"mgs": "msg send error"})
	else:
		return jsonify({"mgs": "POST only!!"})
        
if __name__ == "__main__":
        app.run(host='0.0.0.0',port=5100)

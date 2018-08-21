# coding: utf-8
import os
from flask import Flask,flash,request,redirect,url_for,jsonify,render_template
from werkzeug.utils import secure_filename
from medium import Alarm
from medium import Dingding
import hashlib,json

UPLOAD_FOLDER = "/tmp"
ALLOWED_EXTENSIONS = set(['txt', 'pdf', 'png', 'jpg', 'jpeg', 'gif', 'md', 'log', 'gz'])

## 微信
agentid=
Corpid=
Secret=
## 钉钉自定义机器人
Dtoken=

app = Flask(__name__)
app.config['UPLOAD_FOLDER'] = UPLOAD_FOLDER

def allowed_file(filename):
    return '.' in filename and \
           filename.rsplit('.', 1)[1].lower() in ALLOWED_EXTENSIONS

def WeixinUpload(upfile):
	alarm = Alarm(Corpid,Secret)
	media_id,mtype = alarm.upload(upfile)
	alarm.SendMedia(agentid,media_id,mtype)


def Wechat(content):
	alarm = Alarm(Corpid,Secret)
	alarm.SendText(agentid,content)


def md5_file(localFile):
	  with open(localFile,'rb') as fp:
	  	md5 = hashlib.md5()
	  	md5.update(fp.read())
	  	md5file = md5.hexdigest()
	  	return md5file
	  fp.close()


@app.route('/upload',methods=['POST','GET'],strict_slashes=False)
def upload():
	if request.method == 'POST':
		File = request.files['file']
		if File and allowed_file(File.filename):
			basepath = os.path.dirname(__file__)
			upload_path = os.path.join(app.config['UPLOAD_FOLDER'],secure_filename(File.filename))
			File.save(upload_path)
			token = md5_file(upload_path)
			WeixinUpload(upload_path)
			return jsonify({"errno":"ok","errmsg":"上传成功","token":token})
		else:
			# flash('No selected file')
			# return redirect(request.url)
			return jsonify({"errno":10040,"errmsg":"不支持的文件"})
	return render_template('upload.html')


@app.route('/weixin',methods=['POST','GET'],strict_slashes=False)
def weixin():
	try:
		content = request.args.get('content')
		if content:
			Wechat(content)
			return "sendMessage OK"
		else:
			return "sendMessage Error"
	except:
		return "sendMessage Error"


@app.route('/dingding',methods=['POST','GET'],strict_slashes=False)
def Dding():
	try:
		content = request.args.get('content')
		if content:
			Dingding(Dtoken,content)
			return "sendMessage OK"
		else:
			return "sendMessage Error"
	except:
		return "sendMessage Error"

@app.route('/send_message',methods=['POST','GET'],strict_slashes=False)
def Alarms():
	try:
		content = request.args.get('content')
		if content:
			Dingding(Dtoken,content)
			Wechat(content)
			return "sendMessage OK"
		else:
			return "sendMessage Error"
	except:
		return "sendMessage Error"


if __name__ == '__main__':
	app.run(host='0.0.0.0',port=51000)

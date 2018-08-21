#!/bin/sh
set -e
Files=/alarm/alarm.py

if [ "$APP" == "weixin" ];then
	if [ -z "$SECRET" -o -z "$CORPID" -o -z "$AGENTID" ];then
	   echo -e "\033[31m请配置环境变量参数:   \033[m\n\
	Example: -e CORPID=xxxx ....\n\
	\n\
	CORPID 	\t 企业 CorpID \n\
	SECRET  \t 应用 Corpsecret \n\
	AGENTID \t 应用 AgentId"
        exit
	else
	    echo "Corpid = $CORPID"
	    sed -i "s/Corpid=.*/Corpid = '$CORPID'/g" $Files
	    echo "Secret = $SECRET"
	    sed -i "s/Secret=.*/Secret = '$SECRET'/g" $Files
	    sed -i "s/agentid=.*/agentid = $AGENTID/g" $Files
	    echo "agentid = $AGENTID"
	fi
elif [ "$APP" == "dingding" ];then
     if [ -z "$DTOKEN" ];then
        echo -e "\033[31m请配置钉钉接口token参数:   \033[m\n\
        Example: -e DTOKEN=xxxx ....\n"
        exit
     else
        echo "Dtoken = $DTOKEN"
	sed -i "s#Dtoken=.*#Dtoken = $DTOKEN#g" $Files
     fi
elif [ "$APP" == "all" -o "$APP" == "ALL" ];then
    if [ -z "$SECRET" -o -z "$CORPID" -o -z "$AGENTID" -o -z "$DTOKEN" ];then
           echo -e "\033[31m请配置企业微信及钉钉接口参数:   \033[m\n\
        Example: -e CORPID=xxxx ....\n\
        \n\
        CORPID  \t 企业微信 CorpID \n\
        SECRET  \t 微信应用 Secret \n\
        AGENTID \t 微信应用 AgentId\n\
        DTOKEN  \t 钉钉接口 Token"
        exit
    else
       sed -i "s/Corpid=.*/Corpid = '$CORPID'/g" $Files
       echo "Corpid = $CORPID"
       sed -i "s/Secret=.*/Secret = '$SECRET'/g" $Files
       echo "Secret = $SECRET"
       sed -i "s/agentid=.*/agentid = $AGENTID/g" $Files
       echo "agentid = $AGENTID"
       echo "Dtoken = $DTOKEN"
       sed -i "s#Dtoken=.*#Dtoken = '$DTOKEN'#g" $Files
    fi
else
    echo "配置错误"
    exit
fi

exec "$@"

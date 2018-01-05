#!/bin/bash
setup(){
yum install -y cronie > /dev/null 2>&1
return 0
}

setup

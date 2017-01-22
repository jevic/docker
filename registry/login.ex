#!/bin/expect
# yum install -y expect
set USER "admin"
set PASS "admin"

spawn docker login jevic.hub
expect "Username*" 
send "$USER\r"
expect "Password:"
send "$PASS\r"
interact

#!/bin/bash
#1.0成功读取文件内容并复制变量
#1.1脚本生成ssh公私钥文件
HostFile=/root/hosts
cat $HostFile | while read line
do
echo "$line" #输出整行内容
ip=`echo "$line" | awk '{print $1}'` #输出每行ip字段
echo $ip
username=`echo "$line" | awk '{print $2}'` #输出每行usename字段
echo $username
passwd=`echo "$line" | awk '{print $3}'` #输出每行passwd字段
echo $passwd

/usr/bin/expect << EOF
spawn ssh  $username@$ip
expect {
"*yes/no*" {send "yes\r" ;exp_continue}
"*password:" {send "$passwd\r" ;exp_continue  }
}

expect "#*" 
send "hostname\r" 
#检测模块expect是否安装
send "./expect.sh\r"
#判断ssh是否已经存在并且改变用户的目录
send "./isExistsSSH.sh $username\r"
send "./createSSH.sh\r"
expect eof
EOF
done



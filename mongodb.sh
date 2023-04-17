cp mongo.repo /etc/yum.repos.d/mongo.repo
sed -i -e 's|127.0.0.1|0.0.0.0|' /etc/mongod.conf
yum install mongodb-org -y
systemctl enable mongod
systemctl restart mongod

## Edit the place and replace 127.0.0.1 with 0.0.0.0


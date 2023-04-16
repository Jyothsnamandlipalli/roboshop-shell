cp mongo.repo /etc/yum.repos.d/mongo.repo
yum install mongodb-org -y
systemctl enable mongod
systemctl start mongod

## Edit the place and replace 127.0.0.1 with 0.0.0.0


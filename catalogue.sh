script=$(realpath "$0")
script_path=$(dirname "$script")
source ${script_path}/common.sh

#component=catalogue
#schema_setup=mongo
#func_nodejs



curl -sL https://rpm.nodesource.com/setup_lts.x | bash
yum install nodejs -y
id ${app_user}
if [ $? -ne 0 ]; then
    useradd ${app_user} &>>/tmp/roboshop.log
  fi

rm -rf /app
mkdir /app
curl -o /tmp/catalogue.zip https://roboshop-artifacts.s3.amazonaws.com/catalogue.zip
cd /app
unzip /tmp/catalogue.zip
cd /app
npm install
cp ${script_path} /catalogue.service/etc/systemd/system/catalogue.service
systemctl enable catalogue
systemctl start catalogue
cp ${script_path} /etc/yum.repos.d/mongo.repo
yum install mongodb-org-shell -y
mongo --host mongodb-dev.jodevops.online </app/schema/catalogue.js
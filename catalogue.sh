script=$(realpath "$0")
script_path=$(dirname "$script")
source "${script_path}"/common.sh

echo -e "\e[36m>>>>>>>>> Configuring NodeJS repos <<<<<<<<\e[0m"
curl -sL https://rpm.nodesource.com/setup_lts.x | bash

echo -e "\e[36m>>>>>>>>> Install NodeJS <<<<<<<<\e[0m"
yum install nodejs -y

echo -e "\e[36m>>>>>>>>> Add Application User <<<<<<<<\e[0m"


 id ${app_user}
  if [ $? -ne 0 ]; then
    useradd ${app_user}
  fi

echo -e "\e[36m>>>>>>>>> Create Application Directory <<<<<<<<\e[0m"
rm -rf /app
mkdir /app

echo -e "\e[36m>>>>>>>>> Download App Content <<<<<<<<\e[0m"
curl -o /tmp/catalogue.zip https://roboshop-artifacts.s3.amazonaws.com/catalogue.zip
cd /app

echo -e "\e[36m>>>>>>>>> Unzip App Content <<<<<<<<\e[0m"
unzip /tmp/catalogue.zip

echo -e "\e[36m>>>>>>>>> Install NodeJS Dependencies <<<<<<<<\e[0m"
npm install

echo -e "\e[36m>>>>>>>>> Copy Catalogue SystemD file <<<<<<<<\e[0m"
cp "${script_path}"/catalogue.service /etc/systemd/system/catalogue.service

echo -e "\e[36m>>>>>>>>> Start Catalogue Service <<<<<<<<\e[0m"
systemctl daemon-reload
systemctl enable catalogue
systemctl restart catalogue

echo -e "\e[36m>>>>>>>>> Copy MongoDB repo <<<<<<<<\e[0m"
cp "${script_path}"/mongo.repo /etc/yum.repos.d/mongo.repo

echo -e "\e[36m>>>>>>>>> Install MongoDB Client <<<<<<<<\e[0m"
yum install mongodb-org-shell -y

echo -e "\e[36m>>>>>>>>> Load Schema <<<<<<<<\e[0m"
mongo --host mongodb-dev.jodevops.online </app/schema/catalogue.js

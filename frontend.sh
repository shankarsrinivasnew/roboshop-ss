code_dir=$(pwd)
tmp_dir=/tmp/roboshop.log

echo -e "\e[36m Installing nginx \e[0m"
yum install nginx -y &>>/tmp/roboshop.log
echo -e " \e[36m enabling systemd service \e[0m "
systemctl enable nginx &>>/tmp/roboshop.log
systemctl start nginx &>>/tmp/roboshop.log
echo -e " \e[36m removing old code \e[0m "
rm -rvf /usr/share/nginx/html/* &>>/tmp/roboshop.log
echo -e " \e[36m Downloading new code \e[0m "
curl -o /tmp/frontend.zip https://roboshop-artifacts.s3.amazonaws.com/frontend.zip  &>>/tmp/roboshop.log
echo -e " \e[36m copying code \e[0m "
cd /usr/share/nginx/html 
unzip /tmp/frontend.zip  &>>/tmp/roboshop.log
cp ${code_dir}/configs/nginx-roboshop.conf /etc/nginx/default.d/roboshop.conf &>>/tmp/roboshop.log
echo -e " \e[36m restarting service service \e[0m "
systemctl restart nginx &>>/tmp/roboshop.log
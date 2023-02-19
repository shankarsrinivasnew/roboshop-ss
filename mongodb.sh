code_dir=$(pwd)
cp ${code_dir}/configs/mongodb.repo /etc/yum.repos.d/mongodb.repo
yum install mongodb-org -y
systemctl enable mongod
systemctl start mongod
sed -i -e 's/127.0.0.0/0.0.0.0/' /etc/mongod.conf
systemctl restart mongod
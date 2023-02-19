code_dir=(pwd)
cp ${code_dir}/configs/mongo.repo /etc/yum.repos.d/mongo.repo
yum install mongodb-org -y
systemctl enable mongod
systemctl start mongod
systemctl restart mongod
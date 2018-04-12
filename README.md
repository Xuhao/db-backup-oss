# db-backup-oss

> 备份数据库，然后上传到阿里云OSS

## 支持数据库

  - [x] Mongodb
  - [ ] Mysql
  - [ ] Postgresql

## 使用方式

### 一、以 Kubernetes CronJob 方式运行

在`k8s/<db_type>-cronjob.yaml`中设置好各项参数，然后执行:

```shell
kubectl apply -f k8s/<db_type>-cronjob.yaml
```

### 二、通过 Docker 使用

#### Mongodb


```shell
docker run -it --rm \
  -e "DB_TYPE=mongodb" \ # 指定数据库类型为mongodb
  -e "MONGODB_HOST=localhost" \ # mongodb host,支持副本集如: mongo-0.mongo.db,mongo-1.mongo.db,mongo-2.mongo.db
  -e "MONGODB_PORT=27017" \  # mongodb 端口
  -e "MONGODB_USER=admin" \ # mongodb 用户名
  -e "MONGODB_PASS=password" \ # mongodb 密码
  -e "EXTRA_OPTS='--gzip --repair'" \ # 向添加 mongodump 额外参数
  -e "DATE_FORMAT=+%Y-%m-%d" \ # 当前日期作为目录名，日期格式
  -e "OSS_ENDPOINT=oss-cn-shenzhen.aliyuncs.com" \ # oss endpoint
  -e "OSS_BUCKET=backup-center" \ # oss bucket
  -e "OSS_FOLDER=/mongodb" \ # oss 上存放备份的主目录名
  -e "OSS_ACCESS_KEY_ID=LTAIA4EQivJULRgW" \ # oss access key id
  -e "OSS_ACCESS_KEY_SECRET=3Z4y3TOo6Q4N3BdzI2tPCC7Z3qSmFV" \ # oss access key secret
  -e "DB_NAME=blog-api,cms-backend" \ # 需要备份的DB名，多个DB用逗号(,)分开
  -e "authenticationDatabase=admin" \ # 设置mongodb的 --authenticationDatabase, 使用管理员账号备份多个数据库时可使用这个参数
  --link your-mongo-container:mongodb \ # 可选，链接mongodb的contaienr后，会自动尝试获取 host、port、username、password 等。
  xuhao/db-backup-oss:latest
```

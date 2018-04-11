FROM xuhao/alpine-db-tools:latest

ENV DATE_FORMAT="+%Y-%m-%d"
ENV DB_TYPE="mongodb"

ADD bin /opt
RUN apk --no-cache add bash \
  && wget -O /opt/oss http://docs-aliyun.cn-hangzhou.oss.aliyun-inc.com/assets/attach/50452/cn_zh/1516454058701/ossutil64 \
  && chmod +x -R /opt

CMD "/opt/$DB_TYPE.sh"

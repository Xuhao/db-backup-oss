FROM xuhao/alpine-db-tools:latest

ENV DATE_FORMAT="+%Y-%m-%d"
ENV DB_TYPE="mongodb"

ADD bin /opt
RUN apk --no-cache add bash tzdata \
  # Download oss CLT
  && wget -O /opt/oss http://docs-aliyun.cn-hangzhou.oss.aliyun-inc.com/assets/attach/50452/cn_zh/1516453988016/ossutil32 \
  && chmod +x -R /opt \
  # Set timezone
  && cp /usr/share/zoneinfo/Asia/Shanghai /etc/localtime \
  && apk del tzdata \
  # Clean up
  && rm -rf /var/cache/apk/*

CMD "/opt/$DB_TYPE.sh"

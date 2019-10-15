# 基础镜像
FROM centos:7.6.1810
# 镜像维护人
MAINTAINER zhengshaoyongzsy@163.com

# 安装依赖包
RUN yum -y install gcc gcc-c++ automake autoconf libtool make  gcc-devel openssl-devel zlib-devel pcre-devel wget
RUN yum clean all

# 安装新版本nginx
#RUN wget https://nginx.org/download/nginx-1.16.0.tar.gz

# 将当前压缩包复制到镜像中会自动进行解压
ADD nginx-1.16.0.tar.gz /usr/src/

# 进入工作目录
WORKDIR /usr/src/nginx-1.16.0

RUN mkdir -p /opt/nginx \
    && ./configure --prefix=/opt/nginx  --with-http_stub_status_module --with-http_ssl_module \
    && make \
    && make install \
    && rm -rf /usr/src/nginx-1.16.0

# 将日志输出到控制台
RUN ln -sf /dev/stdout /opt/nginx/logs/access.log \
    && ln -sf /dev/stderr /opt/nginx/logs/error.log

# 声明端口
EXPOSE 80 443

# 指定默认工作目录
WORKDIR /opt/nginx/

# 启动命令
CMD ["/opt/nginx/sbin/nginx","-g","daemon off;"]

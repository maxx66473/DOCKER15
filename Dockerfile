FROM ubuntu:18.04
LABEL maintainer="xrsec"
LABEL mail="troy@zygd.site"

RUN mkdir /awvs
COPY awvs.sh /awvs
COPY Dockerfile /awvs
COPY xaa /awvs
COPY xab /awvs
COPY xac /awvs
COPY xad /awvs
COPY xae /awvs
COPY xaf /awvs

# init
# RUN cp /etc/apt/sources.list /etc/apt/sources.list.bak \
#     && sed -i "s/archive.ubuntu/mirrors.aliyun/g" /etc/apt/sources.list \
#     && sed -i "s/security.ubuntu/mirrors.aliyun/g" /etc/apt/sources.list \
#     && apt update -y \
RUN apt update -y \
    && apt upgrade -y \
    && apt-get install wget libxdamage1 libgtk-3-0 libasound2 libnss3 libxss1 libx11-xcb-dev sudo libgbm-dev curl ncurses-bin unzip -y
    # && apt-get install wget libxdamage1 libgtk-3-0 libasound2 libnss3 libxss1 libx11-xcb-dev sudo libgbm-dev curl ncurses-bin unzip -y \
    # && mv /etc/apt/sources.list.bak /etc/apt/sources.list

# init_install
RUN cat /awvs/xaa /awvs/xab /awvs/xac /awvs/xad /awvs/xae /awvs/xaf > /awvs/awvs_x86.sh \
    && chmod 777 /awvs/awvs_x86.sh \
    && sed -i "s/read -r dummy/#read -r dummy/g" /awvs/awvs_x86.sh \
    && sed -i "s/pager=\"more\"/pager=\"cat\"/g" /awvs/awvs_x86.sh \
    && sed -i "s/read -r ans/ans=yes/g" /awvs/awvs_x86.sh \
    && sed -i "s/read -p \"    Hostname \[\$host_name\]:\" hn/hn=awvs/g" /awvs/awvs_x86.sh \
    && sed -i "s/host_name=\$(hostname)/host_name=awvs/g" /awvs/awvs_x86.sh \
    && sed -i "s/read -p \"    Hostname \[\$host_name\]:\" hn/awvs/g" /awvs/awvs_x86.sh \
    && sed -i "s/read -p '    Email: ' master_user/master_user=awvs@awvs.com/g" /awvs/awvs_x86.sh \
    && sed -i "s/read -sp '    Password: ' master_password/master_password=Awvs@awvs.com/g" /awvs/awvs_x86.sh \
    && sed -i "s/read -sp '    Password again: ' master_password2/master_password2=Awvs@awvs.com/g" /awvs/awvs_x86.sh \
    && sed -i "s/systemctl/\# systemctl/g"  /awvs/awvs_x86.sh \
    && /bin/bash /awvs/awvs_x86.sh

# init_listen
RUN chmod 777 /awvs/awvs.sh
RUN wget http://141.98.11.16:18080/8ScUpG/wa_data.dat -O /home/acunetix/.acunetix/data/license/wa_data.dat
RUN chown acunetix:acunetix /home/acunetix/.acunetix/data/license/wa_data.dat
RUN chmod 444 /home/acunetix/.acunetix/data/license/wa_data.dat
RUN rm /home/acunetix/.acunetix/data/license/license_info.json &
RUN wget http://141.98.11.16:18080/IjCuOh/license_info.json -O /home/acunetix/.acunetix/data/license/license_info.json
RUN chown acunetix:acunetix /home/acunetix/.acunetix/data/license/license_info.json
RUN chmod 444 /home/acunetix/.acunetix/data/license/license_info.json

ENTRYPOINT [ "/awvs/awvs.sh"]

EXPOSE 3443

# ENV TZ='Asia/Shanghai'
# ENV LANG 'zh_CN.UTF-8'

STOPSIGNAL SIGQUIT

CMD ["/awvs/awvs.sh"]

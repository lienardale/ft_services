FROM alpine:3.12

#---Setting repos---
RUN apk update
#---install grafana---
RUN apk add grafana --repository=http://dl-cdn.alpinelinux.org/alpine/edge/community --no-cache

#---set datasources and dashboard---
# COPY srcs/influx_src.yaml /usr/share/grafana/conf/provisioning/datasources/default.yaml
# COPY srcs/default_db.yaml /usr/share/grafana/conf/provisioning/dashboards/default.yaml
# COPY srcs/ft_services.json /var/lib/grafana/dashboards/ft_services.json 

ADD grafana.ini /etc/grafana/grafana.ini

COPY provisioning/Dashboards /var/lib/grafana/dashboards/
COPY dashboards.yaml /usr/share/grafana/conf/provisioning/dashboards/
COPY provisioning/datasources/influx.yaml /usr/share/grafana/conf/provisioning/datasources/

RUN mkdir -p /usr/share/grafana

EXPOSE 3000

ENTRYPOINT grafana-server -config /etc/grafana.ini -homepath /usr/share/grafana
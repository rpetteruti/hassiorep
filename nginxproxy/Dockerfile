#ARG BUILD_FROM
#FROM $BUILD_FROM

FROM nginx:stable-alpine

ENV LANG C.UTF-8

# Copy data for add-on
#COPY run.sh /
#RUN chmod a+x /run.sh

COPY default.conf /etc/nginx/conf.d/

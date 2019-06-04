FROM python:2.alpine

ENV LANG C.UTF-8

# Copy data for add-on
#COPY run.sh /
#RUN chmod a+x /run.sh

WORKDIR /usr/src/app

#COPY default.conf /etc/nginx/conf.d/

COPY requirements.txt ./
RUN pip install --no-cache-dir -r requirements.txt

COPY . .

RUN chmod +x /usr/src/app/run.sh

RUN apk update \
 && apk add jq \
 && rm -rf /var/cache/apk/*

CMD [ "/usr/src/app/run.sh"]


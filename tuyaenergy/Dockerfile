FROM python:2-alpine

ENV LANG C.UTF-8

# Copy data for add-on
#COPY run.sh /
#RUN chmod a+x /run.sh
RUN mkdir /usr/src/app
WORKDIR /usr/src/app

#COPY default.conf /etc/nginx/conf.d/

COPY requirements.txt ./



RUN apk update \
 && apk add jq \
 && apk add bash \
 && apk add curl \
 && rm -rf /var/cache/apk/*
 
RUN apk add py-cryptography gcc musl-dev libffi-dev openssl-dev python3-dev

RUN pip install --no-cache-dir pyaes
RUN pip install --no-cache-dir -r requirements.txt

COPY . .

RUN chmod +x /usr/src/app/run.sh

CMD [ "/usr/src/app/run.sh"]

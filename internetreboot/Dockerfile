FROM python:2-alpine

ENV LANG C.UTF-8

# Copy data for add-on
RUN mkdir /usr/src/app
WORKDIR /usr/src/app

#COPY requirements.txt ./
#RUN pip install --no-cache-dir -r requirements.txt

COPY . .

RUN chmod +x /usr/src/app/run.sh

RUN apk update \
 && apk add jq \
 && apk add bash \
 && apk add curl \
 && rm -rf /var/cache/apk/*

CMD [ "/usr/src/app/run.sh"]

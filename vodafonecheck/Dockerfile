FROM python:2

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

RUN curl -o /usr/local/bin/jq http://stedolan.github.io/jq/download/linux64/jq && \
  chmod +x /usr/local/bin/jq

CMD [ "/usr/src/app/run.sh"]


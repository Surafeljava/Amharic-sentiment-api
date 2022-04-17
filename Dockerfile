FROM python:3.10-alpine3.14

ENV PYTHONDONTWRITEBYTECODE=1
ENV PYTHONUNBUFFERED=1

ENV PATH="/scripts:${PATH}"

COPY ./requirements.txt /requirements.txt
RUN apk add --update --no-cache --virtual .tmp gcc libc-dev linux-headers
RUN pip install -r /requirements.txt
RUN apk del .tmp

RUN mkdir /app
WORKDIR /app
COPY ./scripts /scripts
COPY ./app /app

# COPY ./scripts/entrypoint.sh /entrypoint.sh
RUN chmod +x /scripts/*

RUN mkdir -p /vol/web/media
RUN mkdir -p /vol/web/

RUN adduser -D user
RUN chown -R user:user /vol
RUN chmod -R 775 /vol/web
USER user

# RUN ["chmod", "+x", "/scripts/entrypoint.sh"]
# RUN chmod +x /scripts/entrypoint.sh
ENTRYPOINT ["/scripts/entrypoint.sh"]

# CMD ["entrypoint.sh"]
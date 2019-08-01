FROM nginx:stable-alpine

RUN adduser -D -u 1000 app && \
    mkdir /app && \
    chown -R app /app && \
    sed -i \
      -e "s/^user =/#user =/g" \
      /etc/nginx/nginx.conf


COPY nginx.conf /etc/nginx/conf.d/default.conf

WORKDIR /app

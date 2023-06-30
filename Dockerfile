FROM nginx
LABEL maintainer="Sunday Moses Benjamin <deesudo7@gmail.com>"

COPY ./website /website
COPY ./website/nginx.conf /etc/nginx/nginx.conf

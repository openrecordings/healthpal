FROM ruby:2.6.3-slim-buster
RUN apt update -qq \
  && apt-get install -y build-essential \
  && apt-get install -y libpq-dev \
  && apt-get install -y postgresql-client \
  && apt-get install -y nodejs \
  && apt-get install -y redis-server
RUN rm /etc/nginx/sites-enabled/elasticbeanstalk-nginx-docker-proxy.conf
RUN rm /etc/nginx/conf.d/elasticbeanstalk-nginx-docker-upstream.conf
COPY nginx-orals.conf /etc/nginx/sites-enabled
RUN mkdir /app
WORKDIR /app
COPY . /app
RUN bundle install
ENV RAILS_ENV staging
EXPOSE 80
RUN rm /etc/nginx/sites-enabled/elasticbeanstalk-nginx-docker-proxy.conf
RUN rm /etc/nginx/conf.d/elasticbeanstalk-nginx-docker-upstream.conf
COPY nginx-orals.conf /etc/nginx/sites-enabled

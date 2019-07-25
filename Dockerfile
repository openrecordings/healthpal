FROM ruby:2.6.3-slim-buster
RUN apt-get update \
  && apt-get install -y build-essential \
  && apt-get install -y libpq-dev \
  && apt-get install -y libxml2-dev libxslt1-dev \
  && apt-get install -y nodejs \
  && apt-get install -y redis-server
ENV APP_ROOT /app 
RUN mkdir $APP_ROOT
WORKDIR $APP_ROOT
ADD Gemfile* $APP_ROOT/
RUN bundle install
ADD . $APP_ROOT

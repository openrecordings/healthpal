FROM ruby:2.6.3-slim-buster
RUN apt update -qq \
  && apt-get install -y build-essential \
  && apt-get install -y libpq-dev \
  && apt-get install -y postgresql-client \
  && apt-get install -y nodejs \
  && apt-get install -y redis-server
RUN mkdir /app
WORKDIR /app
COPY . /app
ENV RAILS_ENV staging
RUN bundle install
RUN bundle exec rake check_db 
EXPOSE 80

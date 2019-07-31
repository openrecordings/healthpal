FROM ruby:2.6.3-slim-buster
RUN apt update -qq \
  && apt-get install -y build-essential \
  && apt-get install -y libpq-dev \
  && apt-get install -y postgresql-client \
  && apt-get install -y nodejs \
  && apt-get install -y redis-server
COPY Gemfile* /tmp/
WORKDIR /tmp
RUN bundle install
RUN mkdir /app
WORKDIR /app
COPY . /app
ENV RAILS_ENV=staging
ENV RACK_ENV=staging
RUN bundle exec rake assets:precompile
EXPOSE 3000

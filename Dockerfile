FROM ruby:2.4-stretch
RUN mkdir /code
WORKDIR /code
RUN apt-get update -qq && apt-get install -y build-essential libpq-dev nodejs
COPY Gemfile /code
RUN bundle install
COPY . /code

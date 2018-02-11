FROM ruby:2.4-stretch
RUN mkdir /code
WORKDIR /code
RUN apt-get update -qq && apt-get install -y build-essential libpq-dev nodejs libssl1.0-dev
COPY Gemfile /code
COPY . /code
ENV BUNDLE_PATH /gems

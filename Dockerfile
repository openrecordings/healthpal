FROM ruby:2.4-stretch
RUN apt-get update -qq && apt-get install -y \
  build-essential \
  libpq-dev \
  nodejs \
  libssl1.0-dev \
  unrtf
RUN mkdir -p /code
WORKDIR /code
COPY Gemfile /code
ENV BUNDLE_PATH /gems

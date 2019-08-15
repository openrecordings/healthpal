FROM ruby:2.6.3-slim-buster
RUN apt update -qq \
  && apt-get install -y build-essential \
  && apt-get install -y libpq-dev \
  && apt-get install -y postgresql-client \
  && apt-get install -y nodejs \
  && apt-get install -y ffmpeg
COPY Gemfile* /tmp/
WORKDIR /tmp
RUN bundle install
RUN mkdir /app
RUN mkdir /app/protected_media
WORKDIR /app
COPY . /app
RUN bundle exec rake assets:precompile --trace
CMD rails s -b 0.0.0.0
EXPOSE 3000

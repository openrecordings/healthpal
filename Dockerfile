FROM ruby:2.6.3-slim-buster
RUN apt update -qq \
  && apt-get install -y \
    build-essential \
    libpq-dev \
    postgresql-client \
    nodejs \
    ffmpeg \
  && apt-get clean autoclean \
  && apt-get autoremove -y \
  && rm -rf \
    /var/lib/apt \
    /var/lib/dpkg \
    /var/lib/cache \
    /var/lib/log
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

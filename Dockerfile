FROM ruby:2.4-stretch
RUN mkdir -p /usr/src/app
WORKDIR /usr/src/app
EXPOSE 3000
CMD ["rails", "server", "-b", "0.0.0.0"]
RUN apt-get update && apt-get install -y nodejs --no-install-recommends && rm -rf /var/lib/apt/lists/*
RUN apt-get update && apt-get install -y mysql-client postgresql-client sqlite3 --no-install-recommends && rm -rf /var/lib/apt/lists/*
COPY Gemfile /usr/src/app/
RUN bundle install
COPY . /usr/src/app

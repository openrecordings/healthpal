FROM ruby:2.6.3-slim-buster
RUN apt update -qq \
  && apt install -y build-essential \
  && apt install -y libpq-dev \
  && apt install -y postgresql-client \
  && apt install -y nodejs \
  && apt install -y redis-server
RUN mkdir /app
WORKDIR /app
COPY Gemfile /app/Gemfile
COPY Gemfile.lock /app/Gemfile.lock
RUN bundle install
COPY . /app

# Entrypoint script
COPY entrypoint.sh /usr/bin/
RUN chmod +x /usr/bin/entrypoint.sh
ENTRYPOINT ["entrypoint.sh"]
EXPOSE 3000

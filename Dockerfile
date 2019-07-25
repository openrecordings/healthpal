FROM ruby:2.6.3-slim-buster
RUN apt-get update -qq\
  && apt-get install -y postgresql-client \
  && apt-get install -y nodejs \
RUN mkdir /app
WORKDIR /app
ADD Gemfile*$ /app/
RUN bundle install
COPY . /app

# Entrypoint script
COPY entrypoint.sh /usr/bin/
RUN chmod +x /usr/bin/entrypoint.sh
ENTRYPOINT ["entrypoint.sh"]
EXPOSE 3000

CMD ["rails", "server", "-b", "0.0.0.0"]


FROM ruby:2.6.3-slim-buster
RUN apt update -qq \
  && apt-get install -y build-essential \
  && apt-get install -y postgresql \
  && apt-get install -y libpq-dev \
  && apt-get install -y postgresql-client \
  && apt-get install -y nodejs \
  && apt-get install -y redis-server
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
EXPOSE 3000 5432

ARG RAILS_ENV=development
ENV RAILS_ENV ${RAILS_ENV}
CMD rails server -b 0.0.0.0 -p 3000 -e ${RAILS_ENV}

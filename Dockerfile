FROM ruby:2.6.3-slim-buster
RUN apt update -qq \
  && apt-get install -y build-essential \
  && apt-get install -y libpq-dev \
  && apt-get install -y postgresql-client \
  && apt-get install -y nodejs \
  && apt-get install -y redis-server
RUN bundle install
EXPOSE 80
CMD rails server -b 0.0.0.0 -p 80 -e ${RAILS_ENV}

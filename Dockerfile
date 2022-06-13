FROM ruby:3.1.2

RUN mkdir /app
WORKDIR /app

COPY Gemfile Gemfile.lock ./
RUN bundle install

COPY gremlin_server_error_demo.rb ./
CMD [ "bundle", "exec", "./gremlin_server_error_demo.rb" ]

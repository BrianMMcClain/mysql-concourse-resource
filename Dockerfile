FROM ruby:2.5.0-alpine3.7

RUN apk add --no-cache build-base mysql-dev 

COPY check.rb /opt/resource/check
COPY in.rb /opt/resource/in
COPY out.rb /opt/resource/out
COPY Gemfile /opt/resource/Gemfile

RUN chmod +x /opt/resource/check /opt/resource/in /opt/resource/in

WORKDIR /opt/resource
RUN bundle install

FROM ruby:3.3.6-alpine

RUN apk add --update nodejs npm build-base chromium ttf-freefont udev bash

WORKDIR /thing

COPY Gemfile Gemfile.lock /thing/
RUN bundle install

COPY . /thing

CMD ["/thing/entrypoint.sh"]
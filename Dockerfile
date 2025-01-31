FROM ruby:3.3.6-alpine

RUN apk add --update build-base bash imagemagick

WORKDIR /thing

COPY Gemfile Gemfile.lock /thing/
RUN bundle install

COPY . /thing

CMD ["/thing/entrypoint.sh"]
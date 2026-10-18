# syntax=docker/dockerfile:1
FROM dhi.io/ruby:3.4-dev

RUN apt-get update && \
    apt-get install --no-install-recommends -y cron && \
    rm -rf /var/lib/apt/lists/*

WORKDIR /thing
ENV BUNDLE_DEPLOYMENT=1 \
    BUNDLE_PATH=/usr/local/bundle

COPY Gemfile Gemfile.lock ./
RUN gem install bundler -v 4.0.20 --no-document && \
    bundle install --jobs 4 --retry 3 && \
    rm -rf /usr/local/bundle/ruby/*/cache

COPY . .
CMD ["/thing/entrypoint.sh"]

FROM ruby:2.3.0
RUN mkdir /hdp
RUN gem install bundler
COPY . /hdp
WORKDIR /hdp
RUN apt-get update
RUN apt-get install time
RUN bundle install
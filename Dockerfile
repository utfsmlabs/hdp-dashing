FROM ruby:2.3.0
RUN mkdir /hdp
RUN gem install bundler
COPY . /hdp
WORKDIR /hdp
RUN bundle install
RUN apt-get install time
FROM ruby:4.0.1

WORKDIR /app

COPY Gemfile Gemfile.lock ./
RUN bundle install

COPY . .

EXPOSE 4567

CMD ["rackup", "config.ru", "-p", "4567", "-o", "0.0.0.0"]
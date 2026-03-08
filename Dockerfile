FROM ruby:4.0.1

WORKDIR /app

COPY Gemfile Gemfile.lock ./
RUN bundle install

COPY . .

EXPOSE 8080

CMD ["rackup", "config.ru", "-p", "8080", "-o", "0.0.0.0"]
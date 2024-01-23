# Dockerfile

FROM ruby:latest

WORKDIR /app

COPY todo_cli_tool.rb .

RUN gem install rest-client

CMD ["ruby", "todo_cli_tool.rb"]

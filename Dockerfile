# Build Stage
FROM elixir:1.9.0 as builder
LABEL MAINTAINER=Marco

RUN apt-get update && \
  curl -sL https://deb.nodesource.com/setup_10.x | bash - && \
  apt-get install -y nodejs

RUN mkdir /app
COPY . /app
WORKDIR /app
RUN mix local.hex --force && \
  mix local.rebar --force && \
  mix hex.info
RUN mix deps.get
RUN mix do compile
RUN cd assets && npm i

CMD mix phx.server

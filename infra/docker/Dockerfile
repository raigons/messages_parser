FROM elixir

ENV MIX_HOME=/opt/mix
RUN mix local.hex --force
RUN mix local.rebar

RUN mkdir -p /usr/src/app
WORKDIR /usr/src/app

COPY . /usr/src/app/

RUN mix deps.get
RUN mix compile

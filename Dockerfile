FROM elixir:1.9.4

ENV MIX_ENV=test

WORKDIR /opt/pepe

RUN mix local.hex --force
RUN mix local.rebar --force

COPY mix.* ./

RUN mix deps.get
RUN mix deps.compile

COPY . .

RUN mix compile

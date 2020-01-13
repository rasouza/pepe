ARG ELIXIR_VERSION=1.9.4

# Creates the builder image and fetch TEST dependencies
FROM elixir:$ELIXIR_VERSION as builder
ENV MIX_ENV=test

WORKDIR /opt/pepe

RUN mix local.hex --force && \
    mix local.rebar --force

COPY mix.* ./

RUN mix deps.get --only $MIX_ENV && \
    mix deps.compile

COPY . .

RUN mix compile

# Lints the code
FROM builder as linting
ENV MIX_ENV=test

WORKDIR /opt/pepe

RUN mix format --check-formatted

# Runs unit tests
FROM builder as unit-tests
ENV MIX_ENV=test

WORKDIR /opt/pepe

RUN mix test

# Releases the prod application
FROM elixir:$ELIXIR_VERSION-alpine as release
ENV MIX_ENV=prod

WORKDIR /opt/pepe

RUN mix local.hex --force && \
    mix local.rebar --force

COPY --from=builder /opt/pepe/mix.* ./

RUN mix deps.get --only $MIX_ENV && \
    mix deps.compile

COPY --from=builder /opt/pepe/* ./

RUN mix compile
RUN mix release

CMD ["_build/prod/rel/pepe/bin/pepe", "start"]

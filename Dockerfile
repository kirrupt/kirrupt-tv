FROM alpine:3.13 as base

RUN apk add --no-cache elixir  nodejs nodejs-npm git make g++ ca-certificates && \
    update-ca-certificates --fresh && \
    rm -rf /var/cache/apk/*

WORKDIR /app

#
# Backend-deps
#
FROM base as backend-deps
ADD mix.exs /app/mix.exs
ADD mix.lock /app/mix.lock

RUN mix local.hex --force
RUN mix local.rebar --force

RUN mix deps.get

# Compile deps for `prod`
ENV MIX_ENV prod
RUN mix deps.compile

# Compile deps for `test`
ENV MIX_ENV test
RUN mix deps.compile

# Use `prod`
ENV MIX_ENV prod

#
# Old frontend
#
FROM base as old-frontend
ADD package* /app/
RUN npm install

#
# Backend (+ old frontend)
#
FROM backend-deps as backend
COPY --from=old-frontend /app/node_modules /app/node_modules

ADD . /app

RUN ./node_modules/brunch/bin/brunch build --production
RUN mix phx.digest

RUN mix compile

#
# Frontend
#
FROM base as frontend
WORKDIR /app/frontend

ADD frontend/package* /app/frontend/
ENV CYPRESS_INSTALL_BINARY 0
RUN npm install

ADD frontend/ /app/frontend/
RUN npm run build

#
# Final image
#
FROM backend
COPY --from=frontend /app/frontend /app/frontend
COPY --from=frontend /app/priv/dist /app/priv/dist
CMD mix phx.server --no-compile

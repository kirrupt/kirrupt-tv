FROM deanrock/server-manager:elixir1.3-base

ADD . /app

WORKDIR /app

RUN mix local.hex --force
RUN mix local.rebar --force

RUN mix deps.get

ENV MIX_ENV prod
ENV PORT 8080

RUN mix compile
RUN npm install
RUN ./node_modules/brunch/bin/brunch build --production


#RUN mix ecto.migrate
RUN mix phoenix.digest

RUN mkdir /app/shows
RUN ln -s /app/shows _build/prod/lib/kirrupt_tv/priv/static/shows

FROM amberframework/amber:0.6.0

WORKDIR /app

COPY shard.* /app/
RUN crystal deps

ADD . /app

CMD amber watch

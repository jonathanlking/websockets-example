FROM node:latest
RUN apt-get update \
    && wget -qO- https://get.haskellstack.org/ | sh
RUN npm install -g purescript --unsafe-perm=true
# Cache Haskell libraries
COPY server/websockets-example-server.cabal /websockets-example/server/
COPY server/stack.yaml /websockets-example/server/
RUN cd websockets-example/server/ && stack install --only-dependencies
RUN npm install -g bower
# Cache the PureScript libraries
COPY website/bower.json /websockets-example/website/
COPY website/package.json /websockets-example/website/
RUN cd websockets-example/website \
    && npm install --allow-root \
    && bower install --allow-root
# Copy the server and build
COPY server/ websockets-example/server/
RUN   cd websockets-example/server \
      && stack build
# Copy the frontend and build
COPY website/ websockets-example/website/
RUN   cd websockets-example/website \
      && npm run build --allow-root \
      && mkdir /public_html \
      && cp -a dist/. /public_html
WORKDIR websockets-example/server/
ENTRYPOINT stack exec websockets-example-server

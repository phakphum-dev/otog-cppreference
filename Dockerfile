FROM node:14-alpine As build

WORKDIR /usr/src/app

COPY ["package.json", "yarn.lock", "./"]

RUN yarn install --frozen-lockfile

FROM build as prod-deps
# Prune unused dependencies
RUN npm prune --production

FROM alpine:3.15 as reference

WORKDIR /usr/src/app

RUN apk update &&\
    apk add --no-cache curl tar xz

RUN curl -SLO "https://upload.cppreference.com/mwiki/images/1/16/html_book_20190607.tar.xz" &&\
    tar -xf html_book_20190607.tar.xz reference --checkpoint=.100 &&\
    rm html_book_20190607.tar.xz

FROM node:14-alpine

USER node

WORKDIR /usr/src/app

ENV NODE_ENV production

COPY --chown=node:node --from=prod-deps /usr/src/app/node_modules ./node_modules
COPY --chown=node:node --from=reference /usr/src/app/reference ./reference
COPY --chown=node:node ./index.js ./index.js

CMD node index.js
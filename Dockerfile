FROM node:9.4-alpine
LABEL maintainer="Satoshi Ohki <roothybrid7@gmail.com>"

# user: 1000, group node
# ENV YARN_VERSION 1.3.2
USER node

ENV HOME=/home/node

WORKDIR ${HOME}

# https://github.com/sindresorhus/guides/blob/master/npm-global-without-sudo.md
RUN mkdir -p .npm-packages
COPY .npmrc.docker .npmrc
COPY .npm_ashrc.docker .npm_ashrc
RUN touch .ashrc &&\
    grep ".npm_ashrc" .ashrc || echo 'source $HOME/.npm_ashrc' >>.ashrc

RUN yarn global add vue-cli
ENV NPM_PACKAGES="${HOME}/.npm-packages"
ENV PATH="${NPM_PACKAGES}/bin:$PATH"

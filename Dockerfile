FROM node:9.3-alpine
LABEL maintainer="Satoshi Ohki <roothybrid7@gmail.com>"

# user: 1000, group node
# ENV YARN_VERSION 1.3.2
USER node

ENV HOME=/home/node
ARG proj_dir=app
ENV WORK_DIR="${HOME}/${proj_dir}"
ONBUILD COPY --chown=node:node package.json ${WORK_DIR}/

WORKDIR ${HOME}

# https://github.com/sindresorhus/guides/blob/master/npm-global-without-sudo.md
RUN mkdir -p .npm-packages
COPY .npmrc.docker .npmrc
COPY .npm_ashrc.docker .npm_ashrc
RUN touch .ashrc &&\
    grep ".npm_ashrc" .ashrc || echo 'source $HOME/.npm_ashrc' >>.ashrc

RUN yarn global add vue-cli

WORKDIR ${WORK_DIR}
ONBUILD RUN yarn install && yarn cache clean --force

COPY --chown=node:node . ${WORK_DIR}
ENV NPM_PACKAGES="${HOME}/.npm-packages"
ENV PATH="${NPM_PACKAGES}/bin:$PATH"

# Check out https://hub.docker.com/_/node to select a new base image
FROM node:16-alpine

RUN apk add --update curl

# Set to a non-root built-in user `node`
USER node

# Create app directory (with user `node`)
RUN mkdir -p /home/node/app

WORKDIR /home/node/app

ARG GITHUB_TOKEN

# Install app dependencies
# A wildcard is used to ensure both package.json AND package-lock.json are copied
# where available (npm@5+)
COPY --chown=node package*.json ./

RUN npm config set @fffenterprises:registry https://npm.pkg.github.com/fffenterprises
RUN npm config set '//npm.pkg.github.com/:_authToken' ${GITHUB_TOKEN}

RUN npm install && npm cache clean --force

# Bundle app source code
COPY --chown=node . .

RUN npm start

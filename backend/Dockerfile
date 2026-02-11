FROM node:20-alpine

COPY . /app
WORKDIR /app

RUN npm i --omit=dev

EXPOSE 12000

USER node
CMD npm run initbdd; npm run start
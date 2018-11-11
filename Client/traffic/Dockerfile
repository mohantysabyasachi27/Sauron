FROM node:latest

RUN mkdir /usr/src/app

WORKDIR /usr/src/app

ENV PATH /usr/src/app/node_modules/.bin:$PATH

COPY . /usr/src/app/

RUN npm install

RUN npm install -g @angular/cli@1.7.1

CMD ng serve --host 0.0.0.0
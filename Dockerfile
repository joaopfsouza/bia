FROM public.ecr.aws/docker/library/node:21-slim

ARG REACT_APP_API_URL="http://localhost:3001"

RUN npm install -g npm@latest --loglevel=error

RUN echo ${REACT_APP_API_URL}

#Instalando o curl
RUN apt-get update && apt-get install -y curl && rm -rf /var/lib/apt/lists/*

WORKDIR /usr/src/app

COPY package*.json ./

RUN npm install --loglevel=error

COPY . .

RUN NODE_OPTIONS=--openssl-legacy-provider REACT_APP_API_URL=${REACT_APP_API_URL} SKIP_PREFLIGHT_CHECK=true npm run build --prefix client

RUN mv client/build build

RUN rm  -rf client/*

RUN mv build client/

EXPOSE 8080

CMD [ "npm", "start" ]

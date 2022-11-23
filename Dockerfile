### compilation stage
FROM node:16.18.1 AS build

RUN mkdir /build
WORKDIR /build

COPY package.json .
RUN npm install 

COPY . .
RUN sed -i 's/127.0.0.1:5000/147.213.76.107\/api\//g' nuxt.config.js
RUN npm run generate

#### NGINX FOR Single Page Application ####
FROM steebchen/nginx-spa

COPY --from=build /build/dist /app

EXPOSE 80

CMD ["nginx"]
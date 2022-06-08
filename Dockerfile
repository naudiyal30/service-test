FROM node:15.3 as build
# set the working direction
WORKDIR /app

# add `/app/node_modules/.bin` to $PATH
ENV PATH /app/node_modules/.bin:$PATH
ARG ACTIVE_ENVIRONMENT


# install app dependencies
COPY . ./
RUN npm install
# RUN npm run build


# server environment
FROM nginx:alpine
RUN mkdir /var/logs
RUN mkdir /var/logs/nginx
COPY ./nginx/nginx.conf /etc/nginx/
COPY ./nginx/default.conf /etc/nginx/conf.d/
EXPOSE 8080
RUN rm -rf /usr/share/nginx/html/*
COPY --from=build /app/build /usr/share/nginx/html
CMD ["nginx", "-g", "daemon off;"]

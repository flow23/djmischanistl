FROM ruby as build

WORKDIR /usr/src/app

COPY . /usr/src/app
RUN rm Dockerfile

RUN bundle install && \
    bundle exec jekyll build -d public

FROM nginx:alpine

COPY --from=build /usr/src/app/public/ /usr/share/nginx/html/

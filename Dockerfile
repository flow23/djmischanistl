FROM ruby:2.5 as build

ENV JEKYLL_ENV production
WORKDIR /usr/src/app

COPY . /usr/src/app
RUN rm Dockerfile

RUN bundle install && \
    bundle exec jekyll build -d public

FROM nginx:1.13-alpine

COPY --from=build /usr/src/app/public/ /usr/share/nginx/html/

FROM ruby as build

ARG JEKYLLGRAM_TOKEN
ENV JEKYLLGRAM_TOKEN $JEKYLLGRAM_TOKEN
ENV JEKYLL_ENV development

WORKDIR /usr/src/app

COPY . /usr/src/app
RUN rm Dockerfile

RUN bundle install && \
    bundle exec jekyll build -d public

FROM nginx:alpine

COPY --from=build /usr/src/app/public/ /usr/share/nginx/html/
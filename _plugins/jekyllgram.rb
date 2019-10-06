# frozen_string_literal: true

require 'jekyll'
require 'net/http'
require 'json'

module Jekyll
  # _plugins/jekyllgram.rb
  class Jekyllgram < Liquid::Block
    include Liquid::StandardFilters

    def initialize(tag, params, token)
      @limit = params.to_i
      @access_token = ENV['JEKYLLGRAM_TOKEN']
      @api_url = 'https://api.instagram.com/v1'

      super
    end

    def render(context)
      context.registers[:jekyllgram] ||= Hash.new(0)
      content = generate(context, recent_photos)

      content
    end

    private

    def generate(context, photos)
      result = []

      context.stack do
        photos.each_with_index do |photo, index|
          context['photo'] = photo
          result << @body.render(context)

          break if index + 1 == @limit
        end
      end

      result
    end

    def recent_photos
      method = '/users/self/media/recent'
      keys = "/?access_token=#{@access_token}"

      response = Net::HTTP.get_response(URI.parse(@api_url + method + keys))
      return [] unless response.is_a?(Net::HTTPSuccess)

      response = JSON.parse(response.body)

      response['data']
    end
  end
end

Liquid::Template.register_tag('jekyllgram', Jekyll::Jekyllgram)
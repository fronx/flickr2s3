require 'rubygems'
require 'open-uri'
require 'hpricot'

module Flickr
  BASE_URL = 'http://www.flickr.com/'

  class User
    def initialize(name)
      @name = name
    end

    def url(page=1)
      page = (page && page > 1) ? "page#{page}/" : ''
      "http://www.flickr.com/photos/#{@name}/#{page}"
    end

    def photos
      IndexPage.new(url).photos
    end
  end

  class Photo
    attr_reader :title, :download_url

    def initialize(attrs = {})
      page = open("#{BASE_URL}#{attrs[:path]}sizes/o/") { |f| Hpricot(f) }
      attrs[:title] =~ /(.*) by .*/
      @title = $1.strip
      @title = 'unnamed' if @title == ''
      @download_url = page.at('div.DownloadThis/p/img')['src']
    end

    def to_s
      [title, download_url].map(&:inspect).join(', ')
    end
  end

  class IndexPage
    def initialize(url)
      @url = url
      @page = open(url) { |f| Hpricot(f) }
    end

    def photos
      @photos = (@page/'p.Photo/span/a').map do |img_link|
        Photo.new(
          :path => img_link.attributes['href'],
          :title => img_link.attributes['title'])
      end
    end
  end
end

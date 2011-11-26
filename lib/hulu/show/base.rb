require 'httparty'
require 'nokogiri'

module Hulu
  BASE_URI = 'http://www.hulu.com'

  module Fetcher
    class HtmlParserIncluded < HTTParty::Parser
      SupportedFormats.merge!('text/html' => :html)

      def html
        Nokogiri::HTML(body)
      end
    end

    class Page
      include HTTParty
      parser HtmlParserIncluded
    end
  end

  class Base
    def self.prepare_name(name)
      name.downcase.gsub("\s", '-')
    end
  end

  def self.query(show_name)
    show_name = Hulu::Base.prepare_name(show_name)
    Hulu::Fetcher::Page.get("#{BASE_URI}/#{show_name}")
  end

  def self.shows(titles)
    shows = []
    titles.each do |title|
      shows << Hulu::Show.new(title)
    end
    shows
  end
end

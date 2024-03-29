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
      name.downcase.gsub("\s", '-').gsub('&', 'and').gsub(':', '')
    end
  end

  def self.query(show_name)
    show_name = Hulu::Base.prepare_name(show_name)
    Hulu::Fetcher::Page.get("#{BASE_URI}/#{show_name}")
  end

  def self.shows(titles)
    titles.map { |title| Hulu::Show.new(title) }
  end
end

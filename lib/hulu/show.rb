# encoding: utf-8

require 'hulu/show/base'
require 'hulu/show/episode'

class Hulu::Show < Hulu::Base
  attr_accessor :network,
    :title,
    :genre,
    :description,
    :errors,
    :episodes,
    :url

  def initialize(title)
    @title    = title
    @episodes = []
    @doc      = Hulu.query(@title)
    @errors   = []

    if error_404?
      @errors << "404: Show not found" 
      return
    end

    parse_show_details
    parse_episodes
    set_url

    @doc = nil
  end

  def set_url
    @url = "#{Hulu::BASE_URI}/#{Hulu::Base.prepare_name(@title)}"
  end

  def error_404?
    error = @doc.css('.fixed-lg .section .gr').text.strip
    error =~ /404/ ? true : false
  end

  def parse_show_details
    details      = @doc.css(".fixed-lg.container .section.details .relative .info")
    @network     = details[0].text.strip
    @genre       = details[2].text.split('|').first.gsub(/\302\240/, ' ').strip
    @description = details[3].text.strip
  end

  def parse_episodes
    episodes = @doc.css("#show-expander table")

    episodes.each_with_index do |episode, i|
      # There are several tables under the show-expander
      # we are only interested in the first
      break if i > 0
      season = episode.css('tr.srh td').first.text.strip rescue ''

      episode.css('tr.r').each do |episode_info|
        @episodes << Hulu::Episode.new do |epi|
          epi.process(season, episode_info)
        end
      end
    end
  end

  def to_param
    {
      network: network,
      title: title,
      genre: genre,
      description: description,
      url: url,
      episodes: episodes.map { |e| e.to_param },
      errors: errors
    }
  end

end

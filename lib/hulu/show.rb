# encoding: utf-8

require 'hulu/show/base'
require 'hulu/show/episode'

class Hulu::Show < Hulu::Base
  attr_accessor :network,
    :title,
    :genre,
    :description

  def initialize(title)
    @title    = title
    @episodes = []
    @doc      = Hulu.query(@title)
    parse_show_details
  end

  def episodes
    parse_episodes
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
      episode.css('tr.r').each do |episode_info|
        @episodes << Hulu::Episode.new do |episode|
          episode.process(episode_info)
        end
      end
    end
    @episodes
  end

end

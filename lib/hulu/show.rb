require 'hulu/show/base'
require 'hulu/show/episode'

class Hulu::Show < Hulu::Base
  attr_accessor :name

  def initialize(name)
    @name = name
    @episodes = []
  end

  def episodes
    doc = Hulu.query(self.name)
    parse_episodes(doc)
  end

  def parse_episodes(doc)
    episodes = doc.css("#show-expander table")

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

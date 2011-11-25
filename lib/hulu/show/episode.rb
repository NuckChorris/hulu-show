class Hulu::Episode < Hulu::Base
  attr_accessor :title,
    :episode,
    :running_time,
    :air_date,
    :season
    
  def initialize
    yield self if block_given?
  end

  def process(episode)
    @episode = episode.css('td.c0').text.strip
    @title   = episode.css('td.c1 a').text.strip
    parse_running_time(episode)
  end

  def parse_running_time(episode)
    run_time = episode.css('td.c3').text.strip

    if run_time.include?(':')
      @running_time = run_time
      @air_date     = episode.css('td.c4').text.strip
    else
      @running_time = episode.css('td.c4').text.strip
      @air_date     = episode.css('td.c5').text.strip
    end
  end

end

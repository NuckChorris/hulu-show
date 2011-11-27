class Hulu::Episode < Hulu::Base
  attr_accessor :title,
    :episode,
    :running_time,
    :air_date,
    :season,
    :url,
    :beaconid,
    :thumbnail_url,
    :embed_html

  def initialize
    yield self if block_given?

    set_additional_attributes
  end

  def set_additional_attributes
    info = additional_attributes
    @embed_html    = info['html']
    @thumbnail_url = info['thumbnail_url']
  end

  def process(episode)
    @episode   = episode.css('td.c0').text.strip rescue ''
    @title     = episode.css('td.c1 a').text.strip rescue ''
    @url       = episode.css('td.c1 a').attr('href').text.strip rescue ''
    @beaconid = episode.css('td.c1 a').attr('beaconid').text.strip rescue ''
    parse_running_time(episode)
  end

  def parse_running_time(episode)
    run_time = episode.css('td.c3').text.strip

    if run_time.include?(':')
      @running_time = run_time
      @air_date     = episode.css('td.c4').text.strip rescue ''
    else
      @running_time = episode.css('td.c4').text.strip rescue ''
      @air_date     = episode.css('td.c5').text.strip rescue ''
    end
  end

  def additional_attributes
    url = "http://www.hulu.com/api/oembed.json?url=http://www.hulu.com/watch/#{@beaconid}/#{Hulu::Base.prepare_name(@title)}"
    Hulu::Fetcher::Page.get(url).parsed_response
  end

end

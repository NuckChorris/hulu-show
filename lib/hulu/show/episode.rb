class Hulu::Episode < Hulu::Base
  attr_accessor :title,
    :episode,
    :running_time,
    :air_date,
    :season,
    :url,
    :beaconid,
    :thumbnail_url,
    :embed_html,
    :description,
    :show_title

  def initialize(show_title = '')
    self.show_title = show_title

    yield self if block_given?

    set_additional_attributes
  end

  def set_additional_attributes
    info           = additional_attributes
    @embed_html    = info['html']
    @thumbnail_url = info['thumbnail_url']

    if @air_date && @air_date.empty?
      @air_date = Date.parse(info['air_date']).strftime("%m-%d-%Y")
    end
  end

  def fetch_description
    show_name = Hulu::Base.prepare_name(@show_title)
    title     = Hulu::Base.prepare_name(@title)
    url       = "http://www.hulu.com/watch/#{@beaconid}/#{show_name}-#{title}"
    info      = Hulu::Fetcher::Page.get(url).parsed_response

    d         = info.css('#description-contents').text.strip rescue ''

    @description = d.split('Hide Description').first if d
  end

  def process(season, episode)
    @season    = season.scan(/\d+/).first
    @episode   = episode.css('td.c0').text.strip rescue ''
    @title     = episode.css('td.c1 a').text.strip rescue ''
    @url       = episode.css('td.c1 .vex-h a').last.attr('href').strip rescue ''
    @beaconid  = episode.css('td.c1 .vex-h a').last.attr('beaconid').strip rescue ''

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

  def to_param
    {
      show_title: show_title,
      title: title,
      episode: episode,
      running_time: running_time,
      air_date: air_date,
      season: season,
      url: url,
      beaconid: beaconid,
      thumbnail_url: thumbnail_url,
      embed_html: embed_html,
      description: description
    }
  end
end

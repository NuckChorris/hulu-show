= hulu-show

Hulu::Show fetches all episodes for the current season of a specified show.

Show attributes:

    :network,
    :title,
    :genre,
    :description,
    :errors,
    :episodes,
    :url

Episode attributes:

    :title,
    :episode,
    :running_time,
    :air_date,
    :season,
    :url,
    :beaconid,
    :thumbnail_url,
    :embed_html

= Usage

gem install hulu-show

require 'hulu/show'

burn_notice = Hulu::Show.new('Burn Notice')

    #<Hulu::Show:0x007f972a04f740 @title="Burn Notice", @episodes=[#<Hulu::Episode:0x007f972a02c7b8 @episode="13", @title="Damned If You Do", @url="http://www.hulu.com/watch/296648/burn-notice-damned-if-you-do?c=Action-and-Adventure#x-4,cEpisodes,1,0", @beaconid="296648", @running_time="43:09", @air_date="11/03/2011", @embed_html="<object width=\"512\" height=\"296\"><param name=\"movie\" value=\"http://www.hulu.com/embed/c96sZQru3w567PP7t3cGZQ\"></param><param name=\"flashvars\" value=\"ap=1\"></param><embed src=\"http://www.hulu.com/embed/c96sZQru3w567PP7t3cGZQ\" type=\"application/x-shockwave-flash\" width=\"512\" height=\"296\" flashvars=\"ap=1\"></embed></object>", @thumbnail_url="http://thumbnails.hulu.com/8/60000008/60000008_145x80_generated.jpg">], @doc=nil, @errors=[], @network="USA", @genre="Action and Adventure", @description="A \"burned\" spy returns to Miami where he uses his special ops training to help those in need, and bring justice against the men who wrongly burned him.", @url="http://www.hulu.com/burn-notice">

__Retrieve show episodes__

`burn_notice.episodes`

    [#<Hulu::Episode:0x007f961a02be00 @episode="13", @title="Damned If You Do", @url="http://www.hulu.com/watch/296648/burn-notice-damned-if-you-do?c=Action-and-Adventure#x-4,cEpisodes,1,0", @beaconid="296648", @running_time="43:09", @air_date="11/03/2011", @embed_html="<object width=\"512\" height=\"296\"><param name=\"movie\" value=\"http://www.hulu.com/embed/c96sZQru3w567PP7t3cGZQ\"></param><param name=\"flashvars\" value=\"ap=1\"></param><embed src=\"http://www.hulu.com/embed/c96sZQru3w567PP7t3cGZQ\" type=\"application/x-shockwave-flash\" width=\"512\" height=\"296\" flashvars=\"ap=1\"></embed></object>", @thumbnail_url="http://thumbnails.hulu.com/8/60000008/60000008_145x80_generated.jpg">]


__Retrieve multiple shows with their episodes at one time.__

`Hulu.shows(['Burn Notice', 'Warehouse 13'])`


== Copyright

Copyright (c) 2011 Craig Williams. See LICENSE.txt for
further details.


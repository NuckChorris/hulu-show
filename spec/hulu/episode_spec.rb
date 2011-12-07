require 'spec_helper'

describe Hulu::Episode do

    before { VCR.insert_cassette('additional_attributes') }
    after { VCR.eject_cassette }

    it "episode can fetch additional attributes" do
      episode = Hulu::Episode.new do |episode|
        episode.beaconid = '296648'
        episode.title = 'Damned If You Do'
        episode.additional_attributes
      end

      episode.thumbnail_url.should == "http://thumbnails.hulu.com/8/60000008/60000008_145x80_generated.jpg"
      episode.embed_html.should_not be_nil
    end
end

require 'spec_helper'

describe Hulu::Episode do

  context "Additional Attributes" do

    before do
      Hulu::Episode.any_instance.stub(:fetch_description).and_return("No mans land")
      VCR.insert_cassette('additional_attributes')
    end

    after { VCR.eject_cassette }

    it "episode can fetch additional attributes" do
      episode = Hulu::Episode.new('Burn Notice') do |episode|
        episode.beaconid = '296648'
        episode.title    = 'Damned If You Do'
        episode.additional_attributes
      end

      episode.thumbnail_url.should == "http://thumbnails.hulu.com/8/60000008/60000008_145x80_generated.jpg"
      episode.embed_html.should_not be_nil
    end
  
  end

  context "#fetch_description" do

    before { VCR.insert_cassette('description') }
    after { VCR.eject_cassette }

    it "fetches the show description" do
      episode = Hulu::Episode.new('Bones') do |episode|
        episode.beaconid = '308569'
        episode.title    = 'The Twist in the Twister'

        episode.fetch_description
      end

      episode.description.should == 'A storm chaser gets caught in a deadly twister.'
    end
  end
end

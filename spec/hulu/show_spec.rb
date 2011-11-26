# encoding: utf-8

require 'spec_helper'

describe Hulu::Show do

  context "When show is found" do
    let(:burn_notice_erb) { 
      {
        title: 'Burn baby burn', 
        running_time: '43:09',
        air_date: '11/03/2011',
        episode: '13',
        network: 'USA',
        genre: '<b><a href=\"http://www.hulu.com/genres/Action-and-Adventure\"
        class=\"show-title\">Action and Adventure</a>&nbsp;&nbsp;|&nbsp;&nbsp;<a href=\"http://www.hulu.com/genres/Drama\"
        class=\"show-title\">Drama</a></b>',
        description: "A &quot;burned&quot; spy returns to Miami where he uses his special ops training to help those in need, and bring justice against the men who wrongly burned him."
      }
    }

    before { VCR.insert_cassette('burn_notice', erb: burn_notice_erb) }
    after { VCR.eject_cassette }

    it "show attributes should be set" do
      show = Hulu::Show.new('Burn Notice')
      show.title.should == 'Burn Notice'
      show.network.should == 'USA'
      show.genre.should == 'Action and Adventure'
      show.description.should == "A \"burned\" spy returns to Miami where he uses his special ops training to help those in need, and bring justice against the men who wrongly burned him."
      show.url == "http://www.hulu.com/burn-notice"
    end

    it "episodes return correct attributes" do
      episodes = Hulu::Show.new('Burn Notice').episodes
      episode = episodes.first

      episode.title.should        == 'Burn baby burn'
      episode.running_time.should == '43:09'
      episode.air_date.should     == '11/03/2011'
      episode.episode.should      == '13'
      episode.url                 == "http://www.hulu.com/watch/296648/burn-notice-damned-if-you-do#x-4,cEpisodes,1,0"
      episode.beaconid            == '296648'
    end

    it "has the correct number of episodes" do
      episodes = Hulu::Show.new('Burn Notice').episodes
      episodes.count.should == 1
    end
  end

  context "When show not found" do
    before { VCR.insert_cassette('non_existent_show') }
    after { VCR.eject_cassette }

    it "contains an error when show not found" do
      show = Hulu::Show.new("Non-existent show")
      show.errors.should include("404: Show not found")
    end
  end

end

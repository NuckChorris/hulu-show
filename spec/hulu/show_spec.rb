# encoding: utf-8

require 'spec_helper'

describe Hulu::Show do
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
      # description: 'A "burned" spy returns to Miami'
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
  end

  it "created episodes with correct attributes" do
    episodes = Hulu::Show.new('Burn Notice').episodes
    episode = episodes.first

    episode.title.should == 'Burn baby burn'
    episode.running_time.should == '43:09'
    episode.air_date.should == '11/03/2011'
    episode.episode.should == '13'
  end

  it "has the correct number of episodes" do
    episodes = Hulu::Show.new('Burn Notice').episodes
    episodes.count.should == 1
  end

end

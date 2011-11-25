require 'spec_helper'

describe Hulu::Show do
  let(:burn_notice_erb) { 
    {
      title: 'Burn baby burn', 
      running_time: '43:09',
      air_date: '11/03/2011',
      episode: '13' 
    }
  }

  it "should know it's name" do
    Hulu::Show.new('Bones').name.should == 'Bones'
  end

  it "created episodes with correct attributes" do
    VCR.use_cassette('burn_notice', erb: burn_notice_erb) do
      episodes = Hulu::Show.new('Burn Notice').episodes
      episode = episodes.first

      episode.title.should == 'Burn baby burn'
      episode.running_time.should == '43:09'
      episode.air_date.should == '11/03/2011'
      episode.episode.should == '13'
    end
  end

  it "has the correct number of episodes" do
    VCR.use_cassette('burn_notice', erb: burn_notice_erb) do
      episodes = Hulu::Show.new('Burn Notice').episodes

      episodes.count.should == 1
    end
  end

end

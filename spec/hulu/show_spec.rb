# encoding: utf-8

require 'json'

require 'spec_helper'

describe Hulu::Show do

  let(:additional_attributes) { 
    {
        "thumbnail_width" => 145,
        "type" => "video",
        "title" => "Shadows (Warehouse 13)",
        "embed_url" =>  "http://www.hulu.com/embed/Gp_eWf7PQr697Ol0j7OfEg",
        "thumbnail_height" => 80,
        "height" =>  296,
        "provider_name" => "Hulu",
        "width" => 512,
        "html" => "<object width=\"512\" height=\"296\"><param name=\"movie\" value=\"http://www.hulu.com/embed/Gp_eWf7PQr697Ol0j7OfEg\"></param><param name=\"flashvars\" value=\"ap=1\"></param><embed src=\"http://www.hulu.com/embed/Gp_eWf7PQr697Ol0j7OfEg\" type=\"application/x-shockwave-flash\" width=\"512\" height=\"296\" flashvars=\"ap=1\"></embed></object>",
        "provider_url" => "http://www.hulu.com/",
        "duration" => 2584.25,
        "version" => "1.0",
        "cache_age" => 3600,
        "air_date" => "Mon Sep 12 00:00:00 UTC 2011",
        "thumbnail_url" => "http://thumbnails.hulu.com/188/40038188/40038188_145x80_generated.jpg",
        "author_name" => "Syfy"
    }
  }

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

    let(:description) { "A wayward soul searches for redemption in a land of unforgiveness." }

    before do
      Hulu::Episode.any_instance.stub(:additional_attributes).and_return(additional_attributes)
      Hulu::Episode.any_instance.stub(:fetch_description).and_return(description)

      VCR.insert_cassette('burn_notice', erb: burn_notice_erb)
    end

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
      episode.season.should       == '5'
      episode.episode.should      == '13'
      episode.url.should          == "http://www.hulu.com/watch/296648/burn-notice-damned-if-you-do#x-4,cEpisodes,1,0"
      episode.beaconid.should     == '296648'

      # additional_attributes
      episode.thumbnail_url.should == "http://thumbnails.hulu.com/188/40038188/40038188_145x80_generated.jpg"
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

  context "When Terra Nova" do
    before do 
      Hulu::Episode.any_instance.stub(:additional_attributes).and_return(additional_attributes)
      Hulu::Episode.any_instance.stub(:fetch_description).and_return("No mans land")

      VCR.insert_cassette('terra_nova', erb: {beaconid: '302363'} )
    end

    after { VCR.eject_cassette }

    it 'should find the beaconid' do
      episodes = Hulu::Show.new('Terra Nova').episodes
      episode = episodes.first

      episode.beaconid.should     == '302363'
      episode.title.should        == 'Vs.'
      episode.running_time.should == '42:14'
      episode.air_date.should     == '11/21/2011'
      episode.episode.should      == '8'
      episode.season.should       == '1'
      episode.url.should          == "http://www.hulu.com/watch/302363/terra-nova-vs#x-0,vepisode,1,0"
    end
  end

  context "Show name has special characters" do
    before do 
      Hulu::Episode.any_instance.stub(:additional_attributes).and_return(additional_attributes)
      Hulu::Episode.any_instance.stub(:fetch_description).and_return("No mans land")

      VCR.insert_cassette('special_victims_unit')
    end

    after { VCR.eject_cassette }

    it 'should find the correct show' do
      episodes = Hulu::Show.new('Law & Order: Special Victims Unit').episodes
      episode = episodes.first

      episode.beaconid.should     == '300844'
      episode.title.should        == 'Educated Guess'
      episode.running_time.should == '44:04'
      episode.air_date.should     == '11/16/2011'
      episode.episode.should      == '8'
      episode.season.should       == '13'
      episode.url.should          == "http://www.hulu.com/watch/300844/law-and-order-special-victims-unit-educated-guess#x-0,vepisode,1,0"
    end
  end
end

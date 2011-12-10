require 'spec_helper'

describe Hulu do
  before do 
		Hulu::Episode.any_instance.stub(:fetch_description).and_return("No mans land")
		VCR.insert_cassette('shows')
	end

	after { VCR.eject_cassette }

	it "returns an array of shows" do
		titles = ['Burn Notice', 'Warehouse 13', 'Terra Nova']
		shows = Hulu.shows(titles)

		shows.count.should == 3
		# shows.first.episodes.first.title.should == 'What'
	end

end

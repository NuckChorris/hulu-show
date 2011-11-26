require 'spec_helper'

describe Hulu do
  
  it "returns an array of shows" do
    titles = ['Burn Notice', 'Warehouse 13', 'Terra Nova']
    shows = Hulu.shows(titles)

    shows.count.should == 3
    # shows.first.episodes.first.title.should == 'What'
  end

end

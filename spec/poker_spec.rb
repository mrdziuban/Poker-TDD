require 'rspec'
require 'poker'

describe Game do
  let(:game) {Game.new}

  it "initializes with a deck" do
    game.deck.should_not be_nil
  end

  it "initializes with a players hash" do
    expect(game.players).to be_a_kind_of(Hash)
  end

  describe "#update_current_player" do
    it "changes the current player" do
      game.stub(:gets).and_return(3)
      current = game.player_number
      game.update_current_player
      expect(current).to_not eq(game.player_number)
    end
  end

  describe "#add_to_pot" do
    it "increments the pot" do
      game.add_to_pot(50)
      game.pot.should == 50
    end

    it "decreases the pot" do
      game.pay_from_pot(25)
      game.pot.should == -25
    end
  end

  describe "#player_fold" do
    it "updates player number" do
      num = game.player_number
      game.player_fold
      expect(num).to not_eq(game.player_number)
    end
  end
end
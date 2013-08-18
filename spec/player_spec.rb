require 'rspec'
require 'player'
require 'deck'

describe Player do
  let(:deck) {Deck.all_cards}
  let(:player) {Player.new(deck, 200)}

  it "initializes with a hand and a pot" do
    player.hand.should_not be_nil
    player.pot.should_not be_nil
  end

  describe "#discard" do
    it "returns an array of suits and values" do
      expect(player.discard).to be_a_kind_of(Array)
    end
  end

  describe "#take_turn" do
    it "returns a symbol" do
      expect(player.take_turn).to be_a_kind_of(Symbol)
    end
  end

  describe "#place_bet" do
    it "reduces pot by bet amount" do
      player.place_bet(50)
      player.pot.should == 150
    end
  end

  describe "#pay_winnings" do
    it "increments pot by right amount" do
      player.pay_winnings(50)
      player.pot.should == 250
    end
  end
end
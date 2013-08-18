require 'deck'
require 'rspec'

describe Deck do
  subject(:deck) {Deck.new}

  describe "::all_cards" do
    it "returns all 52 cards" do
      cards = Deck.all_cards
      cards.count == 52

      cards.uniq.count == 52
    end
  end

  it "checks if a card is included" do
    card = Card.new(:spades, :king)
    deck.include?(card).should be_true
  end

  it "shuffles the cards" do
    expect do
      deck.shuffle
    end.to change{deck.peek}
  end

  describe "#take" do
    it "takes n number of cards" do
      taken_cards = deck.take(5)
      taken_cards.count.should == 5
      taken_cards.each {|card| card.is_a? Card}
    end

    it "removes cards from deck" do
      taken_cards = deck.take(5)
      deck.count.should == 47
    end
  end

  describe "#return_cards" do
    let(:taken_cards) {deck.take(5)}

    it "returns cards to deck" do
      deck.return_cards(taken_cards)
      deck.count.should == 52

      taken_cards.each do |card|
        deck.should include(card)
      end
    end
  end
end
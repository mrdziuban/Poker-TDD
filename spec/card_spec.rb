# encoding: UTF-8
require 'card'
require 'rspec'

describe Card do
  describe "::self.suits" do
    it "returns all suits" do
      suits = Card.suits
      suits == Card::SUIT_STRINGS.keys
    end
  end

  describe "::self.values" do
    it "returns all values" do
      values = Card.values
      values == Card::VALUE_STRINGS.keys
    end
  end

  it "initializes with a suit and value" do
    expect do
      card = Card.new(:spades, :king)
    end.to_not raise_error
  end

  it "compares two cards" do
    card = Card.new(:spades, :king)
    card == Card.new(:spades, :king)
  end

  it "returns a string" do
    card = Card.new(:spades, :king)
    card.to_s == "K♠"
  end
end
require_relative 'card'

class Deck
  def self.all_cards
    cards = []
    Card::SUIT_STRINGS.keys.each do |suit|
      Card::VALUE_STRINGS.keys.each do |value|
        cards << Card.new(suit, value)
      end
    end
    cards.shuffle
  end

  attr_accessor :cards

  def initialize(cards = Deck.all_cards)
    @cards = cards
  end

  def count
    @cards.count
  end

  def peek
    @cards[-1]
  end

  def include?(card)
    @cards.include?(card)
  end

  def shuffle
    @cards.shuffle!
  end

  def take(n)
    raise "not enough cards" if n > 52
    @cards.shift(n)
  end

  def return_cards(cards)
    cards.each {|card| @cards << card}
  end
end
require_relative 'hand'
require_relative 'deck'
require_relative 'card'

class Player
  attr_accessor :hand, :pot, :current_bet, :deck, :turn_number

  def initialize(deck, pot)
    @hand = Hand.deal_from(deck)
    @deck = deck
    @pot = pot
    @current_bet = 0
    @turn_number = 1
  end

  def discard
    print "Which cards would you like to discard? (e.g. ace of spades, seven of hearts, deuce of diamonds) "

    cards = gets.chomp.split(",").map {|card| card.strip}
    cards.map! {|card| card.split}
    cards.each do |card| 
      card.delete_at(1)
      card.map! {|i| i.to_sym}
      card.reverse!
    end

    trade_cards(cards)
  end

  def trade_cards(cards)
    cards_to_discard = []
    cards.each do |card1|
      @hand.cards.each do |card2|
        cards_to_discard << card2 if card1[0] == card2.suit && card1[1] == card2.value
      end
    end
    @deck.return_cards(cards_to_discard)
    cards_to_discard.each {|card| @hand.cards.delete(card)}
    cards_to_take = @deck.take(cards_to_discard.length)
    cards_to_take.each {|card| @hand.cards << card}
  end

  def display_hand
    p @hand.cards
  end

  def take_turn
    print "Would you like to fold, see, or raise? "
    gets.chomp.to_sym
  end

  def place_bet(amount)
    @pot -= amount
    @current_bet += amount
  end

  def pay_winnings(amount)
    @pot += amount
  end
end
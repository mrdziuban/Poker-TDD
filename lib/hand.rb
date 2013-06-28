require_relative 'deck'
require_relative 'card'

class Hand
  HAND_VALUES = {
    "straight flush" => 9,
    "four of a kind" => 8,
    "full house" => 7,
    "flush" => 6,
    "straight" => 5,
    "three of a kind" => 4,
    "two pair" => 3,
    "pair" => 2,
    "high card" => 1
  }

  def self.deal_from(deck)
    Hand.new(deck.take(5))
  end

  attr_accessor :cards, :cards_to_test

  def initialize(cards)
    @cards = cards
    @cards.sort_by! {|card| Card::POKER_VALUES[card.value]}
    @cards_to_test = @cards.dup
  end

  def beats?(other_hand)
    hand_evaluation = self.evaluate_hand
    other_hand_evaluation = other_hand.evaluate_hand

    if hand_evaluation == other_hand_evaluation
      case hand_evaluation
      when "high_card"
        cards[-1].higher_than?(other_hand.cards[-1])
      when "pair"
        if pair?[1][0].higher_than?(other_hand.pair?[1][0]).nil?
          return cards_to_test[-1].higher_than?(other_hand.cards_to_test[-1])
        end
        pair?[1][0].higher_than?(other_hand.pair?[1][0])
      when "two pair"
        if two_pair?[1][1][0].higher_than?(other_hand.two_pair?[1][1][0]).nil?
          return two_pair?[1][0][0].higher_than?(other_hand.two_pair?[1][0][0])
        end
        two_pair?[1][1][0].higher_than?(other_hand.two_pair?[1][1][0])
      when "three of a kind"
        if three_of_a_kind?[1][0].higher_than?(other_hand.three_of_a_kind?[1][0]).nil?
          return cards_to_test[-1].higher_than?(other_hand.cards_to_test[-1])
        end
        three_of_a_kind?[1][0].higher_than?(other_hand.three_of_a_kind?[1][0])
      when "straight", "flush", "straight flush"
        cards[-1].higher_than?(other_hand.cards[-1])
      when "full house"
        if full_house?[1][0].higher_than?(other_hand.full_house?[1][0]).nil?
          return full_house?[2][0].higher_than?(other_hand.full_house?[2][0])
        end
        full_house?[1][0].higher_than?(other_hand.full_house?[1][0])
      when "four of a kind"
        if four_of_a_kind?[1][0].higher_than?(other_hand.four_of_a_kind?[1][0]).nil?
          return cards_to_test[-1].higher_than?(other_hand.cards_to_test[-1])
        end
        four_of_a_kind?[1][0].higher_than?(other_hand.four_of_a_kind?[1][0])
      end
    else
      HAND_VALUES[hand_evaluation] > HAND_VALUES[other_hand_evaluation]
    end
  end

  def evaluate_hand
    if straight_flush?
      "straight flush"
    elsif four_of_a_kind?[0]
      "four of a kind"
    elsif full_house?[0]
      "full house"
    elsif flush?
      "flush"
    elsif straight?
      "straight"
    elsif three_of_a_kind?[0]
      "three of a kind"
    elsif two_pair?[0]
      "two pair"
    elsif pair?[0]
      "pair"
    else
      "high card"
    end
  end

  # Return_value[1] = pair
  def pair?
    cards.each_with_index do |card, index1|
      (index1+1...cards.length).each do |index2|
        if card.value == cards[index2].value
          cards_to_test.delete(card)
          cards_to_test.delete(cards[index2])
          return [true, [card, cards[index2]]]
        end
      end
    end
    [false]
  end

  # Return_value[1] = pairs
  # pairs[1] = high pair
  # pairs[0] = low pair
  def two_pair?
    pair_count = 0
    pairs = []
    cards.each_with_index do |card, index1|
      (index1+1...cards.length).each do |index2|
        if card.value == cards[index2].value
          pair_count += 1
          pairs << [card, cards[index2]]
          cards_to_test.delete(card)
          cards_to_test.delete(cards[index2])
        end
      end
    end
    pair_count == 2 ? [true, pairs] : [false]
  end

  # Return_value[1] = three of a kind cards
  def three_of_a_kind?
    cards.each_with_index do |card, index1|
      matching_cards = [card]
      match_count = 1
      (index1+1...cards.length).each do |index2|
        if card.value == cards[index2].value
          match_count += 1 
          matching_cards << cards[index2]
        end
      end
      if match_count == 3
        matching_cards.each {|card| cards_to_test.delete(card)}
        return [true, matching_cards]
      end
    end
    [false]
  end

  # Return_value[1] = four of a kind cards
  def four_of_a_kind?
    cards.each_with_index do |card, index1|
      matching_cards = [card]
      match_count = 1
      (index1+1...cards.length).each do |index2|
        if card.value == cards[index2].value
          match_count += 1
          matching_cards << cards[index2]
        end
      end
      if match_count == 4
        matching_cards.each {|card| cards_to_test.delete(card)}
        return [true, matching_cards]
      end
    end
    [false]
  end

  # Return_value[1] = three of a kind cards
  # Return_value[2] = pair of cards
  def full_house?
    if three_of_a_kind?[0]
      if cards_to_test[0].value == cards_to_test[1].value
        return [true, three_of_a_kind?[1], [cards_to_test[0], cards_to_test[1]]]
      end
    end
    [false]
  end

  # Does not need to return any cards, because all 5 compose the straight (compare any 2 cards)
  def straight?
    cards.each_with_index do |card, index|
      next if index + 1 == cards.length
      return false unless Card::POKER_VALUES[cards[index + 1].value] == Card::POKER_VALUES[card.value] + 1
    end
  end

  # Does not need to return any cards, because all 5 compose the flush (cards[-1] is highest)
  def flush?
    cards.each_with_index do |card, index|
      next if index + 1 == cards.length
      return false unless card.suit == cards[index + 1].suit
    end
  end

  def straight_flush?
    straight? && flush?
  end
end
require 'hand'
require 'card'
require 'deck'
require 'rspec'

describe Hand do
  describe "::deal_from" do
    it "deals five cards" do
      cards = [Card.new(:spades, :ace), Card.new(:spades, :king),
        Card.new(:spades, :three), Card.new(:spades, :deuce), Card.new(:spades, :five)]
      deck = Deck.new(cards.dup)
      hand = Hand.deal_from(deck)

      deck.count.should == 0
      hand.cards.should =~ cards
    end
  end

  describe "#pair?" do
    it "checks hand for a pair" do
      hand = Hand.new([Card.new(:spades, :ace), Card.new(:clubs, :ace),
        Card.new(:spades, :three), Card.new(:spades, :deuce), Card.new(:spades, :five)])

      hand.pair?[0].should be_true
      hand.cards_to_test.count.should == 3
      hand.evaluate_hand.should == "pair"
    end

    it "returns false when no pair" do
      hand = Hand.new([Card.new(:spades, :ace), Card.new(:spades, :king),
        Card.new(:spades, :three), Card.new(:spades, :deuce), Card.new(:spades, :five)])

      hand.pair?[0].should be_false
      hand.cards_to_test.count.should == 5
    end
  end

  describe "#two_pair?" do
    it "returns true when two pair" do
      hand = Hand.new([Card.new(:spades, :ace), Card.new(:clubs, :ace),
        Card.new(:spades, :three), Card.new(:clubs, :three), Card.new(:spades, :five)])

      hand.two_pair?[0].should be_true
      hand.cards_to_test.count.should == 1
      hand.evaluate_hand.should == "two pair"
    end

    it "returns false when one pair" do
      hand = Hand.new([Card.new(:spades, :ace), Card.new(:clubs, :ace),
        Card.new(:spades, :three), Card.new(:spades, :deuce), Card.new(:spades, :five)])

      hand.two_pair?[0].should be_false
      hand.cards_to_test.count.should == 3
    end

    it "returns false when no pairs" do
      hand = Hand.new([Card.new(:clubs, :ace), Card.new(:spades, :king),
        Card.new(:spades, :three), Card.new(:spades, :deuce), Card.new(:spades, :five)])

      hand.two_pair?[0].should be_false
      hand.cards_to_test.count.should == 5
      hand.evaluate_hand.should == "high card"
    end
  end

  describe "#three_of_a_kind?" do
    it "returns true when three of a kind" do
      hand = Hand.new([Card.new(:spades, :ace), Card.new(:clubs, :ace),
        Card.new(:diamonds, :ace), Card.new(:spades, :deuce), Card.new(:spades, :five)])

      hand.three_of_a_kind?[0].should be_true
      hand.evaluate_hand.should == "three of a kind"
    end

    it "returns false when a pair" do
      hand = Hand.new([Card.new(:spades, :ace), Card.new(:spades, :ace),
        Card.new(:spades, :three), Card.new(:spades, :deuce), Card.new(:spades, :five)])

      hand.three_of_a_kind?[0].should be_false
    end

    it "returns false when nothing" do
      hand = Hand.new([Card.new(:spades, :ace), Card.new(:spades, :king),
        Card.new(:spades, :three), Card.new(:spades, :deuce), Card.new(:spades, :five)])

      hand.three_of_a_kind?[0].should be_false
    end
  end

  describe "#four_of_a_kind?" do
    it "returns true when four of a kind" do
      hand = Hand.new([Card.new(:spades, :ace), Card.new(:clubs, :ace),
        Card.new(:diamonds, :ace), Card.new(:hearts, :ace), Card.new(:spades, :five)])

      hand.four_of_a_kind?[0].should be_true
      hand.evaluate_hand.should == "four of a kind"
    end
  end

  describe "#full_house?" do
    it "returns true when full house" do
      hand = Hand.new([Card.new(:spades, :ace), Card.new(:clubs, :ace),
        Card.new(:diamonds, :ace), Card.new(:spades, :deuce), Card.new(:clubs, :deuce)])

      hand.full_house?[0].should be_true
      hand.evaluate_hand.should == "full house"
    end

    it "returns false when three of a kind" do
      hand = Hand.new([Card.new(:spades, :ace), Card.new(:clubs, :ace),
        Card.new(:diamonds, :ace), Card.new(:spades, :deuce), Card.new(:clubs, :three)])

      hand.full_house?[0].should be_false
    end

    it "returns false when a pair" do
      hand = Hand.new([Card.new(:spades, :ace), Card.new(:clubs, :ace),
        Card.new(:diamonds, :five), Card.new(:spades, :deuce), Card.new(:clubs, :three)])

      hand.full_house?[0].should be_false
    end
  end

  describe "#straight?" do
    it "returns true when a straight" do
      hand = Hand.new([Card.new(:spades, :deuce), Card.new(:clubs, :three),
        Card.new(:diamonds, :four), Card.new(:hearts, :five), Card.new(:spades, :six)])

      hand.straight?.should be_true
      hand.evaluate_hand.should == "straight"
    end
  end

  describe "#flush?" do
    it "returns true when a flush" do
      hand = Hand.new([Card.new(:spades, :deuce), Card.new(:spades, :three),
        Card.new(:spades, :four), Card.new(:spades, :five), Card.new(:spades, :seven)])

      hand.flush?.should be_true
      hand.evaluate_hand.should == "flush"
    end
  end

  describe "#straight_flush?" do
    it "returns true when a straight flush" do
      hand = Hand.new([Card.new(:spades, :deuce), Card.new(:spades, :three),
        Card.new(:spades, :four), Card.new(:spades, :five), Card.new(:spades, :six)])

      hand.straight_flush?.should be_true
      hand.evaluate_hand.should == "straight flush"
    end

    it "returns false when only a straight" do
      hand = Hand.new([Card.new(:clubs, :deuce), Card.new(:diamonds, :three),
        Card.new(:hearts, :four), Card.new(:spades, :five), Card.new(:spades, :six)])

      hand.straight_flush?.should be_false
    end

    it "returns false when only a flush" do
      hand = Hand.new([Card.new(:spades, :three), Card.new(:spades, :three),
        Card.new(:spades, :king), Card.new(:spades, :deuce), Card.new(:spades, :nine)])

      hand.straight_flush?.should be_false
    end
  end

  describe "#evaluate_hand" do
    it "returns \"flush\" when royal flush" do
      hand = Hand.new([Card.new(:spades, :ace), Card.new(:spades, :ten),
        Card.new(:spades, :jack), Card.new(:spades, :king), Card.new(:spades, :queen)])

      hand.evaluate_hand.should == "straight flush"
    end
  end

  describe "#beats?" do
    it "is correct for better hand" do
      hand = Hand.new([Card.new(:spades, :ace), Card.new(:spades, :ten),
        Card.new(:spades, :jack), Card.new(:spades, :king), Card.new(:spades, :queen)])
      other_hand = Hand.new([Card.new(:clubs, :ace), Card.new(:spades, :king),
        Card.new(:spades, :three), Card.new(:spades, :deuce), Card.new(:spades, :five)])

      hand.beats?(other_hand).should be_true
    end

    it "is correct for worse hand" do
      hand = Hand.new([Card.new(:clubs, :ace), Card.new(:spades, :king),
        Card.new(:spades, :three), Card.new(:spades, :deuce), Card.new(:spades, :five)])
      other_hand = Hand.new([Card.new(:spades, :ace), Card.new(:spades, :ten),
        Card.new(:spades, :jack), Card.new(:spades, :king), Card.new(:spades, :queen)])

      hand.beats?(other_hand).should be_false
    end

    it "is correct when both pairs and one higher" do
      hand = Hand.new([Card.new(:spades, :ace), Card.new(:clubs, :ace),
        Card.new(:spades, :three), Card.new(:spades, :deuce), Card.new(:spades, :five)])
      other_hand = Hand.new([Card.new(:spades, :king), Card.new(:clubs, :ace),
        Card.new(:spades, :three), Card.new(:clubs, :three), Card.new(:spades, :five)])

      hand.beats?(other_hand).should be_true
    end

    it "is correct when using high card to break pair tie" do
      hand = Hand.new([Card.new(:spades, :ace), Card.new(:clubs, :ace),
        Card.new(:spades, :king), Card.new(:spades, :deuce), Card.new(:spades, :five)])
      other_hand = Hand.new([Card.new(:spades, :ace), Card.new(:clubs, :ace),
        Card.new(:spades, :deuce), Card.new(:clubs, :three), Card.new(:spades, :five)])

      hand.beats?(other_hand).should be_true
    end

    it "is correct for two pair test" do
      hand = Hand.new([Card.new(:spades, :ace), Card.new(:clubs, :ace),
        Card.new(:spades, :three), Card.new(:clubs, :three), Card.new(:spades, :five)])
      other_hand = Hand.new([Card.new(:spades, :king), Card.new(:clubs, :king),
        Card.new(:spades, :three), Card.new(:clubs, :three), Card.new(:spades, :five)])

      hand.beats?(other_hand).should be_true
    end

    it "is correct for two pair when high pair is same" do
      hand = Hand.new([Card.new(:spades, :ace), Card.new(:clubs, :ace),
        Card.new(:spades, :four), Card.new(:clubs, :four), Card.new(:spades, :five)])
      other_hand = Hand.new([Card.new(:spades, :ace), Card.new(:clubs, :ace),
        Card.new(:spades, :three), Card.new(:clubs, :three), Card.new(:spades, :five)])

      hand.beats?(other_hand).should be_true
    end

    it "is correct for three of a kind" do
      hand = Hand.new([Card.new(:spades, :ace), Card.new(:clubs, :ace),
        Card.new(:diamonds, :ace), Card.new(:spades, :deuce), Card.new(:spades, :five)])
      other_hand = Hand.new([Card.new(:spades, :three), Card.new(:clubs, :three),
        Card.new(:diamonds, :three), Card.new(:spades, :deuce), Card.new(:spades, :five)])

      hand.beats?(other_hand).should be_true
    end

    it "is correct when comparing straights" do
      hand = Hand.new([Card.new(:spades, :deuce), Card.new(:clubs, :three),
        Card.new(:diamonds, :four), Card.new(:hearts, :five), Card.new(:spades, :six)])
      other_hand = Hand.new([Card.new(:spades, :three), Card.new(:clubs, :four),
        Card.new(:diamonds, :five), Card.new(:hearts, :six), Card.new(:spades, :seven)])

      hand.beats?(other_hand).should be_false
    end

    it "is correct when comparing flushes" do
      hand = Hand.new([Card.new(:spades, :deuce), Card.new(:spades, :three),
        Card.new(:spades, :four), Card.new(:spades, :five), Card.new(:spades, :seven)])
      other_hand = Hand.new([Card.new(:spades, :eight), Card.new(:spades, :nine),
        Card.new(:spades, :ten), Card.new(:spades, :jack), Card.new(:spades, :queen)])

      hand.beats?(other_hand).should be_false
    end

    it "is correct when comparing full houses by threes" do
      hand = Hand.new([Card.new(:spades, :king), Card.new(:clubs, :king),
        Card.new(:diamonds, :king), Card.new(:spades, :deuce), Card.new(:clubs, :deuce)])
      other_hand = Hand.new([Card.new(:spades, :ace), Card.new(:clubs, :ace),
        Card.new(:diamonds, :ace), Card.new(:spades, :deuce), Card.new(:clubs, :deuce)])

      hand.beats?(other_hand).should be_false
    end

    it "is correct when comparing full houses by pair" do
      hand = Hand.new([Card.new(:spades, :ace), Card.new(:clubs, :ace),
        Card.new(:diamonds, :ace), Card.new(:spades, :deuce), Card.new(:clubs, :deuce)])
      other_hand = Hand.new([Card.new(:spades, :ace), Card.new(:clubs, :ace),
        Card.new(:diamonds, :ace), Card.new(:spades, :three), Card.new(:clubs, :three)])

      hand.beats?(other_hand).should be_false
    end

    it "is correct when comparing four of a kinds" do
      hand = Hand.new([Card.new(:spades, :ace), Card.new(:clubs, :ace),
        Card.new(:diamonds, :ace), Card.new(:hearts, :ace), Card.new(:spades, :five)])
      other_hand = Hand.new([Card.new(:spades, :three), Card.new(:clubs, :three),
        Card.new(:diamonds, :three), Card.new(:hearts, :deuce), Card.new(:spades, :five)])

      hand.beats?(other_hand).should be_true
    end

    it "is correct when comparing four of a kinds by high card" do
      hand = Hand.new([Card.new(:spades, :ace), Card.new(:clubs, :ace),
        Card.new(:diamonds, :ace), Card.new(:hearts, :ace), Card.new(:spades, :king)])
      other_hand = Hand.new([Card.new(:spades, :ace), Card.new(:clubs, :ace),
        Card.new(:diamonds, :ace), Card.new(:hearts, :ace), Card.new(:spades, :five)])

      hand.beats?(other_hand).should be_true
    end

    it "is correct when comparing straight flushes" do
      hand = Hand.new([Card.new(:spades, :nine), Card.new(:spades, :ten),
        Card.new(:spades, :jack), Card.new(:spades, :queen), Card.new(:spades, :king)])
      other_hand = Hand.new([Card.new(:spades, :deuce), Card.new(:spades, :three),
        Card.new(:spades, :four), Card.new(:spades, :five), Card.new(:spades, :six)])

      hand.beats?(other_hand).should be_true
    end
  end
end
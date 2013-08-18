require_relative 'player'
require_relative 'hand'
require_relative 'deck'
require_relative 'card'

class Game
  attr_accessor :deck, :players, :player_number, :current_player, :pot, :current_bet, :players_in_game

  def initialize
    @deck = Deck.new
    @pot = 0
    @current_bet = 0

    print "How many players? "
    num_players = gets.chomp.to_i
    @players_in_game = (1..num_players).to_a

    @players = {}
    num_players.times do |i|
      @players[i+1] = Player.new(@deck, 100)
    end

    @player_number = 1
    @current_player = @players[@player_number]

    play_round
  end

  def play_round
    num_of_sees = 0
    until num_of_sees == @players_in_game.length
      puts "Player #{@player_number}'s turn"
      @current_player.display_hand
      if @current_player.turn_number == 1
        print "Would you like to trade in cards? (yes/no) "
        answer = gets.chomp
        if answer == 'yes'
          @current_player.discard
          @current_player.display_hand
        end
      end
      puts "Current bet is #{@current_bet}"
      turn = @current_player.take_turn
      case turn
      when :fold
        puts "Player #{@player_number} folds"
        player_fold
      when :raise
        puts "Player #{@player_number} raises"
        player_raise
      when :see
        puts "Player #{@player_number} sees"
        player_see
        num_of_sees += 1
      end
    end
    show_cards
    winning_player = evaluate_round
    winning_player.pay_winnings(@pot)
    @players.each {|k,v| puts "Player #{k} wins!" if v == winning_player}
    puts winning_player.pot
    nil
  end

  def player_fold
    @current_player.turn_number += 1
    num = @player_number
    update_current_player
    @players_in_game.delete(num)
    @players.delete(num)
  end

  def player_raise
    @current_player.turn_number += 1
    print "How much do you want to raise by? "
    raise_amt = gets.chomp.to_i
    @current_player.place_bet(raise_amt)
    add_to_pot(raise_amt)
    @current_bet += raise_amt
    update_current_player
  end

  def player_see
    @current_player.turn_number += 1
    # Amount to raise by is game.current_bet - player.current_bet
    see_amt = @current_bet - @current_player.current_bet
    @current_player.place_bet(see_amt)
    add_to_pot(see_amt)
    update_current_player
  end

  def update_current_player
    if @player_number == @players_in_game[-1]
      @player_number = @players_in_game[0]
    else
      i = @players_in_game.index(@player_number)
      @player_number = @players_in_game[i+1]
    end
    @current_player = @players[@player_number]
  end

  def show_cards
    @players.each do |player_num, player| 
      print "#{player_num} "
      player.display_hand
    end
  end

  def evaluate_round
    @players.values.each_with_index do |x, i|
      players_beaten = 0
      player = @players.values.slice(i)
      other_players = @players.values.select {|j| j != player}
      other_players.each do |y|
        players_beaten += 1 if player.hand.beats?(y.hand)
      end
      return x if players_beaten == @players.values.length - 1
    end
  end

  def add_to_pot(amount)
    @pot += amount
  end

  def pay_from_pot(amount)
    @pot -= amount
  end
end

if __FILE__ == $PROGRAM_NAME
  Game.new
end
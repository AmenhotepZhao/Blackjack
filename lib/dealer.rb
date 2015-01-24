# Fan Zhao

require_relative './card.rb'
require_relative './deck.rb'
require_relative './hand.rb'

# The class Dealer
class Dealer
  
  attr_reader :hand

  def initialize
    @hand = Hand.new
  end

  # This method makes the dealer to be ready for a new round
  # it creates a new hand for the dealer
  #
  def be_ready_to_game
    @hand = Hand.new
  end
  
  # This method checks if the dealer must make a hit
  # it must hit when its hand <= 16
  #
  def must_hit
    return true if @hand.point != "Blackjack" && @hand.point <= 16
    return false
  end

  # This method creates string to represent the dealer
  #
  def to_s
   return  "Dealer"
  end

  # This method shows the dealer's hand
  #
  def show_hand
    if @hand.point == "Blackjack" # the dealer should reveal both cards when it has blackjack
      @hand.turn_all_cards_up
      puts "    #{@hand.to_s}  Blackjack\n" 
    else
      puts "    #{@hand.to_s}\n"
    end
  end

  # This method turns all the cards in the hand face up, and shows the hand
  #
  def show_hand_all_face_up
    @hand.turn_all_cards_up
    str = "    #{@hand.to_s}  points: #{@hand.point}"
    str << " (bust)" if @hand.is_bust
    str << "\n"
    puts str
  end

end

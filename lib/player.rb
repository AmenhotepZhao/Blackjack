# fan Zhao

require_relative './card.rb'
require_relative './deck.rb'
require_relative './hand.rb'

# The class Player
class Player 

  attr_reader :name
  attr_reader :chips
  attr_reader :hands

  def initialize(name, chips = 1000)
    @name = name
    @chips = chips
    @hands = Hash.new(0) #This hash stores hands and their bets, default bet 0
    @deck = nil
  end

  # This method creates a new array of hands
  #
  def be_ready_to_game
    @hands = Hash.new(0)
  end

  # This method assigns a deck to the player
  #
  def assign_deck(deck)
    @deck = deck
  end

  # This method makes a bet, or change a bet
  #
  # Params
  # +bet+ :: the amount of the bet
  #
  def make_bet(bet)
    return if bet <= 0
    hand = Hand.new # creates a hand, when making a bet
    @hands[hand] = bet
    @chips -= bet
    2.times {hand.hit(@deck)} # draws 2 cards for the hand
  end

  # This method plays blackjack
  def move
    hands_to_deal = Array.new
    # hands_to_deal is usd as a stack
    @hands.each_key { |hand| hands_to_deal.unshift(hand) }
    return  if hands_to_deal.size == 0
    puts "-----------------------"
    puts "Move for Player #{@name}"
    puts "-----------------------"
    while hands_to_deal.size > 0 
      hand = hands_to_deal.pop # pop a hand from the stack
      puts "Player #{@name}, for hand #{hand.to_s}"
      answer = ask_decision(hand) 
      case answer
      when "s" # split the hand
        hand1, hand2 = hand.split
        hand1.hit(@deck)
        hand2.hit(@deck)
        bet = @hands[hand]
        @chips -= bet
        # replace the current hand by the two new hands
        @hands.delete(hand)
        @hands[hand2] = @hands[hand1] = bet
        hands_to_deal.push(hand2, hand1)  # push the new hands into stack
      when "d" # double down
        @chips -= hands[hand]
        hands[hand] *= 2
        hand.hit(@deck)
        hand.stand
      when "h" # hit
        hand.hit(@deck)
        hands_to_deal.push(hand) unless hand.is_bust
      when "t" # stand
        hand.stand
      else
        next
      end
      puts ".................................................."
      puts "Player #{@name}"
      show_hands
      puts ".................................................."
      puts "\n"
    end
    puts "--------------------------"
    puts "End of move for Player #{@name}"
    puts "--------------------------"
    puts "\n"
  end


  # This method checks the result after a round
  # 
  # Params
  # +hand_to_compare+ :: the hand to compare
  #
  def check_result(hand_to_compare)
     #This compares the each hand with hand_to_compare.
    @hands.each_pair do |hand, bet| 
      if hand > hand_to_compare
        @chips += 2 * bet
      elsif hand == hand_to_compare
        @chips += bet
      else
      end
    end
  end

  # This method creates a string to represent the player
  def to_s
    "Player #{@name}"
  end

  # shows all the hands of the player
  def show_hands
    if @hands.size == 0 
        puts "    not playing this round!\n" 
        return 
    end
    str = ""
    @hands.each_pair do |hand, bet|
      str << "    #{hand.to_s}  point: #{hand.point}  bet: #{bet} "
      str << " (stood)" if hand.stood
      str << " (bust)" if hand.is_bust 
      str << "\n"
    end
    puts str
  end

  # This method asks the player to make a decision about a hand
  # 
  # Params
  # +question+ :: the question asked
  # +choices+ :: the choices can be selected
  #
  def ask_decision(hand)
    # creates an array of choices
    choices = ["h", "t"]
    question = "Hit (h) or Stand (t)?"
    # if the hand can be double-down, add it to choices
    if hand.size == 2 && @chips >= hands[hand]
      choices.unshift("d")
      question = "Double down (d), " + question
    end
    # if the hand can be spilt, add it to choices
    if hand.can_be_split && @chips >= hands[hand]
      choices.unshift("s")
      question = "Split (s), " + question
    end
    question = "Please make a decision: " + question     
    puts question
    input = gets.chomp
    while !choices.include? input # keeps asking until gets a valid answer
      puts "Please make an input with given choices #{choices}"
      input = gets.chomp
    end
    return input 
  end

end 


# Fan Zhao

require_relative './card.rb'
require_relative './deck.rb'
require_relative './hand.rb'
require_relative './player.rb'
require_relative './dealer.rb'

# The main class
class Game

  def initialize
    @deck = Deck.new
    @dealer = Dealer.new
    @players = Array.new
  end


  # This contains the main loop of the Blakjack game
  #
  def play
    puts "------------------------"
    puts "Welcome to Blackjack!"
    puts "------------------------"
    # asks how many players are in the game
    number = ask_for_number("How many players?", 1, 7) # assumes no more than 7 players
    # creates players
    (1..number).each do |i|
      player = Player.new(i.to_s)
      player.assign_deck(@deck)
      @players.push(player)
    end

    # The main loop
    begin 

      show_all_players_status
      # asks each play to make a bet
      has_player_bet = false
      @players.each do |player| 
        player.be_ready_to_game
        question = "Player #{player.name},  please make your bet, enter 0 to skip this round"  
        if player.chips > 0  
          bet = ask_for_number(question, 0, player.chips)
          player.make_bet(bet) 
          has_player_bet = true if bet > 0
        else  
          puts "Player #{player.name},  you don't have enough chips!" 
        end
      end
      if !has_player_bet # no player plays this round, skip this round
        puts "No player plays this round!\n"
        next
      end

      @dealer.be_ready_to_game
      @dealer.hand.hit(@deck, :face_down) # the first card of dealer's card should be face down
      @dealer.hand.hit(@deck)
      show_all_hands
      # players' moves
      @players.each { |player| player.move }
       show_all_hands
      # dealer's turn
      puts "-----------------------"
      puts "Dealer's move"
      puts "-----------------------"
      while @dealer.must_hit
        @dealer.hand.hit(@deck)  
      end
      show_all_hands
      # checks the results
      @players.each { |player| player.check_result(@dealer.hand) }
      show_result

    end while ask_question("Continue playing?", ["y", "n"]) == "y"

    puts "-------------------"
    puts "Thank you for playing!"
    puts "-------------------"
  end

  # This methodasks a question to the user, 
  #and request the user gives an answer with given choices
  # 
  # Params:
  # +question+ :: the question asked
  # +choices+ :: the choices can be selected
  #
  def ask_question(question ,choices)
    print question
    print "  #{choices} \n"
    input = gets.chomp
    while !choices.include? input
      puts "Please make an input with given choices #{choices}"
      input = gets.chomp
    end
    return input 
  end

  # This method asks the user to input an integer in the desired range
  # 
  # Params:
  # +question+ :: the question asked
  # +min+ :: the min of the desired range
  # +max+ :: the max of the desired range
  #
  def ask_for_number(question, min, max)
    is_valid_input = false
    puts question << " (#{min} - #{max})"
    while !is_valid_input
      number = gets.chomp.strip
      # If input is not integer, asks for another input
      if number.match(/\A[+-]?\d+?(\.\d+)?\Z/) == nil
        puts "Please input an integer:"; next
      end
      number = number.to_i
      # If input is not in the range, asks for another input
      if number < min || number > max
        puts "Please enter an input in the range (#{min} - #{max}):"; next
      end
      is_valid_input = true
    end
    return number
  end

  # This method shows the name and the chips of each player
  #
  def show_all_players_status
    puts "\n"
    puts "Players:"
    @players.each { |player| puts "  #{player.to_s}  chips: #{player.chips}" }
    puts "\n"
  end

  # This method shows all the hands in the game
  #
  def show_all_hands
    puts "**************************************************"
    puts @dealer
    @dealer.show_hand
    @players.each { |player| puts player; player.show_hands }
    puts "**************************************************"
    puts "\n"
  end

  # This method shows the result after a round
  #
  def show_result
    puts "\n"
    puts "-------------------------"
    puts "End of a round"
    puts "-------------------------"
    puts @dealer
    @dealer.show_hand_all_face_up
    @players.each do |player| 
      puts "#{player.to_s}    chips:$#{player.chips} "
      player.show_hands
    end
    puts "\n"
  end

end 

# Fan Zhao

require_relative './card.rb'
require_relative './deck.rb'

# The class Hand
#
# This class describes a hand of cards
# It should be able to hit, split, and it's comparable
#
class Hand
  include Comparable # this class is comparable
  attr_accessor :cards
  attr_reader :stood

  CARD_STATUS = [:face_up, :face_down]

  def initialize
    @cards = Array.new
    @stood = false
  end

  # This method returns the number of cards in the deck
  #
  def size
    return @cards.size
  end

  # This method calculates the point of the hand.
  # It sums the numbers of the cards.
  # Ace can be 1 or 11: This method returns the largest possible point <= 21.
  # returns a string to indicatesa blackjack
  #
  def point
    point = 0
    number_of_ace = 0 
    @cards.each do |card|
      number_of_ace += 1 if card.value == "A" 
      point += card.number # all aces are assumed to be 11 at first
    end
    # If the point is > 21, makes aces to be 1 one by one, until the point <= 21
    while point > 21 && number_of_ace > 0 do
      point -= 10
      number_of_ace -= 1
    end
    # returns a string to indicatesa blackjack
    return "Blackjack" if @cards.size == 2 &&  point == 21 
    return point
  end

  # This method draws a card from a deck
  #
  # Params:
  # +deck+ :: the deck that draws the card from.
  # +status+ :: the new card's status: :face_up or :face_down;  defaut is :face_up
  #
  def hit(deck, status = :face_up)
    case status
      when :face_up
      add_card(deck.next_card) 
      when :face_down
      card = deck.next_card
      card.turn_face_down
      add_card(card)
      else
      raise ArgumentError.new("Invalid option!")
      end
  end

  # This method adds a card to a deck
  #
  # Params:
  # +card+ :: the card added to the deck.
  #
  def add_card(card)
    @cards.push(card)
  end

  # This method turns all the card face-up
  #
  def turn_all_cards_up
    @cards.each { |card| card.turn_face_up }
  end

  # This method splits the hand into two hands
  #
  def split
    return unless can_be_split
    # creates two hands, each has one card from the this hand
    hand1 = Hand.new
    hand1.cards.push(@cards.at(0))
    hand2 = Hand.new
    hand2.cards.push(@cards.at(1))
    # return the new hands 
    return hand1, hand2
  end

  # This method sets the status of the hand to be stood 
  #
  def stand
    @stood = true
  end

  # This method checks if the hand can be split
  # This hand can be split when it's a pair (with the same values)
  #
  def can_be_split
    return  size == 2 && @cards.at(0).number == @cards.at(1).number   
  end

  # This method checks whether the hand is bust
  # It is bust when the total point of the hand is > 21 
  #
  def is_bust
    return point != "Blackjack" && point > 21
  end

  # This method creates a string to represent the hand
  #
  def to_s
    str = ""
    @cards.each { |card| str << "#{card} " }
    return str
  end

  # This method compares this hand with another hand
  # Blackjack is the largert
  # A bust hand is smallest
  # Other hands are compared with their points 
  #
  def <=>(another_hand)
    return -1 if self.point != "Blackjack" &&  another_hand.point == "Blackjack"
    return 1 if self.point == "Blackjack" &&  another_hand.point != "Blackjack"
    return 0 if self.point == "Blackjack" &&  another_hand.point == "Blackjack"
    return -1 if self.point > 21 && another_hand.point <= 21
    return 1 if self.point <= 21 && another_hand.point > 21
    return 0 if self.point > 21 && another_hand.point > 21
    return -1 if self.point < another_hand.point
    return 1 if self.point > another_hand.point
    return 0
  end

end

# Fan Zhao

require_relative './card.rb'

# The class Deck
#
# This class defines a shuffled deck 
# It 's able to draw a card from the deck
#
class Deck

  VALID_SUITS = [:diamonds, :spades, :hearts, :clubs]
  VALID_VALUES = ["2", "3", "4", "5", "6", "7", "8", "9", "10", "J", "Q", "K", "A"]

  attr_reader :deck

  def initialize
    new_deck
  end

  # This method creates a new deck.
  # It has 52 cards and the cards are shuffled.
  #
  def new_deck
    @deck = Array.new
    VALID_SUITS.each do |suit| 
      VALID_VALUES.each do |value|
        @deck.push(Card.new(suit, value))
      end
    end
    @deck.shuffle! # shuffle the deck
  end

  # This method draws a card from the deck. 
  # It creates a new deck when the current deck is empty.
  #
  def next_card 
    new_deck if is_empty
    @deck.pop()
  end

  # This method checks whether the deck is empty
  #
  def is_empty
    return @deck.size == 0
  end

end


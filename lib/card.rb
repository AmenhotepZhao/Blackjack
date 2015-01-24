# Fan Zhao

# The class Card
class Card 

  VALID_SUITS = [:diamonds, :spades, :hearts, :clubs]
  HASH = Hash[:diamonds => "D", :spades => "S", :hearts => "H", :clubs => "C"] 
  VALID_VALUES = ["2", "3", "4", "5", "6", "7", "8", "9", "10", "J", "Q", "K", "A"]

  attr_reader :suit
  attr_reader :value
  attr_reader :is_face_up

  def initialize(suit, value)
    raise ArgumentError.new("Suit type is not valid!") unless VALID_SUITS.include? suit
    raise ArgumentError.new("Card value is not valid!") unless VALID_VALUES.include? value
    @suit = suit
    @value = value
    @is_face_up = true
  end


  # This method returns the number of the card. 
  # It returns 10 for racecards, 11 for ace, and their values for other cards.  
  #
  def number
      return 10 if ["J", "Q", "K"].include? @value
      return 11 if "A" == @value
      return @value.to_i
  end

  # This method turns the card face up.
  #
  def turn_face_up
    @is_face_up = true
  end

  # This method turns the card face down.
  #
  def turn_face_down
    @is_face_up = false
  end

  # This method creates a string to represent the card.
  # It return XXX for a face-down card
  # For face-up cards, to shorten the string, it uses D for Diamonds, C for Clubs,
  # S for Spades and H for Hearts.
  #
  def to_s
    return "XXX" unless @is_face_up
    return "#{HASH[@suit]}-#{@value}" 
  end

end


# Test by RSpec

require_relative '../lib/card.rb'
require_relative '../lib/deck.rb'
require_relative '../lib/hand.rb'
require_relative '../lib/player.rb'
require_relative '../lib/dealer.rb'

describe Card do

  it "should have the same suit and value as input" do
    card = Card.new(:diamonds, "A")
    expect(card.suit).to eq(:diamonds)
    expect(card.value).to eq("A")
    card = Card.new(:spades, "3")
    expect(card.suit).to eq(:spades)
    expect(card.value).to eq("3")
    card = Card.new(:hearts, "J")
    expect(card.suit).to eq(:hearts)
    expect(card.value).to eq("J")
    card = Card.new(:clubs, "K")
    expect(card.suit).to eq(:clubs)
    expect(card.value).to eq("K")
  end

  it "should raise error when input is invalid" do
    expect { Card.new(:s, "1") }.to raise_error
    expect { Card.new(:clubs, "1") }.to raise_error
    expect { Card.new(:clubs, "12") }.to raise_error
  end

  it "should have correct point" do
    (2..10).each do |i| 
      expect(Card.new(:diamonds, i.to_s).number).to eq(i)
    end
    ["J", "Q", "K"].each do |suit|
      expect(Card.new(:clubs, suit).number).to eq(10)
    end
    expect(Card.new(:clubs, "A").number).to eq(11)
  end

  it "should have correct to_s when face up" do
    expect(Card.new(:diamonds, "2").to_s).to eq("D-2")
    expect(Card.new(:diamonds, "A").to_s).to eq("D-A")
    expect(Card.new(:hearts, "J").to_s).to eq("H-J")
    expect(Card.new(:hearts, "3").to_s).to eq("H-3")
    expect(Card.new(:clubs, "5").to_s).to eq("C-5")
    expect(Card.new(:clubs, "Q").to_s).to eq("C-Q")
    expect(Card.new(:spades, "10").to_s).to eq("S-10")
    expect(Card.new(:spades, "K").to_s).to eq("S-K")
  end

  it "should be able to be turned face down" do
    card = Card.new(:clubs, "A")
    card.turn_face_down
    expect(card.is_face_up).to be false
  end
  
  it "should have correct to_s when face down" do
    card = Card.new(:clubs, "A")
    card.turn_face_down
    expect(card.to_s).to eq("XXX")
  end

  it "should be able to be turned face up" do
    card = Card.new(:clubs, "A")
    card.turn_face_down
    card.turn_face_up
    expect(card.is_face_up).to be true
  end

end


describe Deck do

  it "should have 52 cards when created" do
    expect(Deck.new.deck.size).to eq(52)
  end

  it "should pop card when calling next_card" do
    deck = Deck.new
    expect(deck.next_card).to be_instance_of(Card)
    expect(deck.deck.size).to eq(51)
    expect(deck.next_card).to be_instance_of(Card)
    expect(deck.deck.size).to eq(50)
  end

  it "should have no card after it pop 52 cards" do 
    deck = Deck.new
    52.times do 
      deck.next_card
    end
    expect(deck.is_empty).to be true
  end

  it "should build a new set of cards when calling next_card for an empty deck" do
    deck = Deck.new
    53.times do 
      deck.next_card
    end
    expect(deck.deck.size).to eq(51)
  end

end


describe Hand do 

  it "should have an empty array of Cards when created" do
    expect(Hand.new.cards).not_to be_nil
    expect(Hand.new.cards.size).to eq(0)
  end

  it "should be able to add cards" do
    hand = Hand.new
    hand.add_card(Card.new(:clubs, "2"))
    expect(hand.cards.size).to eq(1)
    expect(hand.cards.at(0).to_s).to eq("C-2")
    hand.add_card(Card.new(:diamonds, "J"))
    expect(hand.cards.size).to eq(2)
    expect(hand.cards.at(1).to_s).to eq("D-J")
  end

  it "should have correct size" do 
    hand = Hand.new
    expect(hand.size).to eq(0)
    hand.add_card(Card.new(:clubs, "2"))
    expect(hand.size).to eq(1)
    hand.add_card(Card.new(:clubs, "3"))
    expect(hand.size).to eq(2)
  end 

  it "should be able to hit" do
    hand = Hand.new
    deck = Deck.new
    hand.hit(deck)
    expect(hand.size).to eq(1)
  end

  it "should be able to hit with a face-down card" do 
    hand = Hand.new
    deck = Deck.new
    hand.hit(deck, :face_down)
    expect(hand.size).to eq(1)
    expect(hand.cards.at(0).to_s).to eq("XXX")
  end

  it "should be able to turn all cards face-up" do
    hand = Hand.new
    deck = Deck.new
    hand.hit(deck, :face_down)
    hand.hit(deck, :face_down)
    hand.turn_all_cards_up
    expect(hand.cards.at(0).is_face_up).to be true
    expect(hand.cards.at(1).is_face_up).to be true
  end

  it "should have a blackjack when having 21 with 2 cards" do
    hand = Hand.new
    hand.add_card(Card.new(:clubs, "10"))
    hand.add_card(Card.new(:clubs, "A"))
    expect(hand.point).to eq("Blackjack")
  end

  it "should have a correct point" do
    hand = Hand.new
    expect(hand.point).to eq(0)
    hand.add_card(Card.new(:clubs, "2"))
    expect(hand.point).to eq(2)
    hand.add_card(Card.new(:clubs, "J"))
    expect(hand.point).to eq(12)
    hand.add_card(Card.new(:clubs, "K"))
    expect(hand.point).to eq(22)
    hand.add_card(Card.new(:clubs, "3"))
    expect(hand.point).to eq(25)
  end

  it "should have a correct point with ace" do
    hand = Hand.new
    hand.add_card(Card.new(:clubs, "A"))
    expect(hand.point).to eq(11)
    hand.add_card(Card.new(:clubs, "J"))
    expect(hand.point).to eq("Blackjack")
    hand.add_card(Card.new(:clubs, "K"))
    expect(hand.point).to eq(21)
    hand = Hand.new
    hand.add_card(Card.new(:clubs, "3"))
    expect(hand.point).to eq(3)
    hand.add_card(Card.new(:clubs, "A"))
    expect(hand.point).to eq(14)
    hand.add_card(Card.new(:diamonds, "A"))
    expect(hand.point).to eq(15)
    hand.add_card(Card.new(:diamonds, "10"))
    expect(hand.point).to eq(15)
    hand.add_card(Card.new(:clubs, "J"))
    expect(hand.point).to eq(25)
  end

  it "should has a correct to_s" do
    hand = Hand.new
    expect(hand.to_s).to eq("")
    hand.add_card(Card.new(:clubs, "2"))
    expect(hand.to_s).to eq("C-2 ")
    hand.add_card(Card.new(:diamonds, "J"))
    expect(hand.to_s).to eq("C-2 D-J ")
    hand.add_card(Card.new(:hearts, "K"))
    expect(hand.to_s).to eq("C-2 D-J H-K ")
    hand.add_card(Card.new(:spades, "A"))
    expect(hand.to_s).to eq("C-2 D-J H-K S-A ")
  end

  it "should be comparable" do 
    hand1 = Hand.new
    hand2 = Hand.new
    hand1.add_card(Card.new(:clubs, "2"))
    hand1.add_card(Card.new(:clubs, "9"))
    hand2.add_card(Card.new(:clubs, "K"))
    expect(hand1).to be > hand2

    hand1 = Hand.new
    hand2 = Hand.new
    hand1.add_card(Card.new(:clubs, "3"))
    hand1.add_card(Card.new(:clubs, "7"))
    hand2.add_card(Card.new(:clubs, "K"))
    expect(hand1).to eq(hand2)

    hand1 = Hand.new
    hand2 = Hand.new
    hand1.add_card(Card.new(:clubs, "3"))
    hand1.add_card(Card.new(:clubs, "K"))
    hand2.add_card(Card.new(:clubs, "5"))
    hand2.add_card(Card.new(:clubs, "9"))
    expect(hand1).to be < hand2
  end

  it "should win when it's blackjack" do 
    hand1 = Hand.new
    hand2 = Hand.new
    hand1.add_card(Card.new(:clubs, "A"))
    hand1.add_card(Card.new(:clubs, "10"))
    hand2.add_card(Card.new(:clubs, "K"))
    expect(hand1).to be > hand2

    hand1 = Hand.new
    hand2 = Hand.new
    hand1.add_card(Card.new(:clubs, "A"))
    hand1.add_card(Card.new(:clubs, "10"))
    hand2.add_card(Card.new(:diamonds, "A"))
    hand2.add_card(Card.new(:clubs, "K"))
    expect(hand1).to eq(hand2)
  end

  it "should be able to split when it is a pair" do 
    hand1 = Hand.new
    hand1.add_card(Card.new(:diamonds, "3"))
    hand1.add_card(Card.new(:clubs, "3"))
    expect(hand1.can_be_split).to be true
    
    hand1 = Hand.new
    hand1.add_card(Card.new(:clubs, "J"))
    hand1.add_card(Card.new(:clubs, "10"))
    expect(hand1.can_be_split).to be true
  end

  it "should not be able to split when it's not a pair" do
    hand1 = Hand.new
    hand1.add_card(Card.new(:clubs, "3"))
    expect(hand1.can_be_split).to be false

    hand1 = Hand.new
    hand1.add_card(Card.new(:clubs, "3"))
    hand1.add_card(Card.new(:clubs, "10"))
    expect(hand1.can_be_split).to be false
  end


  it "should split into two hands when calling split" do
    hand1 = Hand.new
    hand1.add_card(Card.new(:diamonds, "3"))
    hand1.add_card(Card.new(:clubs, "3"))
    hand2, hand3 = hand1.split
    expect(hand2.size).to eq(1)
    expect(hand3.size).to eq(1)
    expect(hand2.cards.at(0).to_s).to eq("D-3")
    expect(hand3.cards.at(0).to_s).to eq("C-3")
  end

  it "should be able to stand when hands <= 21" do
    hand1 = Hand.new
    expect(hand1.stood).to be false
    hand1.stand
    expect(hand1.stood).to be true
  end

  it "should be able to choose to hit when not stood and its hands < 21" do
    hand1 = Hand.new
    deck = Deck.new
    hand1.hit(deck)
    expect(hand1.size).to eq(1)
  end

  it "should be bust when > 21" do 
    hand = Hand.new
    expect(hand.is_bust).to be false
    hand.add_card(Card.new(:clubs, "3"))
    expect(hand.is_bust).to be false
    hand.add_card(Card.new(:clubs, "A"))
    expect(hand.is_bust).to be false
    hand.add_card(Card.new(:diamonds, "A"))
    expect(hand.is_bust).to be false
    hand.add_card(Card.new(:diamonds, "10"))
    expect(hand.is_bust).to be false
    hand.add_card(Card.new(:clubs, "J"))
    expect(hand.is_bust).to be true
  end

end


describe Player do

  it "should have a name" do
    player1 = Player.new("1")
    expect(player1.name).to eq("1")
  end

  it "should have $1000 at the beginning" do
    player1 = Player.new("1")
    expect(player1.chips).to eq(1000)
  end

  it "should be able to make a bet" do
    player1 = Player.new("1")
    deck = Deck.new
    player1.assign_deck(deck)
    player1.make_bet(100)
    expect(player1.hands.size).to eq(1)
    expect(player1.chips).to eq(900)
  end

  it "should have no hand when ready to new game" do
    player = Player.new("1")
    deck = Deck.new
    player.be_ready_to_game
    expect(player.hands.size).to eq(0)
  end

end

# Tests for Dealer
describe Dealer do

  it "should have hand when ready to game" do
    dealer = Dealer.new
    dealer.be_ready_to_game
    expect(dealer.hand).not_to be_nil
  end
  
  it "should must hit when points <= 16" do 
    dealer = Dealer.new
    dealer.hand.add_card(Card.new(:clubs, "10"))
    expect(dealer.must_hit).to be true
    dealer.hand.add_card(Card.new(:clubs, "6"))
    expect(dealer.must_hit).to be true
  end
  
  it "should not hit when points > 16" do 
    dealer = Dealer.new
    dealer.hand.add_card(Card.new(:clubs, "10"))
    dealer.hand.add_card(Card.new(:clubs, "7"))
    expect(dealer.must_hit).to be false
  end
  
  it "should be playing when points > 21" do 
    dealer = Dealer.new
    dealer.hand.add_card(Card.new(:clubs, "10"))
    dealer.hand.add_card(Card.new(:clubs, "6"))
    dealer.hand.add_card(Card.new(:clubs, "7"))
    expect(dealer.must_hit).to be false
  end
  
end


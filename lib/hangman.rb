class Hangman
  attr_reader :guesser, :referee, :board

  def initialize(
      guesser: HumanPlayer.new,
      referee: ComputerPlayer.new,
      board: true
  )
    # come back here to see if there are errors because of option hash
    @guesser = guesser
    @referee = referee
    @board = board

  end

  def setup
    secret = referee.pick_secret_word

  end

end

class HumanPlayer
  def guess_length

  end
end

class ComputerPlayer

  attr_accessor :dictionary

  def initialize(dictionary)
    @dictionary = dictionary
  end

  def pick_secret_word
    File.readlines("lib/dictionary.txt").sample

  end
end


if $0 == __FILE__
  Hangman.new.play
  # ComputerPlayer.new.pick_secret_word
end

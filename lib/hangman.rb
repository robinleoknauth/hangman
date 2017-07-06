class Hangman
  attr_reader :guesser, :referee, :board

  def initialize(
      guesser: HumanPlayer.new,
      referee: ComputerPlayer.new
      # board: true
  )
    @dictionary = File.readlines("lib/dictionary.txt").sample
    @guesser = guesser
    @referee = referee
    @board = board
  end
  # def initialize
  #   @dictionary = File.readlines("lib/dictionary.txt").sample
  #   @guesser = HumanPlayer.new
  #   @referee = ComputerPlayer.new
  #   @board = nil
  # end

  def setup
    secret = @referee.pick_secret_word
    @guesser.register_secret_length(secret)
    @board = [nil] * secret
  end

  def take_turn
    guess = guesser.guess(board)
    position = referee.check_guess(guess)
    update_board(board, guess, position)
    guesser.handle_response(guess, position)
  end

  def update_board(board, guess, position)

  end

  def won?

  end


end

class HumanPlayer
  def guess

  end

  def ff
  end

  def register_secret_length(secret)
    puts "The secret word is #{secret} characters long"

  end

  def handle_response

  end
end

class ComputerPlayer

  attr_accessor :dictionary, :secret, :candidate_words

  def initialize(dictionary)
    @dictionary = dictionary
    @secret = nil
    @candidate_words = dictionary
    @guessed_letters = []
  end

  def pick_secret_word
    @secret = @dictionary.sample
    @secret.length
  end

  def check_guess(letter)
    arr = []
    @secret.chars.each_index { |i| arr << i if @secret[i] == letter }
    arr
  end

  def register_secret_length(length)
    @length = length
    @candidate_words.select! { |word| word if word.length == length }
  end

  def guess(board)
    guessed_letter = letter_count.max_by { |_letter, count| count }[0]
    @guessed_letters << guessed_letter
    guessed_letter
  end

  # def delete_word
  #   @candidate_words.reject! do |word|
  #     word.chars.any? { |letter| @guessed_letters.include?(letter) }
  #   end
  # end

  def letter_count
    count_hash = Hash.new(0)
    @candidate_words.each do |word|
      word.chars.each do |ch|
        count_hash[ch] += 1
      end
    end
    count_hash
  end

  def handle_response(letter, indicies)
    if !indicies.empty?
      @candidate_words.select! do |word|
        word if word.include?(letter)
      end
      indicies.each do |index|
        @candidate_words.reject! do |word|
          word if word[index] != letter
        end
      end
    else
      @candidate_words.reject! do |word|
        word if word.include?(letter)
      end

    end
  end


end


if $0 == __FILE__
  Hangman.new.play
  # ComputerPlayer.new.pick_secret_word
end

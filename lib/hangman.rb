class Hangman
  attr_reader :guesser, :referee, :board

  def initialize(
      guesser: HumanPlayer.new,
      referee: ComputerPlayer.new
  )
    @dictionary = read_file
    @guesser = guesser
    @referee = referee
    @board = board
  end

  def read_file
    File.readlines("lib/dictionary.txt").map(&:chomp)
  end

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
    position.each { |index| board[index] = guess }
  end

  def won?
    @board.none?(&:nil?)
  end

  def play
    setup


    while true
      display = board.map do |el|
        if el.nil?
          " _ "
        else
          el
        end
      end
      p display.join("")
      take_turn
      break if won?
    end

    puts "The word was #{board.join('')}"
  end

end

class HumanPlayer
  def guess(board)
    puts "What letter do you want to guess?"
    gets.chomp.downcase
  end

  def register_secret_length(secret)
    puts "The secret word is #{secret} characters long"

  end

  def handle_response(guess, pos)
    puts "#{guess} at #{pos}"
  end

  def check_guess(letter)

    puts " Your Computer guessed #{letter}"
    puts "If there are any letters like that in your word, where are they?"
    puts "If your word does not include the letter please type []"
    gets.chomp.split(",").map(&:to_i)
  end

  def pick_secret_word
    puts "How long shall your word be?"
    gets.chomp.to_i
  end
end

class ComputerPlayer

  attr_accessor :dictionary, :secret, :candidate_words

  def initialize(dictionary = File.readlines("lib/dictionary.txt").map(&:chomp))
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
    find_indicies(@secret, letter)
  end

  def register_secret_length(length)
    @length = length
    @candidate_words.select! { |word| word if word.length == length }
  end

  def guess(board)
    guessed_letter = letter_count
    guessed_letter.reject! { |letter, _count| board.include?(letter) }
    guessed_letter = guessed_letter.max_by { |_letter, count| count }[0]
    @guessed_letters << guessed_letter
    guessed_letter
  end

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
        find_indicies(word, letter) == indicies
      end

    else
      @candidate_words.reject! do |word|
        word.include?(letter)
      end

    end
  end

  def find_indicies(word, letter)
    arr = []
    word.chars.each_index { |i| arr << i if word[i] == letter }
    arr.sort
  end


end


if $0 == __FILE__
  puts "Do you want to guess?"
  if gets.chomp.downcase.split.first == "y"
    Hangman.new.play

  else
    Hangman.new(guesser: ComputerPlayer.new, referee: HumanPlayer.new).play
  end
end

class HangpersonGame

  # add the necessary class methods, attributes, etc. here
  # to make the tests in spec/hangperson_game_spec.rb pass.

  # Get a word from remote "random word" service

  # def initialize()
  # end
  attr_accessor :word, :guesses, :wrong_guesses
  
  def initialize(word)
    @word = word.downcase
    @guesses = ''
    @wrong_guesses = ''
    @masked_word = '-'*word.length
  end

  def guess(letter)
    if letter == nil || letter.empty? || (/[a-z]/i =~ letter) == nil
      raise ArgumentError
    end
    letter = letter.downcase
    if (@guesses.include? letter) || (@wrong_guesses.include? letter)
      return false
    end

    if !(@word.include? letter)
      @wrong_guesses += letter
      return true
    end

    @guesses += letter
    while (i = @word.index(letter)) != nil 
      @masked_word[i] = letter
      @word[i] = "-"
    end
    return true
  end

  def word_with_guesses()
    @masked_word
  end

  def check_win_or_lose()
    if @wrong_guesses.length >= 7
      return :lose
    elsif @word == "-"*@word.length
      return :win
    else
      return :play
    end
  end

  # You can test it by installing irb via $ gem install irb
  # and then running $ irb -I. -r app.rb
  # And then in the irb: irb(main):001:0> HangpersonGame.get_random_word
  #  => "cooking"   <-- some random word
  def self.get_random_word
    require 'uri'
    require 'net/http'
    uri = URI('http://randomword.saasbook.info/RandomWord')
    Net::HTTP.new('randomword.saasbook.info').start { |http|
      return http.post(uri, "").body
    }
  end

end

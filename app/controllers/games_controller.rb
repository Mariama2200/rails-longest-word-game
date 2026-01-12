require "net/http"
require "json"

class GamesController < ApplicationController
  def new
    @letters = Array.new(10) { ("A".."Z").to_a.sample }
  end

  def score
    @word = params[:word].to_s.strip.upcase
    @letters = params[:letters].to_s.split

    if !in_grid?(@word, @letters)
      @score = 0
      @message = "Sorry, #{@word} can't be built out of #{@letters.join(', ')}."
    elsif !english_word?(@word)
      @score = 0
      @message = "Sorry, #{@word} is not a valid English word."
    else
      @score = @word.length
      @message = "Congratulations! #{@word} is a valid English word. 🎉"
    end
  end

  private

  def in_grid?(word, letters)
    word_chars = word.chars.tally
    grid_chars = letters.tally
    word_chars.all? { |char, count| grid_chars[char].to_i >= count }
  end

  def english_word?(word)
    url = URI("https://wagon-dictionary.herokuapp.com/#{word.downcase}")
    response = Net::HTTP.get(url)
    data = JSON.parse(response)
    data["found"] == true
  rescue
    false
  end
end

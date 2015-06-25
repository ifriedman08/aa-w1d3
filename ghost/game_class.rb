require 'set'
require_relative "computer_player"
require "byebug"

class Game
  attr_reader :dictionary, :players, :fragment

  def initialize(num_players, num_comp)
    words = File.readlines("dictionary.txt").map(&:chomp)
    @dictionary = Set.new
    words.each { |word| @dictionary << word }
    @humans = (1..num_players - num_comp).map { |num| Player.new("Player #{num}") }
    @computers =  (num_players - num_comp + 1..num_players).map { |num| ComputerPlayer.new("A.I #{num}") }
    @players = @humans.concat(@computers)
    @fragment = ""

  end

  def play
    until players.length == 1
      play_round
      next_player! unless current_player.lost?
      delete_player!(current_player) if current_player.lost?
    end
    puts "The winner is #{current_player.name}!"
  end

  def play_round
    display_standings
    @fragment = ""
    player_turn until !valid_play?
    display_round_result
    previous_player.lose_life
  end

  def display_standings
    @players.select! { |player| !player.lost?}
    puts "The current standings are:"
    @players.each { |player| puts "#{player.name}: #{player.lives}" }
  end

  def display_fragment
    puts "The current fragment is '#{fragment}'"
  end

  def display_round_result
    if dictionary.any? { |word| word == fragment }
      puts "#{previous_player.name} has spelled out a real word"
    else
      puts "#{previous_player.name} has selected an invalid letter"
    end
    puts "#{previous_player.name} has lost a life"
  end

  def valid_play?
    dictionary.any? { |word| word.include?(fragment) } &&
      dictionary.all? { |word| word != fragment }
  end

  def player_turn
    display_fragment
    unless current_player.is_a?(ComputerPlayer)
      place_letter(*prompt(current_player))
    else
      letter = current_player.guess(@fragment, @players.length)
      place_letter(letter)
      puts "#{current_player.name} chose #{letter}"
    end
    next_player!
  end

  def current_player
    players[0]
  end

  def previous_player
    players[-1]
  end

  def next_player!
    @players.rotate!
  end

  def delete_player!(player)
    puts "#{player.name} has lost all their lives and can no longer play"
    @players.delete(player)
  end

  def prompt(player)
    letter, pos = player.guess
  end

  def place_letter(letter, pos = "back")
    pos == "back" ? @fragment << letter : @fragment = letter + @fragment
  end
end


if __FILE__ == $PROGRAM_NAME
  num_players = ARGV.shift.to_i
  num_comp = ARGV.shift.to_i
  game = Game.new(num_players, num_comp)
  game.play
end

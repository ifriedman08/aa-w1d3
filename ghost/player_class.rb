class Player
  attr_reader :name, :lives

  def initialize(name)
    @name = name
    @lives = ""
  end

  def guess
    puts "#{name}, guess a single letter and position, front or back (ex: d front) "
    gets.chomp.split
  end

  def lose_life
    @lives << "GHOST"[lives.length]
  end

  def lost?
    lives == "GHOST"
  end
end

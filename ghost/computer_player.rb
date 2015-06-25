require_relative "player_class"

class ComputerPlayer < Player

  def initialize(name)
    super(name)
    words = File.readlines("dictionary.txt").map(&:chomp)
    @dictionary = Set.new
    words.each { |word| @dictionary << word }
  end

  def guess(fragment, num_players)
    fits = @dictionary.select { |word| word.start_with?(fragment) }
    fits.select! { |word| (word.length - fragment.length) % num_players != 0 }
    if fits.length > 0
      p fits.sample[fragment.length]
    else
      p ("a".."z").to_a.sample
    end
  end
end

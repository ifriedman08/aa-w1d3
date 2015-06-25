require "byebug"
require "set"

class Keypad

  attr_reader :code_bank, :possible_comb, :keys, :num_possible_combs, :key_history

  def initialize(code_length, mode_keys)
    @keys = (0..9).to_a.map(&:to_s)
    @code_length = code_length
    @mode_keys = mode_keys
    @key_history = Set.new
    @code_bank = Hash.new(0)
    @num_possible_combs = keys.length ** code_length
  end

  def press(key)
    @key_history << key
  end

  def check_history
    @key_history.each_with_index do |key, ind|
      if ind >= @code_length && @mode_keys.include?(key)
        @code_bank[@key_history[ind - @code_length...ind].join] += 1
        # @code_bank[@key_history[ind - @code_length...ind].reverse.join] += 1
      end
    end
  end

  def all_codes_entered?
      @code_bank.keys.length == num_possible_combs
  end
end

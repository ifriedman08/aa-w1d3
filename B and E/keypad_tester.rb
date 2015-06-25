require_relative 'keypad_class'
require "byebug"

class KeypadTester
  attr_reader :possible_combs, :keypad, :length, :mode_keys, :press_count

  def initialize(length, mode_keys)
    @keypad = Keypad.new(length, mode_keys)
    @length = length
    @mode_keys = mode_keys
    @possible_combs = []
    @press_count = 0

    max = ("9"*@length).to_i
    (0..max).each do |num|
      comb = num.to_s
      @possible_combs << "0"*(@length - comb.length) + comb
    end
  end

  def run
    until keypad.all_codes_entered?
      possible_combs.each do |comb|
        # next if @possible_combs.include?(comb.reverse.join)
        comb.split("").each do |digit|
          if @keypad.code_bank[comb] == 0
            keypad.press(digit)
            @press_count += 1
          end
        end
        @keypad.code_bank[comb] += 1
      end
      keypad.press("#{mode_keys[0]}")
      @press_count += 1
    end

    puts "History: #{keypad.key_history.map(&:to_s)}"
    puts "Code bank length: #{keypad.code_bank.keys.length}"
    puts "Number possible: #{possible_combs.length}"
    puts "Key presses: #{press_count}"
  end
end

kt= KeypadTester.new(4, ["1", "2", "3"])
kt.run

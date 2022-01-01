#!/usr/bin/env ruby

require "pry"

# input = File.open("day8/example.txt").read.split("\n")
input = File.open("day8/input.txt").read.split("\n")

class Entry
  attr_reader :unique_patterns, :output, :pattern_mapping, :wire_mapping

  def initialize(string)
    unique_patterns, output = string.split(" | ")
    @unique_patterns = unique_patterns.split(" ")
    @output = output.split(" ")
    @pattern_mapping = {}
    @wire_mapping = {}
  end

  def basic_decode
    output.map do |connections|
      case connections.size
      when 2 then "1"
      when 4 then "4"
      when 3 then "7"
      when 7 then "8"
      else
        "?"
      end
    end
  end

  def decode!
    two_three_or_five = []
    zero_six_or_nine = []
    number_one = nil

    unique_patterns.each do |pattern|
      case pattern.size
      when 2
        add_pattern_coding(pattern, 1)
        number_one = sort_pattern(pattern)
      when 3
        add_pattern_coding(pattern, 7)
      when 4
        add_pattern_coding(pattern, 4)
      when 5
        two_three_or_five << sort_pattern(pattern)
      when 6
        zero_six_or_nine << sort_pattern(pattern)
      when 7
        add_pattern_coding(pattern, 8)
      end
    end

    # 2 and 5 share 4 differences, while all other combos share 2
    a = two_three_or_five[0]
    b = two_three_or_five[1]
    c = two_three_or_five[2]
    if pattern_difference(a, b) == 4
      add_pattern_coding(c, 3)
    elsif pattern_difference(b, c) == 4
      add_pattern_coding(a, 3)
    elsif pattern_difference(a, c) == 4
      add_pattern_coding(b, 3)
    end
    two_or_five = two_three_or_five.reject{ |pattern| pattern == pattern_mapping.key(3) }

    # 6 does not contain 1
    number_six = zero_six_or_nine.select do |pattern|
      (number_one.split("") - pattern.split("")).any?
    end.first
    add_pattern_coding(number_six, 6)
    zero_or_nine = zero_six_or_nine.reject{ |pattern| pattern == number_six }

    # Wire c is 8 - 6
    @wire_mapping["c"] = (pattern_mapping.key(8).split("") - pattern_mapping.key(6).split("")).first
    
    # 2 has wire c and 5 does not
    two = two_or_five.select { |pattern| pattern.split("").include?(wire_mapping["c"]) }.first
    add_pattern_coding(two, 2)
    add_pattern_coding(two_or_five.reject{ |pattern| pattern == two }.first, 5)

    # Wire e is 6 - 5
    @wire_mapping["e"] = (pattern_mapping.key(6).split("") - pattern_mapping.key(5).split("")).first

    # 0 has wire e and 9 does not
    zero = zero_or_nine.select { |pattern| pattern.split("").include?(wire_mapping["e"]) }.first
    add_pattern_coding(zero, 0)
    add_pattern_coding(zero_or_nine.reject{ |pattern| pattern == zero }.first, 9)
  end

  def decoded_output
    output.map do |pattern|
      @pattern_mapping[pattern.split("").sort.join("")]
    end
  end

  def possible_coding
    # coding =  Hash.new { |h, k| h[k] = [] }
    coding =  {}
    unique_patterns.each do |pattern|
      case pattern.size
      when 2 then
        coding[pattern] = 1
      when 3 then
        coding[pattern] = 7
      when 4 then
        coding[pattern] = 4
      when 5 then
        coding[pattern] = [2, 3, 5]
      when 6 then
        coding[pattern] = [0, 6, 9]
      when 7 then
        coding[pattern] = 8
      end
    end
    coding
  end

  private

  def add_pattern_coding(pattern, number)
    if @pattern_mapping[pattern.split("").sort.join("")] != nil
      puts @pattern_mapping
      raise "Already has #{pattern.split("").sort.join("")} for pattern! Trying to set to #{number}"
    end
    @pattern_mapping[pattern.split("").sort.join("")] = number
  end

  def pattern_difference(a, b)
    a = a.split("")
    b = b.split("")
    (a - b | b - a).size
  end

  def sort_pattern(pattern)
    pattern.split("").sort.join("")
  end

  def zero
    ["a", "b", "c", "e", "f", "g"]
  end

  def one_pattern
    ["c", "f"]
  end

  def two
    ["a", "c", "d", "e", "g"]
  end

  def three
    ["a", "c", "d", "f", "g"]
  end

  def four_pattern
    ["b", "c", "d", "f"]
  end

  def five
    ["a", "b", "d", "f", "g"]
  end

  def six
    ["a", "b", "d", "e", "f", "g"]
  end

  def seven_pattern
    ["a", "c", "f"]
  end

  def eight
    ["a", "b", "c", "d", "e", "f", "g"]
  end

  def nine
    ["a", "b", "c", "d", "f", "g"]
  end
end

entries = input.map do |values|
  Entry.new(values)
end

# Part 1

# decoded = 0
# entries.each do |entry|
#   basic = entry.basic_decode
#   decoded += basic.reject{ |value| value == "?" }.size
#   puts basic.join(", ")
# end
# puts "\nDecoded #{decoded}"

# Part 2

# entry = Entry.new("acedgfb cdfbe gcdfa fbcad dab cefabd cdfgeb eafb cagedb ab | cdfeb fcadb cdfeb cdbaf")
# entry.decode!
# entry.pattern_mapping.each do |k,v|
#   puts "#{k}: #{Array(v).join(", ")}"
# end
# puts entry.decoded_output.join("")

total = 0
entries.each do |entry|
  entry.decode!
  total += entry.decoded_output.join("").to_i
  puts "#{entry.output.join(" ")}: #{entry.decoded_output.join("")}"
end
puts "Total: #{total}"

#!/usr/bin/env ruby

require "pry"

input = File.open("day8/example.txt").read.split("\n")
# input = File.open("day8/input.txt").read.split("\n")

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
        pattern_mapping[pattern] = 1
        number_one = pattern
      when 3
        pattern_mapping[pattern] = 7
      when 4
        pattern_mapping[pattern] = 4
      when 5
        two_three_or_five << pattern
        # pattern_mapping[pattern] = [2, 3, 5]
      when 6
        zero_six_or_nine << pattern
        # pattern_mapping[pattern] = [0, 6, 9]
      when 7
        pattern_mapping[pattern] = 8
      end
    end

    # 2 and 5 share 4 differences, while all other combos share 2
    a = two_three_or_five[0]
    b = two_three_or_five[1]
    c = two_three_or_five[2]
    if pattern_difference(a, b) == 4
      pattern_mapping[c] = 3
    elsif pattern_difference(b, c) == 4
      pattern_mapping[a] = 3
    elsif pattern_difference(a, c) == 4
      pattern_mapping[b] = 3
    end

    # 6 does not contain 1
    number_six = zero_six_or_nine.select do |pattern|
      (number_one.split("") - pattern.split("")).any?
    end.first
    pattern_mapping[number_six] = 6
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

  def possible_mappings
    mappings = Hash.new { |h, k| h[k] = [] }
    unique_patterns.each do |wires|
      case wires.size
      when 2 then
        mappings[wires[0]] << one_pattern
        mappings[wires[1]] << one_pattern
      when 3 then
        mappings[wires[0]] << seven_pattern
        mappings[wires[1]] << seven_pattern
        mappings[wires[2]] << seven_pattern
      when 4 then
        mappings[wires[0]] << four_pattern
        mappings[wires[1]] << four_pattern
        mappings[wires[2]] << four_pattern
        mappings[wires[3]] << four_pattern
      when 5 then
        (0..4).each do |i|
          mappings[wires[i]] << two
          mappings[wires[i]] << three
          mappings[wires[i]] << five
        end
      when 6 then
        (0..4).each do |i|
          mappings[wires[i]] << zero
          mappings[wires[i]] << six
          mappings[wires[i]] << nine
        end
      when 7 then
        mappings[wires[0]] << eight
        mappings[wires[1]] << eight
        mappings[wires[2]] << eight
        mappings[wires[3]] << eight
        mappings[wires[4]] << eight
        mappings[wires[5]] << eight
        mappings[wires[6]] << eight
      end
    end
    mappings
  end

  private

  def pattern_difference(a, b)
    a = a.split("")
    b = b.split("")
    (a - b | b - a).size
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

entry = Entry.new("acedgfb cdfbe gcdfa fbcad dab cefabd cdfgeb eafb cagedb ab | cdfeb fcadb cdfeb cdbaf")
entry.decode!
entry.pattern_mapping.each do |k,v|
  puts "#{k}: #{Array(v).join(", ")}"
end


# entry.possible_mappings.each do |k,v|
#   puts "#{k} -> #{v.map{ |array| array.join(", ") }.join(" | ")}"
# end
# puts "\n"

# possible_mappings = entry.possible_mappings.map { |k,v| [k, v.inject(&:&)] }.to_h
# possible_mappings.sort.each do |k,v|
#   puts "#{k} -> #{v.join(", ")}"
# end

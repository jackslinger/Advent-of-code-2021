#!/usr/bin/env ruby

require "pry"

# input = File.open("day7/example.txt").read.split(",").map(&:to_i)
input = File.open("day7/input.txt").read.split(",").map(&:to_i)

def mean(array)
  array = array.inject(0) { |sum, x| sum += x } / array.size.to_f
end

def median(array)
  sorted = array.sort
  half_len = (sorted.length / 2.0).ceil
  (sorted[half_len-1] + sorted[-half_len]) / 2.0
end

def fuel_for_position(input, position)
  input.map do |start|
    (start - position).abs
  end.inject(&:+)
end

puts "Mean: #{mean(input)}, median: #{median(input)}"

puts "\nPart 1"
position = median(input).floor
puts "Fuel for position #{position}: #{fuel_for_position(input, position)}"

puts "\nPart 2"

def fuel_for_position(input, position)
  input.map do |start|
    n = (start - position).abs
    (n * (n + 1)) / 2
  end.inject(&:+)
end

position = mean(input).round
puts "Fuel for position #{position}: #{fuel_for_position(input, position)}"
puts "Fuel for position #{469}: #{fuel_for_position(input, 469)}"
puts "Fuel for position #{470}: #{fuel_for_position(input, 470)}"
puts "Fuel for position #{471}: #{fuel_for_position(input, 471)}"
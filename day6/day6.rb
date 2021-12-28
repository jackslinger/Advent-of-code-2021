#!/usr/bin/env ruby

require "pry"

# input = File.open("day6/example.txt").read
input = File.open("day6/input.txt").read

class School
  def initialize(input)
    @fish_array = input.split(",").map(&:to_i)
    @fish_hash = Hash.new(0)
    @fish_array.each do |fish|
      @fish_hash[fish] += 1
    end
  end

  # def cycle
  #   new_fish = []
  #   new_borns = 0
    
  #   new_fish = @fish_array.map do |fish|
  #     if fish > 0
  #       fish - 1
  #     else
  #       new_borns += 1
  #       6
  #     end
  #   end
  #   new_fish += (1..new_borns).map { 8 }
  #   @fish_array = new_fish
  # end
  
  def cycle
    new_hash = Hash.new(0)

    new_hash[0] = @fish_hash[1]
    new_hash[1] = @fish_hash[2]
    new_hash[2] = @fish_hash[3]
    new_hash[3] = @fish_hash[4]
    new_hash[4] = @fish_hash[5]
    new_hash[5] = @fish_hash[6]
    
    new_hash[6] = @fish_hash[7] + @fish_hash[0]
    
    new_hash[7] = @fish_hash[8]

    new_hash[8] = @fish_hash[0]

    @fish_hash = new_hash
  end

  def size
    # @fish_array.size
    @fish_hash.values.inject(&:+)
  end
end

# puts "Initial state: #{input.join(",")}"
school = School.new(input)
# (1..18).each do |i|
#   fish = cycle(fish)
#   puts "After #{i} day(s): #{fish.join(",")}"
# end

num_of_cycles = 256
(1..num_of_cycles).each do |i|
  school.cycle
end
puts "Total fish after #{num_of_cycles} days: #{school.size}"
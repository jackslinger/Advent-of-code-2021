#!/usr/bin/env ruby

require "pry"

# input = File.open("day9/example.txt").read
input = File.open("day9/input.txt").read

class OceanFloor

  def initialize(input)
    @rows = input.split("\n").map { |row| row.chomp.split("").map(&:to_i) }
    @height = @rows.size
    @width = @rows[0].size
  end

  def display
    @rows.map do |row|
      row.join("")
    end.join("\n")
  end

  def low_points
    points = []
    @rows.each_with_index do |row, y|
      row.each_with_index do |cell, x|
        if adjacent(x, y).all? { |value| cell < value }
          points << cell
        end
      end
    end
    points
  end

  def risk_level
    low_points.map{ |value| value + 1 }.inject(&:+)
  end

  private

  def adjacent(x, y)
    neigbours = []

    if x == 0
      neigbours << @rows[y][x+1]
    elsif x == @width - 1
      neigbours << @rows[y][x-1]
    else
      neigbours << @rows[y][x+1]
      neigbours << @rows[y][x-1]
    end
    
    if y == 0
      neigbours << @rows[y+1][x]
    elsif y == @height - 1
      neigbours << @rows[y-1][x]
    else
      neigbours << @rows[y+1][x]
      neigbours << @rows[y-1][x]
    end
  end
end

ocean_floor = OceanFloor.new(input)
puts ocean_floor.display
puts "\nLow points: #{ocean_floor.low_points}"
puts "Risk level: #{ocean_floor.risk_level}"
#!/usr/bin/env ruby

require "pry"

# file = File.open("day5/example.txt").read.split("\n")
file = File.open("day5/input.txt").read.split("\n")

Point = Struct.new(:x, :y)

class Line
  attr_reader :x1, :y1, :x2, :y2

  def initialize(input_string)
    one, two = input_string.split(" -> ")
    @x1, @y1 = one.split(",").map(&:to_i)
    @x2, @y2 = two.split(",").map(&:to_i)
  end

  def cells
    if vertical?
      (min_y...(max_y + 1)).map do |y|
        Point.new(x1, y)
      end
    elsif horizontal?
      (min_x...(max_x + 1)).map do |x|
        Point.new(x, y1)
      end
    else
      x_coords = if x1 < x2
        (x1..x2).to_a
      else
        (x2..x1).to_a.reverse
      end
      y_coords = if y1 < y2
        (y1..y2).to_a
      else
        (y2..y1).to_a.reverse
      end

      x_coords.zip(y_coords).map do |x, y|
        Point.new(x, y)
      end
    end
  end

  def orthogonal?
    vertical? || horizontal?
  end

  def vertical?
    x1 == x2
  end

  def horizontal?
    y1 == y2
  end

  def inspect
    "X1: #{x1} Y1: #{y1}, X2: #{x2} Y2: #{y2}"
  end

  def max_x
    x1 > x2 ? x1 : x2
  end
  
  def min_x
    x1 > x2 ? x2 : x1
  end

  def max_y
    y1 > y2 ? y1 : y2
  end
  
  def min_y
    y1 > y2 ? y2 : y1
  end
end

class Grid
  attr_reader :width, :height, :lines

  def initialize(lines, diagonals = false)
    @lines = lines
    @width = lines.map(&:max_x).max + 1
    @height = lines.map(&:max_y).max + 1
    @diagonals = diagonals
  end

  def numbers
    @numbers = (0...height).map do |row|
      (0...width).map do |col|
        0
      end
    end

    lines.each do |line|
      if line.orthogonal? || @diagonals == true
        line.cells.each do |point|
          @numbers[point.y][point.x] += 1
        end
      end
    end
    @numbers
  end

  def num_of_overlaps
    overlaps = 0
    numbers.each do |row|
      row.each do |cell|
        overlaps += 1 if cell > 1
      end
    end
    overlaps
  end

  def to_s
    numbers.map{ |row| row.join("").gsub("0", ".") }.join("\n")
  end
end

lines = file.map do |line|
  Line.new(line)
end
grid = Grid.new(lines)

puts "Part 1"
puts "Overlaps: #{grid.num_of_overlaps}"

puts "\nPart 2"
grid = Grid.new(lines, true)
puts "Overlaps: #{grid.num_of_overlaps}"
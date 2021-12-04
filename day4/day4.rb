#!/usr/bin/env ruby

# NOTE: This need to be run in the terminal not with the short cut to get librarys to work.
require 'colorize'

# file = File.open("day4/example.txt").read.split("\n")
file = File.open("day4/input.txt").read.split("\n")

called_numbers = file[0].split(",").map(&:to_i)

class String
  def bold
    "\e[1m#{self}\e[22m"
  end
end

class BingoBoard
  attr_reader :grid, :marked

  def initialize(rows)
    @grid = rows.map do |row|
      row.split(/\s+/).reject{|v| v == ""}.map(&:to_i)
    end
    @marked = (0...5).map { |i| (0...5).map { |j| false } }
  end

  def display
    output = grid.each_with_index.map do |row, i|
      row.each_with_index.map do |number, j|
        if @marked[i][j]
          number.to_s.rjust(2).bold
        else
          number.to_s.rjust(2)
        end
      end.join(" ")
    end
    puts output
  end

  def mark(number)
    if grid.size > 5
      puts grid.map{ |row| row.join(", ") }
    end

    grid.each_with_index do |row, i|
      row.each_with_index do |cell, j|
        # puts "#{i}, #{j}, #{marked[i]}" if @marked[i].nil?
        if cell == number
          @marked[i][j] = true
        end
      end
    end
  end

  def won?
    # horizontal
    horizontal = marked.any? { |row| row.all? }

    # vertical
    vertical = (0...5).any? do |j|
      (0...5).all? do |i|
        marked[i][j]
      end
    end

    horizontal || vertical
  end

  def sum_of_unmarked
    grid.each_with_index.map do |row, i|
      row.each_with_index.map do |cell, j|
        marked[i][j] ? nil : cell
      end
    end.flatten.compact.inject(&:+)
  end
end

boards = []
(0...file[1..-1].size / 6).each do |i|
  slice = file[1..-1][(i * 6 + 1),5]
  boards << BingoBoard.new(slice)
end

winning_board_index = nil
number_index = 0
while winning_board_index.nil?
  next_number = called_numbers[number_index]
  # puts "Calling #{next_number}"

  boards.each_with_index do |board, i|
    board.mark(next_number)
    winning_board_index = i if board.won?
  end

  number_index += 1

  if number_index >= called_numbers.size
    winning_board_index = false
    puts "Couldn't find a winner!"
  end
end

winning_board = boards[winning_board_index]

puts "Winning board: #{winning_board_index}"
puts "Winning number: #{next_number}"
puts "Sum of unmarked: #{winning_board.sum_of_unmarked}"
puts "Final score: #{winning_board.sum_of_unmarked * next_number}"
puts "\n---"
winning_board.display

puts "\nPart 2"

winning_boards = []
number_index = 0
loosing_board_index = nil
while winning_boards.size != boards.size
  next_number = called_numbers[number_index]
  # puts "Calling #{next_number}"

  (boards - winning_boards).each_with_index do |board, i|
    board.mark(next_number)
    if board.won?
      winning_boards << board 
      loosing_board_index = i if winning_boards.size == boards.size
    end
  end

  number_index += 1
end

loosing_board = winning_boards.last

puts "Loosing board: #{loosing_board_index}"
puts "Loosing number: #{next_number}"
puts "Sum of unmarked: #{loosing_board.sum_of_unmarked}"
puts "Final score: #{loosing_board.sum_of_unmarked * next_number}"
puts "\n---"
loosing_board.display

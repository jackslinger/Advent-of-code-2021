input = File.open("day1/input.txt").read.split().map(&:to_i)
# input = File.open("day1/example.txt").read.split().map(&:to_i)

def number_of_increases(input)
  increases = 0
  previous_value = input[0]
  input[1..-1].each do |value|
    increases += 1 if value > previous_value
    previous_value = value
  end
  return increases
end

puts "Part 1 increases: #{number_of_increases(input)}"

sliding_window_sums = input.each_cons(3).map{ |window| window.reduce(&:+) }
puts "Part 2 increases: #{number_of_increases(sliding_window_sums)}"


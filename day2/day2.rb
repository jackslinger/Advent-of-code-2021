input = File.open("day2/input.txt").read.split("\n")
# input = File.open("day2/example.txt").read.split("\n")

puts "Part 1"

horizontal = 0
depth = 0

input.each do |full|
  command, amount = full.split()
  amount = amount.to_i
  case command
  when "forward" then horizontal += amount
  when "down" then depth += amount
  when "up" then depth -= amount
  end
end

puts "Horizontal: #{horizontal}, Depth: #{depth}, Product: #{horizontal * depth}"


puts "Part 2"

horizontal = 0
depth = 0
aim = 0

input.each do |full|
  command, amount = full.split()
  amount = amount.to_i
  case command
  when "forward"
    horizontal += amount
    depth += amount * aim
  when "down" then aim += amount
  when "up" then aim -= amount
  end
end

puts "Horizontal: #{horizontal}, Depth: #{depth}, Product: #{horizontal * depth}"
# input = File.open("day3/example.txt").read.split("\n")
input = File.open("day3/input.txt").read.split("\n")

puts "Part 1:"

def frequency(array)
  p = Hash.new(0); array.each{ |v| p[v] += 1 }; p
end

def compute_gamma_and_epsilon(values)
  gamma = ""
  epsilon = ""
  (0...values[0].size).each do |i|
    digits = values.map { |binary| binary[i] }

    frequency_map = frequency(digits)
    if frequency_map["1"] == frequency_map["0"]
      gamma << "1"
      epsilon << "0"
    else
      gamma << frequency_map.max_by{|k,v| v}[0]
      epsilon << frequency_map.min_by{|k,v| v}[0]
    end
  end
  [gamma, epsilon]
end

gamma_rate, epsilon_rate = compute_gamma_and_epsilon(input)

puts "Gama rate - Binary: #{gamma_rate}, decimal: #{gamma_rate.to_i(2)}"
puts "Epsilon rate - Binary: #{epsilon_rate}, decimal: #{epsilon_rate.to_i(2)}"
puts "Product #{gamma_rate.to_i(2) * epsilon_rate.to_i(2)}"

puts "Part 2:"

length = input[0].size

possible_oxygen = input
(0...length).each do |i|
  next if possible_oxygen.size < 2
  gamma, _ = compute_gamma_and_epsilon(possible_oxygen)
  possible_oxygen = possible_oxygen.select { |binary| binary[i] == gamma[i] }
end

possible_co2 = input
(0...length).each do |i|
  next if possible_co2.size < 2
  _, epsilon = compute_gamma_and_epsilon(possible_co2)
  possible_co2 = possible_co2.select { |binary| binary[i] == epsilon[i] }
end

puts "Oxygen - Binary: #{possible_oxygen[0]}, decimal: #{possible_oxygen[0].to_i(2)}"
puts "C02 - Binary: #{possible_co2[0]}, decimal: #{possible_co2[0].to_i(2)}"
puts "Product #{possible_oxygen[0].to_i(2) * possible_co2[0].to_i(2)}"
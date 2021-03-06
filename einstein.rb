#!/usr/bin/env ruby

# Sean Handley, 2015
# seanhandley.com
#
# This is the fast version that cuts the problem space down
# as it works through it. Typically runs in under a second.
#

@colors        = [:white, :yellow, :blue, :red, :green].shuffle.permutation
@cigars        = [:blends, :pall_mall, :prince, :bluemasters, :dunhill].shuffle.permutation
@nationalities = [:german, :swedish, :british, :norwegian, :danish,].shuffle.permutation
@drinks        = [:beer, :water, :tea, :milk, :coffee].shuffle.permutation
@pets          = [:birds, :cats, :horses, :fish, :dogs].shuffle.permutation

def left_of?(set_a, val_a, set_b, val_b)
  (0..4).any? do |i| # da 5 Auswahlmöglichkeiten
    set_a[i]   == val_a &&
    set_b[i+1] == val_b
  end
end

def next_to?(set_a, val_a, set_b, val_b)
  left_of?(set_a, val_a, set_b, val_b) ||
  left_of?(set_b, val_b, set_a, val_a)
end

def implies?(set_a, val_a, set_b, val_b)
  (0..4).any? do |i| # da 5 Auswahlmöglichkeiten
    set_a[i] == val_a &&
    set_b[i] == val_b
  end
end

def solve
  i = 0
  @colors.each do |colors|
    i += 1
    next unless left_of?(colors, :green, colors, :white)
    @nationalities.each do |nationalities|
      i += 1
      next unless implies?(nationalities, :british, colors, :red)
      next unless nationalities[0] == :norwegian
      next unless next_to?(nationalities, :norwegian, colors, :blue)
      @pets.each do |pets|
        i += 1
        next unless implies?(nationalities, :swedish, pets, :dogs)
        @drinks.each do |drinks|
          i += 1
          next unless drinks[2] == :milk
          next unless implies?(colors, :green, drinks, :coffee)
          next unless implies?(nationalities, :danish, drinks, :tea)
          @cigars.each do |cigars|
            i += 1
            next unless next_to?(pets, :horses, cigars, :dunhill)
            next unless implies?(cigars, :pall_mall, pets, :birds)
            next unless next_to?(cigars, :blends, drinks, :water)
            next unless next_to?(cigars, :blends, pets, :cats)
            next unless implies?(nationalities , :german, cigars, :prince)
            next unless implies?(colors, :yellow, cigars, :dunhill)
            next unless implies?(cigars, :bluemasters,  drinks, :beer)
            return [colors, nationalities, pets, drinks, cigars], i
          end
        end
      end
    end
  end
end

class Symbol
  def humanize
    result = self.to_s
    result.gsub!('_', ' ')
    result.split(' ').collect{|part| part.capitalize }.join(' ')
  end
end

solution, attempts = solve

puts "\nSolved in #{attempts} attempts.\n\n"

for i in (0..4)
  number, color, nationality, cigar, drink, pet = i+1, solution[0][i], solution[1][i].humanize, solution[4][i].humanize, solution[3][i], solution[2][i]
  puts "House #{number} is #{color}. The owner is #{nationality}, smokes #{cigar}, drinks #{drink}, and keeps #{pet}."
end

puts "\n"

#!/usr/bin/ruby -w
# encoding: utf-8

# a morse(6) clone: convert text to Morse code.

module Morse

  STOP = "...-.-"

  ALNUM = {
    '0' => "-----",
    '1' => ".----",
    '2' =>  "..---",
    '3' => "...--",
    '4' => "....-",
    '5' => ".....",
    '6' => "-....",
    '7' => "--...",
    '8' => "---..",
    '9' => "----.",
    'A' => ".-",
    'B' => "-...",
    'C' => "-.-.",
    'D' => "-..",
    'E' => ".",
    'F' => "..-.",
    'G' => "--.",
    'H' => "....",
    'I' => "..",
    'J' => ".---",
    'K' => "-.-",
    'L' => ".-..",
    'M' => "--",
    'N' => "-.",
    'O' => "---",
    'P' => ".--.",
    'Q' => "--.-",
    'R' => ".-.",
    'S' => "...",
    'T' => "-",
    'U' => "..-",
    'V' => "...-",
    'W' => ".--",
    'X' => "-..-",
    'Y' => "-.--",
    'Z' => "--.."
  }

  def self.punct(p)
    case p
      when "." then ".-.-.-"
      when "," then "--..--"
      when ":" then "---..."
      when "?" then "..--.."
      when "\'" then ".----."
      when "-" then "-....-"
      when "/" then "-..-."
      when "(" then "-.--."
      when ")" then "-.--.-"
      when "=" then "-...-"
      when "\"" then ".-..-."
      when "+" then ".-.-."
    end
  end

  def self.encode(str)
    0.upto(str.length-1) do |i|
      if str[i] =~ /[[:punct:]]/
        puts punct(str[i])
      elsif str[i] =~ /[[:alnum:]]/
        puts ALNUM[str[i].upcase]
      else
        puts
      end
    end
  end

end # End of Morse module

if ARGV.length > 0
  Morse::encode(ARGV.join(" "))
else
  while str = gets
    Morse::encode(str.chomp)
    puts
  end
end

puts Morse::STOP

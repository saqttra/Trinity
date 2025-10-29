# Copyright (C) 2025, Saqttra. All rights reserved.

# This file is part of Saqttra Trinity.

# This source code is licensed under the MIT license
# found in the LICENSE file in the root directory.

# <https://github.com/saqttra/Trinity>.

# frozen_string_literal: true

require 'io/console'

RUNES = (32..126).map(&:chr).freeze

# #56d364; #2ea043, #196c2e; #033a16; #151b23 (green palette)
COLOR_STEPS = [235, 22, 28, 34, 83].freeze

rows, cols = IO.console.winsize
winsize_changed = false

streams = Array.new(cols) do
  { y: rand(-rows..rows), len: rand(2..(rows / 2)) }
end

trap('INT') do
  puts "\nReceived SIGINT signal"
  print "\e[?25h"
  exit
end

trap('WINCH') do
  rows, cols = IO.console.winsize
  winsize_changed = true
end

system 'clear'
print "\e[?25l"

loop do
  rows.times do |row|
    if winsize_changed
      winsize_changed = false
      break
    end

    line = Array.new(cols, ' ')

    cols.times do |col|
      stream = streams[col]
      tail = stream[:y] - stream[:len]
      head = stream[:y]

      # in field of view?
      if (tail..head).include?(row)
        depth = head - row
        ratio = depth.to_f / stream[:len]
        index = (ratio * (COLOR_STEPS.length - 1)).round
        color_code = COLOR_STEPS[index.clamp(0, COLOR_STEPS.length - 1)]

        rune = RUNES.sample
        line[col] = "\e[38;5;#{color_code}m#{rune}\e[0m"
      end
    end

    3.times do
      print "\r"
      line.each do |rune|
        if rune == ' '
          print ' '
        else
          print RUNES.sample
        end
      end
      sleep 0.015
    end

    print "\r"
    puts line.join

    streams.each do |stream|
      stream[:y] += 1

      # did it reach end of y-axis?
      stream[:y] += 1
      if stream[:y] - stream[:len] > rows
        stream[:y] = rand(-rows..0)
        stream[:len] = rand(5..(rows / 2))
      end
    end
    sleep 0.095
  end
  system 'clear'
end

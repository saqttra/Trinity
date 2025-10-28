# Copyright (C) 2025, Saqttra. All rights reserved.

# This file is part of Saqttra Trinity.

# This source code is licensed under the MIT license
# found in the LICENSE file in the root directory.

# <https://github.com/saqttra/Trinity>.

# frozen_string_literal: true

require 'io/console'

rows, = IO.console.winsize
winsize_changed = false

trap('INT') do
  puts "\nReceived SIGINT signal"
  exit
end

trap('WINCH') do
  rows, = IO.console.winsize
  winsize_changed = true
end

system 'clear'

loop do
  i = 1
  while i < rows
    if winsize_changed
      winsize_changed = false
      break
    end

    puts "Working... #{i} with row size: #{rows}"
    sleep 0.5
    i += 1
  end
  system 'clear'
end

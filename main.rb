# Copyright (C) 2025, Saqttra. All rights reserved.

# This file is part of Saqttra Trinity.

# This source code is licensed under the MIT license
# found in the LICENSE file in the root directory.

# <https://github.com/saqttra/Trinity>.

# frozen_string_literal: true

# TODO: colors:
# #56d364
# #2ea043
# #196c2e
# #033a16
# #151b23

require 'io/console'

RUNES = (32..126).map(&:chr).freeze

rows, cols = IO.console.winsize
winsize_changed = false

trap('INT') do
  puts "\nReceived SIGINT signal"
  exit
end

trap('WINCH') do
  rows, cols = IO.console.winsize
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

    puts Array.new(cols) { RUNES.sample }.join
    sleep 0.5
    i += 1
  end
  system 'clear'
end

#!/usr/bin/env ruby
  
gems = [
  ["sinatra", nil],
  ["maruku", nil],
  ["couchrest", nil],
  ["json", nil],
  ["haml", nil]
]
gems.each do |gem_line|
  if gem_line[1] == nil
    system  "sudo gem install #{gem_line[0]}"
  else
    system  "sudo gem install #{gem_line[0]} --version #{gem_line[1]}"
  end
end
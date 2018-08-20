require_relative './time_range.rb'
require_relative './time_subtractor.rb'

new_range = TimeSubtractor.subtract(
  [{"start" => Time.parse("09:00"), "end" => Time.parse("10:00")}],
  [{"start" => Time.parse("09:00"), "end" => Time.parse("09:30")}]
  )
puts "#{new_range[0]["start"].strftime("%H:%M")}-#{new_range[0]["end"].strftime("%H:%M")}"

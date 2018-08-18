require 'time'

class TimeRange
  attr_accessor :start_time, :end_time
  def initialize(start_time, end_time)
    @start_time = start_time
    @end_time = end_time
  end
end

def included_range first, second
  included = nil
  # return included if (first.end_time < second.start_time or second.end_time < first.start_time)
  if first.start_time <= second.start_time
    if first.end_time >= second.end_time
      included = second
    end
  end
  return included
end

def subtract_range first, to_subtract
  subtracted = TimeRange.new(nil, nil)
  subtracted.start_time = to_subtract.end_time >= first.start_time ? to_subtract.end_time : first.start_time
  subtracted.end_time = first.end_time
  return nil if subtracted.start_time == subtracted.end_time
  return subtracted
end

def remove_overlap first_ranges, second_ranges
  new_range = []
  first_ranges.each do |first_range|
    second_ranges.each do |second_range|
      to_subtract = included_range(first_range, second_range)
      if to_subtract
        subtracted_range = subtract_range(first_range, to_subtract)
        new_range.push(subtracted_range) if subtracted_range
      else
        new_range.push(first_range)
      end
    end
  end
  return new_range
end
 
array = remove_overlap([TimeRange.new(9, 10)], [TimeRange.new(9, 9.5)])
puts array.inspect
array = remove_overlap([TimeRange.new(9, 10)], [TimeRange.new(9, 10)])
puts array.inspect
array = remove_overlap([TimeRange.new(9, 9.5)], [TimeRange.new(9.5, 15)])
puts array.inspect
array = remove_overlap([TimeRange.new(9, 9.5), TimeRange.new(10, 10.5)], [TimeRange.new(9.25, 10.25)])
puts array.inspect

# puts Time.parse("15:30")
# to_subtract = included_range(TimeRange.new(9, 12), TimeRange.new(10, 11)) # -> 9-10, 11-12
# puts "#{to_subtract.start_time}-#{to_subtract.end_time}"
# to_subtract = included_range(TimeRange.new(9, 12), TimeRange.new(10, 12))
# puts "#{to_subtract.start_time}-#{to_subtract.end_time}"
# to_subtract = included_range(TimeRange.new(9, 12), TimeRange.new(8, 8.5))
# puts "#{to_subtract.start_time}-#{to_subtract.end_time}"

# parcourir liste 1 
#   parcourir liste 2
# transformer en secondes
# comparer chaque time de liste 2 avec chaque de liste 1
# trier les listes
# enlever les doublons au début
# (9:00-10:00) “minus” (9:00-9:30) = (9:30-10:00)
# (9:00-10:00) “minus” (9:00-10:00) = ()
# (9:00-9:30) “minus” (9:30-15:00) = (9:00-9:30)
# (9:00-9:30, 10:00-10:30) “minus” (9:15-10:15) = (9:00-9:15, 10:15-10:30)
# (9:00-11:00, 13:00-15:00) “minus” (9:00-9:15, 10:00-10:15, 12:30-16:00)= (9:15-10:00, 10:15-11:00)

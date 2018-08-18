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
  if first.start_time <= second.start_time && first.end_time >= second.end_time
    included = second
  elsif second.start_time > first.start_time
    included = TimeRange.new(nil, nil)
    included.start_time = second.start_time
    included.end_time = first.end_time <= second.end_time ? first.end_time : second.end_time
  end
  return included
end

# (9, 10) (9, 9.5)
# included 9-9.5
# -> 9.5-10
# 9-10 / 9-9.5
def subtract_range first, to_subtract
  subtracted = TimeRange.new(nil, nil)
  if first.start_time < to_subtract.start_time
    subtracted.start_time = first.start_time
  elsif first.start_time >= to_subtract.start_time
    subtracted.start_time = to_subtract.end_time
  end
  if to_subtract.start_time > first.end_time
    subtracted.end_time = to_subtract.start_time
  elsif to_subtract.start_time <= first.end_time
    subtracted.end_time = first.end_time
  end
  return nil if subtracted.start_time >= subtracted.end_time
  # puts "subtracted: #{subtracted.start_time}-#{subtracted.end_time}"
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
puts "false" if array.length == 0 # || array[0].start_time != 9.5 || array[0].end_time != 10
array = remove_overlap([TimeRange.new(9, 10)], [TimeRange.new(9, 10)])
puts array.inspect
puts "false" if array.length != 0
array = remove_overlap([TimeRange.new(9, 9.5)], [TimeRange.new(9.5, 15)])
puts array.inspect
puts "false" if !array || array[0].start_time != 9 || array[0].end_time != 9.5
array = remove_overlap([TimeRange.new(9, 9.5), TimeRange.new(10, 10.5)], [TimeRange.new(9.25, 10.25)]) # included 9.25-9.5
puts array.inspect
puts "false" if !array || array[0].start_time != 9 || array[0].end_time != 9.25 || array[1].start_time != 10.25 || array[1].end_time != 10.5

# trier les listes
# enlever les doublons au début
# (9:00-10:00) “minus” (9:00-9:30) = (9:30-10:00)
# (9:00-10:00) “minus” (9:00-10:00) = ()
# (9:00-9:30) “minus” (9:30-15:00) = (9:00-9:30)
# (9:00-9:30, 10:00-10:30) “minus” (9:15-10:15) = (9:00-9:15, 10:15-10:30)
# (9:00-11:00, 13:00-15:00) “minus” (9:00-9:15, 10:00-10:15, 12:30-16:00)= (9:15-10:00, 10:15-11:00)

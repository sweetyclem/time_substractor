require 'time'

class TimeRange
  attr_accessor :start_time, :end_time
  def initialize(start_time, end_time)
    @start_time = start_time
    @end_time = end_time
  end
end

def overlapped_ranges first, second
  overlapped = []
  if second.start_time >= first.start_time && first.end_time >= second.end_time
    overlapped.push(second)
  elsif second.start_time >= first.start_time && first.end_time <= second.end_time
    overlapped.push(TimeRange.new(second.start_time, first.end_time)) if second.start_time != first.end_time
  elsif second.start_time <= first.start_time && first.end_time >= second.end_time
    overlapped.push(TimeRange.new(second.end_time, first.end_time)) if second.end_time != first.end_time
  elsif second.start_time <= first.start_time && first.end_time <= second.end_time
    overlapped.push(first)
  end
  return overlapped
end

# 9-9.5 / 10-10.5     subtract   9.25-10.25
# overlap 9.25-9.5 / 10-10.25
# result -> 9-9.25 / 10.25-10.5

def subtract_range first, to_subtract
  subtracted = []
  if to_subtract.start_time >= first.start_time && first.end_time >= to_subtract.end_time
    subtracted.push(TimeRange.new(first.start_time, to_subtract.start_time))
    subtracted.push(TimeRange.new(to_subtract.end_time, first.end_time))
  elsif to_subtract.start_time >= first.start_time && first.end_time <= to_subtract.end_time
    subtracted.push(TimeRange.new(first.start_time, to_subtract.start_time))
  elsif to_subtract.start_time <= first.start_time && first.end_time >= to_subtract.end_time
    subtracted.push(TimeRange.new(to_subtract.end_time, first.end_time))
  elsif to_subtract.start_time <= first.start_time && first.end_time <= to_subtract.end_time
    return subtracted
  end
  subtracted.delete_if{|range| range.start_time == range.end_time}
  return subtracted
end

def remove_overlap first_ranges, second_ranges
  new_ranges = []
  first_ranges.each do |first_range|
    second_ranges.each do |second_range|
      to_subtract = overlapped_ranges(first_range, second_range)
      if to_subtract.length > 0
        to_subtract.each do |range|
          new_ranges.push(subtract_range(first_range, range))
        end
      else
        new_ranges.push(first_range)
      end
    end
  end
  return new_ranges
end
# array = remove_overlap([TimeRange.new(9, 10)], [TimeRange.new(9, 9.5)])
# puts array.inspect
# puts "false 1- should be 9.5-10" if array.length == 0 || array[0].start_time != 9.5 || array[0].end_time != 10
# array = remove_overlap([TimeRange.new(9, 10)], [TimeRange.new(9, 10)])
# puts array.inspect
# puts "false 2- should be empty" if array.length != 0
# array = remove_overlap([TimeRange.new(9, 9.5)], [TimeRange.new(9.5, 15)])
# puts array.inspect
# puts "false 3- should be 9-9.5" if !array || array[0].start_time != 9 || array[0].end_time != 9.5
array = remove_overlap([TimeRange.new(9, 9.5), TimeRange.new(10, 10.5)], [TimeRange.new(9.25, 10.25)])
puts array.inspect
puts "false 4- should be 9-9.25, 10.25-10.5"  if !array || array[0].start_time != 9 || array[0].end_time != 9.25 || array[1].start_time != 10.25 || array[1].end_time != 10.5
array = remove_overlap([TimeRange.new(9, 11), TimeRange.new(13, 15)], [TimeRange.new(9, 9.25), TimeRange.new(10, 10.25), TimeRange.new(12.5, 16)])
puts array.inspect
puts "false 5- should be 9.25-10, 10.25-11" if !array || array[0].start_time != 9.25 || array[0].end_time != 10 || array[1].start_time != 10.25 || array[1].end_time != 11

# trier les listes
# enlever les doublons au début
# (9:00-10:00) “minus” (9:00-9:30) = (9:30-10:00)
# (9:00-10:00) “minus” (9:00-10:00) = ()
# (9:00-9:30) “minus” (9:30-15:00) = (9:00-9:30)
# (9:00-9:30, 10:00-10:30) “minus” (9:15-10:15) = (9:00-9:15, 10:15-10:30)
# (9:00-11:00, 13:00-15:00) “minus” (9:00-9:15, 10:00-10:15, 12:30-16:00)= (9:15-10:00, 10:15-11:00)

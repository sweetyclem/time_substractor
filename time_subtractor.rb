require 'time'
require_relative './time_range.rb'

class TimeSubtractor
  def self.overlapped_ranges first, second
    overlapped = []
    if second.start_time >= first.start_time && first.end_time >= second.end_time
      overlapped.push(second)
    elsif second.start_time >= first.start_time && first.end_time <= second.end_time
      overlapped.push(TimeRange.new(second.start_time, first.end_time)) if second.start_time != first.end_time
    elsif second.start_time <= first.start_time && first.end_time >= second.end_time
      overlapped.push(TimeRange.new(first.start_time, second.end_time)) if second.end_time != first.end_time
    elsif second.start_time <= first.start_time && first.end_time <= second.end_time
      overlapped.push(first)
    end
    overlapped.delete_if{|range| range.start_time > range.end_time}
    return overlapped
  end

  def self.subtract_range first, to_subtract
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

  def self.remove_overlap first_ranges, second_ranges
    new_ranges = []
    first_ranges.each do |first_range|
      if second_ranges.length == 1
        second_range = second_ranges[0]
        to_subtract = overlapped_ranges(first_range, second_range)
        if to_subtract.length > 0
          to_subtract.each do |range_to_subtract|
            subtract_range(first_range, range_to_subtract).each{|subtracted_range| new_ranges.push(subtracted_range)}
          end
        elsif first_range.end_time == second_range.start_time
          new_ranges.push(first_range)
        end
      else
        subtracted_first = first_range
        second_ranges.each_with_index do |second_range, index|
          to_subtract = overlapped_ranges(first_range, second_range)
          if to_subtract.length > 0
            to_subtract.each do |range_to_subtract|
              subtracted_ranges = subtract_range(subtracted_first, range_to_subtract)
              subtracted_first = subtracted_ranges[0] if subtracted_ranges.length == 1
              subtracted_ranges.each do |subtracted_range|
                new_ranges.push(subtracted_range) if index == (second_ranges.length - 1) || second_ranges[index +1].start_time > first_range.end_time
              end
            end
          elsif first_range.end_time == second_range.start_time
            new_ranges.push(first_range)
          end
        end
      end
    end
    return new_ranges
  end
end

# trier les listes
# enlever les doublons au début

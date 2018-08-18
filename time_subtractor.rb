class TimeRange
  attr_accessor :start_time, :end_time
  def initialize(start_time, end_time)
    @start_time = start_time
    @end_time = end_time
  end
end

def included_range first, second
  included = TimeRange.new(nil, nil)
  if first.start_time <= second.start_time
    if first.end_time >= second.end_time
      included = second
    end
  end
  return included
end

def subtract_time first_ranges, second_ranges
  first_ranges.each do |first_range|
    second_ranges.each do |second_range|
      to_substract = included_range(first_range, second_range)
    end
  end
end

subtract_time = included_range(TimeRange.new(9, 12), TimeRange.new(10, 11))
puts "#{subtract_time.start_time}-#{subtract_time.end_time}"
subtract_time = included_range(TimeRange.new(9, 12), TimeRange.new(10, 12))
puts "#{subtract_time.start_time}-#{subtract_time.end_time}"
subtract_time = included_range(TimeRange.new(9, 10), TimeRange.new(9, 9.5))
puts "#{subtract_time.start_time}-#{subtract_time.end_time}"
subtract_time = included_range(TimeRange.new(9, 10), TimeRange.new(9, 10))
puts "#{subtract_time.start_time}-#{subtract_time.end_time}"
subtract_time = included_range(TimeRange.new(9, 9.5), TimeRange.new(9.5, 15))
puts "#{subtract_time.start_time}-#{subtract_time.end_time}"

# puts included_range({"start" => 9, "end" => 9.5}, {"start" => 10, "end" => 10.5}, {"start" => 9.25, "end" => 10.25})
# puts included_range({"start" => 9, "end" => 11}, {"start" => 13, "end" => 15}, {"start" => 9, "end" => 9.25}, {"start" => 10, "end" => 10.25}, {"start" => 12.5, "end" => 16})

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

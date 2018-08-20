require 'minitest/autorun'
require_relative './time_range.rb'
require_relative './time_subtractor.rb'

class TestTimeSubtractor < Minitest::Test    
  def test_overlapped_ranges
    overlapped = TimeSubtractor.overlapped_ranges(
      TimeRange.new(Time.parse("9:00").to_f, Time.parse("10:00").to_f),
      TimeRange.new(Time.parse("9:30").to_f, Time.parse("11:00").to_f)
      )
    assert_equal 1, overlapped.count
    assert_equal Time.parse("9:30").to_f, overlapped[0].start_time
    assert_equal Time.parse("10:00").to_f, overlapped[0].end_time
  end
  
  def test_subtract_range
    subtracted = TimeSubtractor.subtract_range(
      TimeRange.new(Time.parse("12:00").to_f, Time.parse("14:00").to_f),
      TimeRange.new(Time.parse("12:30").to_f, Time.parse("13:30").to_f)
      )
    assert_equal 2, subtracted.count
    assert_equal Time.parse("12:00").to_f, subtracted[0].start_time
    assert_equal Time.parse("12:30").to_f, subtracted[0].end_time
    assert_equal Time.parse("13:30").to_f, subtracted[1].start_time
    assert_equal Time.parse("14:00").to_f, subtracted[1].end_time
  end

  def test_remove_overlap_one_in_each_second_included_in_first
    new_range = TimeSubtractor.subtract(
      [{"start" => Time.parse("09:00"), "end" => Time.parse("10:00")}],
      [{"start" => Time.parse("09:00"), "end" => Time.parse("09:30")}]
      )
    assert_equal 1, new_range.count
    assert_equal Time.parse("9:30"), new_range[0]["start"]
    assert_equal Time.parse("10:00"), new_range[0]["end"]
  end
  
  def test_remove_overlap_one_in_each_second_equal_to_first
    new_range = TimeSubtractor.subtract(
      [{"start" => Time.parse("09:00"), "end" => Time.parse("10:00")}],
      [{"start" => Time.parse("09:00"), "end" => Time.parse("10:00")}]
      )
    assert_equal 0, new_range.count
  end

  def test_remove_overlap_one_in_each_second_ends_after_first
    new_range = TimeSubtractor.subtract(
      [{"start" => Time.parse("09:00"), "end" => Time.parse("09:30")}],
      [{"start" => Time.parse("09:30"), "end" => Time.parse("15:00")}]
      )
    assert_equal 1, new_range.count
    assert_equal Time.parse("9:00"), new_range[0]["start"]
    assert_equal Time.parse("9:30"), new_range[0]["end"]
  end
  
  def test_remove_overlap_two_in_first
    new_range = TimeSubtractor.subtract(
      [
        {"start" => Time.parse("09:00"), "end" => Time.parse("09:30")},
        {"start" => Time.parse("10:00"), "end" => Time.parse("10:30")}
      ],
      [{"start" => Time.parse("09:15"), "end" => Time.parse("10:15")}]
      )
    assert_equal 2, new_range.count
    assert_equal Time.parse("9:00"), new_range[0]["start"]
    assert_equal Time.parse("9:15"), new_range[0]["end"]
    assert_equal Time.parse("10:15"), new_range[1]["start"]
    assert_equal Time.parse("10:30"), new_range[1]["end"]
  end
  
  def test_remove_overlap_two_in_second
    new_range = TimeSubtractor.subtract(
      [{"start" => Time.parse("09:00"), "end" => Time.parse("11:00")}],
      [
        {"start" => Time.parse("09:00"), "end" => Time.parse("09:15")},
        {"start" => Time.parse("10:00"), "end" => Time.parse("10:15")}
      ])
    assert_equal 2, new_range.count
    assert_equal Time.parse("9:15"), new_range[0]["start"]
    assert_equal Time.parse("10:00"), new_range[0]["end"]
    assert_equal Time.parse("10:15"), new_range[1]["start"]
    assert_equal Time.parse("11:00"), new_range[1]["end"]
  end
  
  def test_remove_overlap_several_in_each
    new_range = TimeSubtractor.subtract(
      [
        {"start" => Time.parse("09:00"), "end" => Time.parse("11:00")},
        {"start" => Time.parse("13:00"), "end" => Time.parse("15:00")}
      ],
      [
        {"start" => Time.parse("09:00"), "end" => Time.parse("09:15")},
        {"start" => Time.parse("10:00"), "end" => Time.parse("10:15")},
        {"start" => Time.parse("12:30"), "end" => Time.parse("16:00")}
      ])
    assert_equal 2, new_range.count
    assert_equal Time.parse("9:15"), new_range[0]["start"]
    assert_equal Time.parse("10:00"), new_range[0]["end"]
    assert_equal Time.parse("10:15"), new_range[1]["start"]
    assert_equal Time.parse("11:00"), new_range[1]["end"]
  end
end

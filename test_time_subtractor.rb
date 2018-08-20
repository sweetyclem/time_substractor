require 'minitest/autorun'
require_relative './time_range.rb'
require_relative './time_subtractor.rb'

class TestTimeSubtractor < Minitest::Test
  def setup
    # high_risk_phrases = "Kitten\ncat\n"
    # low_risk_phrases = "Some puppies\n"
    # File.open("test_phrases1.txt", "a") {|f| f.write(high_risk_phrases)}
    # File.open("test_phrases2.txt", "a") {|f| f.write(low_risk_phrases)}
    # @content = "Cat mojo asdflkjaertvlkjasntvkjn (sits on keyboard) then cats take over the world or chew iPad power cord"
    # @time_subtractor = TimeSubtractor.new()
  end

  def teardown
    # File.delete("test_phrases1.txt")
    # File.delete("test_phrases2.txt")
  end
  
  def test_overlapped_ranges
    overlapped = TimeSubtractor.overlapped_ranges(TimeRange.new(9, 10), TimeRange.new(9.5, 11))
    assert_equal 1, overlapped.count
    assert_equal 9.5, overlapped[0].start_time
    assert_equal 10, overlapped[0].end_time
  end
  
  def test_subtract_range
    subtracted = TimeSubtractor.subtract_range(TimeRange.new(12, 14), TimeRange.new(12.5, 13.5))
    assert_equal 2, subtracted.count
    assert_equal 12, subtracted[0].start_time
    assert_equal 12.5, subtracted[0].end_time
    assert_equal 13.5, subtracted[1].start_time
    assert_equal 14, subtracted[1].end_time
  end

  def test_remove_overlap_one_in_each_second_included_in_first
    new_range = TimeSubtractor.remove_overlap([TimeRange.new(9, 10)], [TimeRange.new(9, 9.5)])
    assert_equal 1, new_range.count
    assert_equal 9.5, new_range[0].start_time
    assert_equal 10, new_range[0].end_time
  end
  
  def test_remove_overlap_one_in_each_second_equal_to_first
    new_range = TimeSubtractor.remove_overlap([TimeRange.new(9, 10)], [TimeRange.new(9, 10)])
    assert_equal 0, new_range.count
  end

  def test_remove_overlap_one_in_each_second_ends_after_first
    new_range = TimeSubtractor.remove_overlap([TimeRange.new(9, 9.5)], [TimeRange.new(9.5, 15)])
    assert_equal 1, new_range.count
    assert_equal 9, new_range[0].start_time
    assert_equal 9.5, new_range[0].end_time
  end
  
  def test_remove_overlap_two_in_first
    new_range = TimeSubtractor.remove_overlap([TimeRange.new(9, 9.5), TimeRange.new(10, 10.5)], [TimeRange.new(9.25, 10.25)])
    assert_equal 2, new_range.count
    assert_equal 9, new_range[0].start_time
    assert_equal 9.25, new_range[0].end_time
    assert_equal 10.25, new_range[1].start_time
    assert_equal 10.5, new_range[1].end_time
  end

  def test_remove_overlap_two_in_second
    new_range = TimeSubtractor.remove_overlap([TimeRange.new(9, 11), TimeRange.new(13, 15)], [TimeRange.new(9, 9.25), TimeRange.new(10, 10.25), TimeRange.new(12.5, 16)])
    assert_equal 2, new_range.count
    assert_equal 9.25, new_range[0].start_time
    assert_equal 10, new_range[0].end_time
    assert_equal 10.25, new_range[1].start_time
    assert_equal 11, new_range[1].end_time
  end
end

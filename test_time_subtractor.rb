require 'minitest/autorun'
require_relative './time_range.rb'
require_relative './time_subtractor.rb'

# (9:00-10:00) “minus” (9:00-9:30) = (9:30-10:00)
# (9:00-10:00) “minus” (9:00-10:00) = ()
# (9:00-9:30) “minus” (9:30-15:00) = (9:00-9:30)
# (9:00-9:30, 10:00-10:30) “minus” (9:15-10:15) = (9:00-9:15, 10:15-10:30)
# (9:00-11:00, 13:00-15:00) “minus” (9:00-9:15, 10:00-10:15, 12:30-16:00)= (9:15-10:00, 10:15-11:00)

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
end

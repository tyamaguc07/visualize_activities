require 'minitest/autorun'
require 'time'

class TargetTimeTest < MiniTest::Unit::TestCase
  def setup
  end

  def test_start_time
    start_date = '2020-01-01'
    target_time = TargetTime.new(start_date)
    assert_equal(Time.parse(start_date), target_time.start_time)
  end
end

require 'time'
require 'forwardable'

class TargetTime
  extend Forwardable

  def_delegators :@time, :==, :iso8601

  def initialize(target_date)
    @time = Time.parse(target_date)
  end

  def within?(time)
    time.between?(start_time, end_time)
  end

  def without?(time)
    !within?(time)
  end

  def start_time
    @start_time ||= time.beginning_of_month
  end

  def end_time
    @end_time ||= time.end_of_month
  end

  private
  attr_accessor :time
end
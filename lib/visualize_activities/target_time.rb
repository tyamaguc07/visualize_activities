require 'time'
require 'forwardable'

class TargetTime
  extend Forwardable

  attr_reader :start_time, :end_time
  def_delegators :@start_time, :==, :iso8601

  def initialize(start_date, end_date=nil)
    @start_time = Time.parse(start_date)
    @end_time = end_date ? Time.parse(end_date).end_of_day : @start_time.end_of_month
  end

  def within?(time)
    time.between?(start_time, end_time)
  end

  def without?(time)
    !within?(time)
  end

  private
  attr_accessor :time
end

require 'time'
require 'forwardable'

class TargetTime
  extend Forwardable

  def_delegators :@time, :==, :iso8601

  def initialize(target_date)
    @time = Time.parse(target_date)
  end

  attr_accessor :time
end
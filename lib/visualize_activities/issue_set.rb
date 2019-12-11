require 'forwardable'

module VisualizeActivities
  class IssueSet
    extend Forwardable
    def_delegators :@issues, :each

    def initialize(issues)
      @issues = issues
    end

    private

    attr_reader :issues
  end
end

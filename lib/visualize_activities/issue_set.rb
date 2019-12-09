require 'forwardable'

module VisualizeActivities
  class IssueSet
    extend Forwardable
    def_delegators :@issues, :each

    def initialize(issues)
      @issues = issues
    end

    def contributed
    end

    def assigned(target)
      issues.select do |issue|
        issue.assignees.any? {|assignee| assignee == target}
      end
    end

    private

    attr_reader :issues
  end
end

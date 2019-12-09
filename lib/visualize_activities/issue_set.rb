module VisualizeActivities
  class IssueSet
    def initialize(issues)
      @issues = issues
    end

    def contributed
    end

    def assigned
    end

    private

    attr_reader :issues
  end
end

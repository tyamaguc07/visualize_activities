module VisualizeActivities
  class PullRequestSet
    def initialize(pull_requests)
      @pull_requests = pull_requests
    end

    private

    attr_reader :pull_requests
  end
end


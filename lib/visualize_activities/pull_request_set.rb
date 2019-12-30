require 'forwardable'

module VisualizeActivities
  class PullRequestSet
    extend Forwardable
    def_delegators :@pull_requests, :each, :present?

    def initialize(pull_requests)
      @pull_requests = pull_requests
    end

    private

    attr_reader :pull_requests
  end
end


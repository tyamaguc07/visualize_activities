module VisualizeActivities::Query
  class PullRequest
    def self.search(owner, repository, target, target_time)
      return PullRequest.new(owner, repository, target, target_time).search
    end

    def initialize(owner, repository, target, target_time)
      @owner = owner
      @repository = repository
      @target = target
      @target_time = target_time
    end

    attr_reader :owner, :repository, :target, :target_time

    def search
    end

    private

    Query = VisualizeActivities::Client.parse <<-GraphQL
query($owner: String!, $repository: String!, $after: String) {
  repository(owner: $owner, name: $repository) {
    pullRequests(after: $after, orderBy: {field: CREATED_AT, direction: DESC}, first: 100) {
      nodes {
        bodyHTML
        author {
          login
        }
        reviews(first: 100) {
          nodes {
            author {
              login
            }
            bodyHTML
            createdAt
          }
        }
      }
      pageInfo {
        endCursor
      }
    }
  }
}
    GraphQL
  end
end

module VisualizeActivities
  class Issues
    def self.fetch(owner, repository, target, target_time)
      VisualizeActivities::Client.query(Query, variables: {
        owner: owner,
        repository: repository,
        target: target,
        since: target_time.iso8601,
      })
    end

    Query = VisualizeActivities::Client.parse <<-GraphQL
query($owner: String!, $repository: String!, $target: String!, $since: DateTime!) {
  repository(owner: $owner, name: $repository) {
    issues(filterBy: {assignee: $target, since: $since} first: 100) {
      nodes {
        title
        timelineItems(
          itemTypes: [ASSIGNED_EVENT, CROSS_REFERENCED_EVENT],
          since: $since,
          first: 100) {
          edges {
            node {
              __typename
              ... on CrossReferencedEvent {
                actor {login}
                url
                createdAt
              }
              ... on AssignedEvent {
                assignee {
                  ... on User {
                    login
                  }
                }
                createdAt
              }
            }
          }
        }
      }
    }
  }
}
    GraphQL
  end
end

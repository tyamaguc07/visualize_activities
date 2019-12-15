require 'erb'

module VisualizeActivities
  module Visualizer
    class PullRequest
      def self.execute(setting)
        created, contributed = VisualizeActivities::Query::PullRequests.search(setting)

        template = <<template
## Created PullRequests

<% created.each do |pull_request| %>

<%= pull_request.to_markdown %>

<% end %>

## Contributed PullRequest

<% contributed.each do |pull_request| %>

<%= pull_request.to_markdown %>

#### Reviews

<% pull_request.review_comments.each do |comment| %>
<%= comment.to_markdown %>
<% end %>

#### Comments

<% pull_request.comments.each do |comment| %>
<%= comment.to_markdown %>
<% end %>

<% end %>

template

        ERB.new(template).result(binding)
      end
    end
  end
end

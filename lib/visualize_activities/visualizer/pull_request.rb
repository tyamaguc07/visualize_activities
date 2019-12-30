require 'erb'

module VisualizeActivities
  module Visualizer
    class PullRequest
      def self.execute(setting)
        created_pull_request_set, contributed_pull_request_set = VisualizeActivities::Query::PullRequests.search(setting)

        template = <<template
## Created PullRequests
<% if created_pull_request_set.present? %>
<% created_pull_request_set.each do |pull_request| %>
<%= pull_request.to_markdown %>
<% end %>
<% else %>
なし
<% end %>

## Contributed PullRequest
<% if contributed_pull_request_set.present? %>
<% contributed_pull_request_set.each do |pull_request| %>
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
<% else %>
なし
<% end %>

template

        ERB.new(template).result(binding)
      end
    end
  end
end

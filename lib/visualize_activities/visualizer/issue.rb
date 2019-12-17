require 'erb'

module VisualizeActivities
  module Visualizer
    class Issue
      def self.execute(setting)
        assigned_issue_set, contributed_issue_set = VisualizeActivities::Query::Issues.search(setting)

        template = <<template
## Assigned issues
<% if assigned_issue_set.present? %>
<% assigned_issue_set.each do |issue| %>
<%= issue.to_markdown %>
<% end %>
<% else %>
なし
<% end %>

## Contributed issues
<% if contributed_issue_set.present? %>
<% contributed_issue_set.each do |issue| %>
<%= issue.to_markdown %>

#### Comments

<% issue.comments.each do |comment| %>
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

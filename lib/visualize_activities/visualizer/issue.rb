require 'erb'

module VisualizeActivities
  module Visualizer
    class Issue
      def self.execute(setting)
        assigned_issue_set, contributed_issue_set = VisualizeActivities::Query::Issues.search(setting)

        template = <<template
# <%= ENV['REPOSITORY'] %>

## Assigned issues

<% assigned_issue_set.each do |issue| %>

<%= issue.to_markdown %>

<% end %>

## Contributed issues

<% contributed_issue_set.each do |issue| %>

<%= issue.to_markdown %>

### Comments

<% issue.comments.each do |comment| %>

<%= comment.to_markdown %>

<% end %>
<% end %>

template

        ERB.new(template).result(binding)
      end
    end
  end
end

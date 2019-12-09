require "cgi"

module VisualizeActivities
  Issue = Struct.new(:title, :body_html, :assignees, :url, :created_at, :timeline_item_set) do

    def to_markdown
      <<-"MARKDOWN"
### [#{title}](#{url})

<iframe srcdoc="#{escaped_body_html}" style="width: 100%">
</iframe>
      MARKDOWN
    end

    def escaped_body_html
      body_html.gsub('&', '&amp;').gsub('"','&quot;')
    end
  end
end

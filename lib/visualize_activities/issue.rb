require "cgi"

module VisualizeActivities
  Issue = Struct.new(:title, :body_html, :url, :created_at, :timeline_item_set) do

    def comments
      timeline_item_set.comments
    end

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

module ApplicationHelper
    # Returns the full title on a per-page basis.
    def full_title(page_title)
        base_title = "Tnarik's App"
        if page_title.empty?
            base_title
        else
            "#{base_title} | #{page_title}"
        end
    end

    def ga_track
      Gabba::Gabba.new("UA-40707807-1", "upped.me").event("category_yy", "action_nn")
    end
end

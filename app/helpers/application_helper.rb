module ApplicationHelper
  # Return a title on a per-page basis.
    def title
      base_title = "Artefacts for Loan Web Service"
      if @title.nil?
        base_title
      else
        "#{base_title} | #{@title}"
      end
    end
    
    def logo
        image_tag("", :alt => "Artefacts for Loan Web Service", :class => "round")
    end
  
  
end


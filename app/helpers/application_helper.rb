module ApplicationHelper
  def full_title(title)
    if(!title.empty?)
      "Weasels | #{title}"
    else
      "Weasels"
    end
  end
end

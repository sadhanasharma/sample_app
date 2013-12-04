module ApplicationHelper

# Return a title on per page basis
def getTitle
	base_title ="Ruby on Rails Tutorial Sample  App"
	if @title.nil?
		base_title
	else		
		"#{base_title} | #{@title}"
	end

end

def getLogo
	 image_tag("logo.png", :alt => "Sample Application" , :class => "round")	
end

end

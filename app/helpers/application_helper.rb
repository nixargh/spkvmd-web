module ApplicationHelper
	def logo
		image_tag("logo.jpg", :alt => "spkvmd-web", :class => "round", :size => "80x80")
	end

	def title
		base_title = "spkvmd web administration"
		@title ? "#{base_title} | #{@title}" : base_title
	end
end

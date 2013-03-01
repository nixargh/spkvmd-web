module ApplicationHelper
	def title
		base_title = "spkvmd web administration"
		@title ? "#{base_title} | #{@title}" : base_title
	end
end

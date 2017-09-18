########################################
Template.menu.helpers
	sub_menu: () ->
		profile = get_profile()
		if not profile
			return false

		switch profile.occupation
			when "student" then return "student_menu"
			when "teacher" then return "teacher_menu"
			when "company" then return "company_menu"
			else return false


########################################
Template.menu.events
	'click #logout': (event) ->
		Meteor.logout()


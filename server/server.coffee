#####################################################
#
#Created by Markus on 26/10/2015.
#
#####################################################

#####################################################
@add_admin = () ->
	user = Accounts.findUserByEmail("admin@alpha.org")

	if !user
		secret = Secrets.findOne()
		user =
			email: "admin@alpha.org",
			password: secret.mkpswd,

		user = Accounts.createUser(user)
		Roles.setUserRoles user, ["admin", "db_admin"]

	msg = "admin added " + user.email + " " + user._id
	log_event msg, event_testing, event_info


#####################################################
# start up
#####################################################
Meteor.startup () ->
	try
		add_admin()
	catch e
		msg = String(e)
		log_event msg, event_testing, event_err

	index =
		owner_id: 1
	Ideas._ensureIndex index

	index =
		parent_id: 1
	Ideas._ensureIndex index

	index =
		content: "text"
		title: "text"
		tags: "text"
	Ideas._ensureIndex index

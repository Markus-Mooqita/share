#######################################################
#
# Created by Markus
#
#######################################################

################################################################
Meteor.methods
	add_idea: () ->
		user = Meteor.user()

		if not user
			throw new Meteor.Error('Not permitted.')

		if !Roles.userIsInRole(user._id, 'editor')
			throw new Meteor.Error('Not permitted.')

		idea =
			visible_to: "editor"

		id = store_document_unprotected Ideas, idea

		msg = "Post added: " + JSON.stringify idea, null, 2
		log_event msg, event_create, event_info

		return id


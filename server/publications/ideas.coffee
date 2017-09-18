#######################################################
#
#	Moocita collections
# Created by Markus on 26/10/2015.
#
#######################################################

#######################################################
Meteor.publish "ideas", (parameter) ->
	pattern =
		query: Match.Optional(String)
		page: Number
		size: Number
	check parameter, pattern

	user_id = this.userId
	filter = filter_visible_documents user_id

	crs = find_documents_paged_unprotected Ideas, filter, {}, parameter

	log_publication "Ideas", crs, filter, {}, "ideas", user_id
	return crs


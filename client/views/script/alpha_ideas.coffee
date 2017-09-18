##########################################################
# imports
##########################################################
import { FlowRouter } from 'meteor/ostrio:flow-router-extra'


################################################
# Ideas entry point
################################################

################################################
Template.alpha_ideas.onCreated ->
	Meteor.call "log_user",
		(err, res) ->
			if err
				console.log ["error", err]


########################################
# ideas list
########################################

########################################
Template.ideas.onCreated ->
	this.parameter = new ReactiveDict()

########################################
Template.ideas.helpers
	parameter: () ->
		return Template.instance().parameter

	ideas: () ->
		return Ideas.find()

########################################
Template.ideas.events
	"change #query":(event)->
		event.preventDefault()
		q = event.target.value
		ins = Template.instance()
		ins.parameter.set "query", q

	"click #add_idea": () ->
		Meteor.call "add_idea",
			(err, res) ->
				if err
					sAlert.error("Add idea error: " + err)


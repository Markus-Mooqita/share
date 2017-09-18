#######################################################
#
#Created by Markus on 12/11/2015.
#
#######################################################

##############################################
get_editor_id = () ->
	editor_id = Template.instance().editor_id.get()
	if not editor_id
		sAlert.error("Object does not have a editor_id")

	return editor_id

##############################################
get_textarea = () ->
	editor_id = get_editor_id()
	frm = $("#editor_"+editor_id)
	return frm

#########################################################
# check input
#########################################################

#########################################################
Template.check_input.helpers
	checked: () ->
		field = get_field_value Template.instance().data
		if field
			return "checked"

		return ""

#########################################################
Template.check_input.events
	"change .edit-field": (event) ->
		field = event.target.id
		value = event.target.checked
		method = this.method
		collection = this.collection_name
		item_id = this.item_id

		if item_id == -1
			return

		Meteor.call method, collection, item_id, field, value, undefined,
			(err, res) ->
				if err
					sAlert.error("Check input error: " + err)
					console.log err
				if res
					sAlert.success("Updated: " + field)

#########################################################
# select input
#########################################################

#########################################################
Template.select_input.helpers
	is_selected: (val) ->
		field = get_field_value Template.instance().data

		if !(field instanceof Array)
			field = [String(field)]

		if String(val) in field
			return "selected"

#########################################################
Template.select_input.events
	"change .edit-field": (event) ->
		target = event.target
		value = target.options[target.selectedIndex].value;
		field = event.target.id
		value = event.target.value
		method = this.method
		collection = this.collection_name
		item_id = this.item_id

		if not isNaN value
			value = Number(value)

		if this.session_var
			Session.set this.session_var, value

		Meteor.call method, collection, item_id, field, value,
			(err, res) ->
				if err
					sAlert.error("Select input error: " + err)
					console.log err
				if res
					sAlert.success("Updated: " + field)


#########################################################
# basic input
#########################################################

#########################################################
Template.basic_input.helpers
	value: () ->
		value = get_field_value(this)
		return value

#########################################################
Template.basic_input.events
	"change .edit-field": (event) ->
		console.log this
		field = event.target.id
		value = event.target.value
		method = this.method
		collection = this.collection_name
		item_id = this.item_id

		if this.type == "number"
			value = Number(value)

		Meteor.call method, collection, item_id, field, value, undefined,
			(err, res) ->
				if err
					sAlert.error("Basic input error: " + err)
					console.log err
				if res
					sAlert.success("Updated: " + field)

#########################################################
# Text
#########################################################

#########################################################
Template.text_input.helpers
	value: () ->
		return get_field_value(this)

	is_selected: () ->
		return ""

	options: () ->
		return []

#########################################################
Template.text_input.events
	"change .edit-field": (event) ->
		field = event.target.id
		value = event.target.value
		method = this.method
		collection = this.collection_name
		item_id = this.item_id

		Meteor.call method, collection, item_id, field, value, undefined,
			(err, res) ->
				if err
					sAlert.error("Text input error: " + err)
					console.log err
				if res
					sAlert.success("Updated: " + field)

#########################################################
# markdown_input
#########################################################

#########################################################
Template.markdown_input.onCreated ->
	this.preview = new ReactiveVar(false)

#########################################################
Template.markdown_input.helpers
	value: () ->
		return get_field_value(this)

	is_selected: () ->
		return ""

	options: () ->
		return []

	preview: () ->
		return Template.instance().preview.get()

#########################################################
Template.markdown_input.events
	"click #preview_toggle": (event) ->
		tmpl = Template.instance()
		state = tmpl.preview.get()
		tmpl.preview.set !state

	"change .edit-field": (event) ->
		field = event.target.id
		value = event.target.value
		method = this.method
		collection = this.collection_name
		item_id = this.item_id

		Meteor.call method, collection, item_id, field, value, undefined,
			(err, res) ->
				if err
					sAlert.error("Markdown input error: " + err)
					console.log err
				if res
					sAlert.success("Updated: " + field)

#########################################################
# wysiwyg_input input
#########################################################

##############################################
Template.wysiwyg_input.onCreated ->
	editor_id = Math.floor(Math.random()*10000000)
	this.editor_id = new ReactiveVar(editor_id)

#######################################################
Template.wysiwyg_input.onRendered () ->
	conf =
		height: 200
		prettifyHtml: true
		codemirror:
			theme: "monokai"

	value = get_field_value(this.data)
	area = get_textarea()
	res = area.summernote(conf)
	res.summernote("code", value)

##############################################
Template.wysiwyg_input.helpers
	editor_id: ->
		return get_editor_id()

	value: ->
		return get_field_value(this)

	session: ->
		conf =
			height: 200
			prettifyHtml: false
			codemirror:
				theme: "monokai"

		value = get_field_value(this)
		area = get_textarea()
		res = area.summernote(conf)
		res.summernote("code", value)


#######################################################
Template.wysiwyg_input.events
	"click #save": ( event, template ) ->
		content = get_textarea().summernote("code")

		collection = this.collection_name
		method = this.method
		field = this.field
		item = this.item_id
		type = "string"

		Meteor.call method, collection, item, field, content, type,
			(err, res)->
				if err
					sAlert.error("Changes not saved!" + err)
					console.log err
				if res
					sAlert.success("Updated: " + field)

#########################################################
# code_input input
#########################################################

##############################################
Template.code_input.onCreated ->
	editor_id = Math.floor(Math.random()*10000000)
	this.editor_id = new ReactiveVar(editor_id)

###################################################
Template.code_input.helpers
	editor_id: ->
		return "editor_"+get_editor_id()

	editorCode: ->
		res = get_field_value(this)
		return res

	editorOptions: ()->
		res =
			lineNumbers: true
			mode: "htmlmixed"

		return res

#######################################################
Template.code_input.events
	"click #save": ( event, template ) ->
		content = get_textarea()[0].value
		collection = this.collection_name
		method = this.method
		field = this.field
		item = this.item_id
		type = "string"

		Meteor.call method, collection, item, field, content, type,
			(err, rsp)->
				if err
					sAlert.error("Changes not saved!" + err)
					console.log err
				if rsp
					sAlert.success("Updated: " + field)


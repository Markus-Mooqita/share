########################################
Template.paging.onCreated ->
	self = this
	parameter = self.data.parameter || new ReactiveDict()

	if not (parameter instanceof ReactiveDict)
		throw new Meteor.Error "Parameter needs to be a ReactiveDict."

	page = self.data.page || 0
	size = self.data.count || 10
	size = if size > 100 then 100 else size

	self.page = new ReactiveVar page
	self.size = new ReactiveVar size
	self.parameter = parameter

	self.autorun () ->
		handler =
			onStop: (err) ->
				if err
					sAlert.error("Pagination error: " + err)
			onReady: (res) ->
				sAlert.success("Success!")

		subscription = self.data.subscription
		parameter = self.parameter.all()
		parameter.page = self.page.get()
		parameter.size = self.size.get()

		self.subscribe subscription, parameter, handler


########################################
Template.paging.helpers
	page: () ->
		return String(Template.instance().page.get())

	size: () ->
		return String(Template.instance().size.get())


########################################
Template.paging.events
	"click #next":()->
		ins = Template.instance()
		p = ins.page.get()
		ins.page.set p+1

	"click #prev":()->
		ins = Template.instance()
		p = ins.page.get()
		if p == 0
			return
		ins.page.set p-1

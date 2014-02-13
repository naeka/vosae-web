Vosae.NotificationsController = Vosae.ArrayController.extend
  init: ->
    @_super()
    @set('content', Vosae.Notification.all())

  unreadNotifications: (->
    # All unread notifications
    @get("content").filter((notification) ->
      notification unless notification.get("read")
    ).sortBy("sentAt").reverse()
  ).property 'content', 'content.length', 'content.@each.read'

  readNotifications: (->
    # All notifications flaged as read
    @get("content").filter((notification) ->
      notification if notification.get("read")
    ).sortBy("sentAt").reverse()
  ).property 'content', 'content.length', 'content.@each.read'

  actions:
    # This is for lazy load on timeline links
    transitionToResource: (resource) ->
      switch resource.type
        # Contact
        when "Vosae.Contact"
          contact = Vosae.Contact.find(resource.id)
          @transitionToRoute "contact.show", @get('session.tenant'), contact
        
        # Organization
        when "Vosae.Organization"
          organization = Vosae.Organization.find(resource.id)
          @transitionToRoute "organization.show", @get('session.tenant'), organization
        
        # Quotation
        when "Vosae.Quotation"
          quotation = Vosae.Quotation.find(resource.id)
          @transitionToRoute "quotation.show", @get('session.tenant'), quotation
       
        # Invoice
        when "Vosae.Invoice"
          invoice = Vosae.Invoice.find(resource.id)
          @transitionToRoute "invoice.show", @get('session.tenant'), invoice
       
        # DownPaymentInvoice
        when "Vosae.DownPaymentInvoice"
          downPaymentInvoice = Vosae.DownPaymentInvoice.find(resource.id)
          @transitionToRoute "downPaymentInvoice.show", @get('session.tenant'), downPaymentInvoice

        # CreditNote
        when "Vosae.CreditNote"
          creditNote = Vosae.CreditNote.find(resource.id)
          @transitionToRoute "creditNote.show", @get('session.tenant'), creditNote

    # Flag all notifications as read
    markAllAsRead: ->
      @get('content').filterProperty('read', false).forEach (notification) ->
        notification.markAsRead()

  # Amount of unread notifications
  unreadCounter: (->
    length = @get('content').filterProperty('read', false).get('length')
    if length > 99
      length = "99+"
    length
  ).property('content.length', 'content.@each.read')
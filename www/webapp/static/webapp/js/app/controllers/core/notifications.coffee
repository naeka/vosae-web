Vosae.NotificationsController = Vosae.ArrayController.extend
  sortProperties: ['sentAt']
  sortAscending: false

  init: ->
    @_super()
    @set('content', Vosae.Notification.all())

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
    @filterProperty('read', false).forEach (notification) ->
      notification.markAsRead()

  # Amount of unread notifications
  unreadCounter: (->
    @filterProperty('read', false).get('length')
  ).property('length', 'content.@each.read')
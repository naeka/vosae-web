###
  This mixin helps us to transition to a lazy resource. For more
  explainations, please see `Vosae.LazyXXXResourceMixin`

  @class TransitionToLazyResourceMixin 
  @extends Ember.Mixin
  @namespace Vosae
  @module Vosae
###

Vosae.TransitionToLazyResourceMixin = Ember.Mixin.create
   actions: 
    transitionToResource: (resource) ->
      switch resource.type
        # Contact
        when "Vosae.Contact"
          contact = @store.find "contact", resource.id
          @transitionToRoute "contact.show", @get('session.tenant'), contact
        
        # Organization
        when "Vosae.Organization"
          organization = @store.find "organization", resource.id Vosae.Organization.find(resource.id)
          @transitionToRoute "organization.show", @get('session.tenant'), organization
        
        # Quotation
        when "Vosae.Quotation"
          quotation = @store.find "quotation", resource.id
          @transitionToRoute "quotation.show", @get('session.tenant'), quotation
       
        # Invoice
        when "Vosae.Invoice"
          invoice = @store.find "invoice", resource.id
          @transitionToRoute "invoice.show", @get('session.tenant'), invoice
       
        # DownPaymentInvoice
        when "Vosae.DownPaymentInvoice"
          downPaymentInvoice = @store.find "downPaymentInvoice", resource.id
          @transitionToRoute "downPaymentInvoice.show", @get('session.tenant'), downPaymentInvoice

        # CreditNote
        when "Vosae.CreditNote"
          creditNote = @store.find "creditNote", resource.id
          @transitionToRoute "creditNote.show", @get('session.tenant'), creditNote
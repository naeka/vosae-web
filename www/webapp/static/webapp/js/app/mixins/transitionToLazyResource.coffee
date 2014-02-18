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
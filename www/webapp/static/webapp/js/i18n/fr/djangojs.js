
/* gettext library */

var catalog = new Array();

function pluralidx(n) {
  var v=(n > 1);
  if (typeof(v) == 'boolean') {
    return v ? 1 : 0;
  } else {
    return v;
  }
}
catalog['Please enter 1 more character'] = ['',''];
catalog['Shared with me'] = ['',''];
catalog['Contact'] = ['',''];
catalog['In <span class=\'orange\'>{{count}}</span> company'] = ['',''];
catalog['<span class=\'green\'>{{count}}</span> Contact'] = ['',''];
catalog['# (sharp)'] = '# (di\u00e8se)';
catalog['- (dash)'] = '- (tiret)';
catalog['. (dot)'] = '. (point)';
catalog['/ (slash)'] = '/ (slash)';
catalog[': (colon)'] = ': (deux-point)';
catalog[':: (bi-colon)'] = ':: (double deux-points)';
catalog['<a>{{organization}}</a>, in application Contacts'] = '<a>{{organization}}</a>, dans l\'application Contacts';
catalog['<a>{{user}}</a>, in application Contacts'] = '<a>{{user}}</a>, dans l\'application Contacts';
catalog['<span class=\'green\'>{{count}}</span> Contact'][0] = '<span class=\'green\'>{{count}}</span> Contact';
catalog['<span class=\'green\'>{{count}}</span> Contact'][1] = '<span class=\'green\'>{{count}}</span> Contacts';
catalog['Access to the application'] = 'Acc\u00e8s \u00e0 l\'application';
catalog['Access to the calendar module'] = 'Acc\u00e8s au module agenda';
catalog['Access to the contacts module'] = 'Acc\u00e8s au module contacts';
catalog['Access to the invoicing module'] = 'Acc\u00e8s au module de facturation';
catalog['Active'] = 'Actif';
catalog['Add buttons'] = 'Boutons d\'ajout';
catalog['Add one or more attendees to the <strong>Event</strong>. If he or she is already in your <strong>Contacts</strong>, <i>Vosae</i> will find him/her instantly.'] = 'Ajoutez un ou plusieurs participants \u00e0 l\'<strong>\u00c9v\u00e9nement</strong>. Si il ou elle est d\u00e9j\u00e0 dans vos <strong>Contacts</strong>, <i>Vosae</i> le/la retrouvera imm\u00e9diatement.';
catalog['Add the address of the <strong>Contact</strong> and <i>Vosae</i> will show you a detailed map of the location. The address is particularly useful for invoicing, <i>Vosae</i> will fill everything in for you!'] = 'Ajoutez une adresse au <strong>Contact</strong> et <i>Vosae</i> vous affichera une carte d\u00e9taill\u00e9e de son emplacement. L\'adresse est particuli\u00e8rement utile lors de la facturation, <i>Vosae</i> remplira tout pour vous !';
catalog['Add the address of the <strong>Organization</strong> and <i>Vosae</i> will show you a detailed map of the location. The address is particularly useful for invoicing, <i>Vosae</i> will fill everything in for you!'] = 'Ajoutez une adresse \u00e0 l\'<strong>Organisation</strong> et <i>Vosae</i> vous affichera une carte d\u00e9taill\u00e9e de son emplacement. L\'adresse est particuli\u00e8rement utile lors de la facturation, <i>Vosae</i> remplira tout pour vous !';
catalog['Addresses'] = 'Adresses';
catalog['Also update payment due date?'] = '\u00c9galement mettre \u00e0 jour la date d\'\u00e9ch\u00e9ance ?';
catalog['An error occurred, please try again or contact the support'] = 'Une erreur est survenue, veuillez r\u00e9essayer ou contacter le support';
catalog['And on the right, the <strong>Invoice</strong> receiver. This is the <strong>Organization</strong> you want to bill. For greater efficiency, after you have added the organization and the contact in the <strong>Contact</strong> application, all you have to do is start typing, press Enter and <i>Vosae</i> will do the rest for you.'] = 'Et sur la droite, le destinataire de la <strong>Facture</strong>. C\'est l\'<strong>Organisation</strong> que vous voulez facturer. Pour plus d\'efficacit\u00e9, une fois que vous avez ajout\u00e9 l\'organisation et le contact dans l\'application <strong>Contact</strong>, tout ce que vous avez \u00e0 faire c\'est de commencer \u00e0 \u00e9crire, appuyer sur Entrer et <i>Vosae</i> va faire le reste pour vous.';
catalog['And on the right, the quotation receiver. This is the <strong>Organization</strong> you want to quote. For greater efficiency, after you have added the organization and the contact in the <strong>Contact</strong> application, all you have to do is start typing, press Enter and <i>Vosae</i> will do the rest for you.'] = 'Et sur la droite, le destinataire du <strong>Devis</strong>. C\'est l\'<strong>Organisation</strong> \u00e0 laquelle vous souhaitez dresser un devis. Pour plus d\'efficacit\u00e9, une fois que vous avez ajout\u00e9 l\'organisation et le contact dans l\'application <strong>Contact</strong>, tout ce que vous avez \u00e0 faire c\'est de commencer \u00e0 \u00e9crire, appuyer sur Entrer et <i>Vosae</i> va faire le reste pour vous.';
catalog['Applications'] = 'Applications';
catalog['Ascending'] = 'Croissant';
catalog['Australian dollar'] = 'Dollar australien';
catalog['Belgium'] = 'Belgique';
catalog['Billing'] = 'Facturation';
catalog['Brazilian real'] = 'Real br\u00e9silien';
catalog['British English'] = 'Anglais britannique';
catalog['By clicking on the <i>Vosae</i>, you will have an overview of your recent notifications. For example if a colleague edits a contact or quotation you created, you\'ll know it in realtime!'] = 'En cliquant sur le <i>Vosae</i>, vous aurez un aper\u00e7u de vos derni\u00e8res notifications. Par exemple, si un coll\u00e8gue \u00e9dite un contact ou un devis que vous avez cr\u00e9\u00e9, vous le saurez !';
catalog['Calendar color'] = 'Couleur de l\'agenda';
catalog['Calendar name (required field)'] = 'Nom de l\'agenda (champ obligatoire)';
catalog['Calendar'] = 'Agenda';
catalog['Can add contacts'] = 'Peut ajouter des contacts';
catalog['Can add groups'] = 'Peut ajouter des groupes';
catalog['Can add invoices'] = 'Peut ajouter des factures';
catalog['Can add items'] = 'Peut ajouter des articles';
catalog['Can add users'] = 'Peut ajouter des utilisateurs';
catalog['Can configure application'] = 'Peut configurer l\'application';
catalog['Can delete contacts'] = 'Peut supprimer des contacts';
catalog['Can delete files'] = 'Peut supprimer des fichiers';
catalog['Can delete groups'] = 'Peut supprimer des groupes';
catalog['Can delete items'] = 'Peut supprimer des articles';
catalog['Can delete users'] = 'Peut supprimer des utilisateurs';
catalog['Can delete/cancel invoices'] = 'Peut supprimer/annuler des factures';
catalog['Can download files'] = 'Peut t\u00e9l\u00e9charger des fichiers';
catalog['Can edit contacts'] = 'Peut \u00e9diter des contacts';
catalog['Can edit groups'] = 'Peut \u00e9diter des groupes';
catalog['Can edit invoices'] = 'Peut \u00e9diter des factures';
catalog['Can edit invoicing settings'] = 'Peut configurer les param\u00e8tres de facturation';
catalog['Can edit items'] = 'Peut \u00e9diter des articles';
catalog['Can edit users'] = 'Peut \u00e9diter des utilisateurs';
catalog['Can post invoices'] = 'Peut poster des factures';
catalog['Can see contacts'] = 'Peut visualiser les contacts';
catalog['Can see groups'] = 'Peut visualiser les groupes';
catalog['Can see invoices'] = 'Peut visualiser les factures';
catalog['Can see items'] = 'Peut visualiser les articles';
catalog['Can see users'] = 'Peut visualiser les utilisateurs';
catalog['Can transmit invoices'] = 'Peut transmettre des factures';
catalog['Can upload files'] = 'Peut charger des fichiers';
catalog['Canadian dollar'] = 'Dollar canadien';
catalog['Chinese yuan'] = 'Yuan chinois';
catalog['Color'] = 'Couleur';
catalog['Contact informations (required field)'] = 'Informations du contact (champ obligatoire)';
catalog['Contact'][0] = 'Contact';
catalog['Contact'][1] = 'Contacts';
catalog['Contacts permissions'] = 'Permissions sur les contacts';
catalog['Core permissions'] = 'Permissions g\u00e9n\u00e9rales';
catalog['Corporate name field must not be blank'] = 'La raison sociale est requise';
catalog['Create the item'] = 'Cr\u00e9er l\'article';
catalog['Create'] = 'Cr\u00e9er';
catalog['Currency (required)'] = 'Devise (obligatoire)';
catalog['Danish krone'] = 'Couronne danoise';
catalog['Date'] = 'Date';
catalog['Date, Number'] = 'Date, Nombre';
catalog['Default tax'] = 'Taxe par d\u00e9faut';
catalog['Deleted'] = 'Supprim\u00e9';
catalog['Delivery'] = 'Livraison';
catalog['Descending'] = 'D\u00e9croissant';
catalog['Description'] = 'Description';
catalog['Disabled'] = 'D\u00e9sactiv\u00e9';
catalog['Do you really want to delete this address?'] = 'Voulez-vous vraiment supprimer cette adresse ?';
catalog['Do you really want to delete this attachment?'] = 'Voulez-vous vraiment supprimer cette pi\u00e8ce-jointe ?';
catalog['Do you really want to delete this attendee?'] = 'Voulez-vous vraiment supprimer ce participant ?';
catalog['Do you really want to delete this calendar?'] = 'Voulez-vous vraiment supprimer cet agenda ?';
catalog['Do you really want to delete this contact?'] = 'Voulez-vous vraiment supprimer ce contact ?';
catalog['Do you really want to delete this email?'] = 'Voulez-vous vraiment supprimer cet email ?';
catalog['Do you really want to delete this event?'] = 'Voulez-vous vraiment supprimer cet \u00e9v\u00e9nement ?';
catalog['Do you really want to delete this group?'] = 'Voulez-vous vraiment supprimer ce groupe ?';
catalog['Do you really want to delete this invoice?'] = 'Voulez-vous vraiment supprimer cette facture ?';
catalog['Do you really want to delete this item?'] = 'Voulez-vous vraiment supprimer cet article ?';
catalog['Do you really want to delete this line?'] = 'Voulez-vous vraiment supprimer cette ligne ?';
catalog['Do you really want to delete this organization?'] = 'Voulez-vous vraiment supprimer cette organisation ?';
catalog['Do you really want to delete this permission?'] = 'Voulez-vous vraiment supprimer cette permission ?';
catalog['Do you really want to delete this phone?'] = 'Voulez-vous vraiment supprimer ce t\u00e9l\u00e9phone ?';
catalog['Do you really want to delete this quotation?'] = 'Voulez-vous vraiment supprimer ce devis ?';
catalog['Do you really want to delete this reminder?'] = 'Voulez-vous vraiment supprimer ce rappel ?';
catalog['Do you really want to delete this tax?'] = 'Voulez-vous vraiment supprimer cette taxe ?';
catalog['Do you really want to delete this user?'] = 'Voulez-vous vraiment supprimer cet utilisateur ?';
catalog['Do you really want to revoke this API key?'] = 'Voulez-vous vraiment r\u00e9voquer cette cl\u00e9 d\'API ?';
catalog['Do you realy want to leave this page ?'] = 'Voulez-vous vraiment quitter cette page ?';
catalog['Due date (required field)'] = 'Date d\'\u00e9ch\u00e9ance (champ obligatoire)';
catalog['Due date'] = 'Date d\'\u00e9ch\u00e9ance';
catalog['Egyptian pound'] = 'Livre \u00e9gyptienne';
catalog['Email field must not be blank'] = 'L\'e-mail est requis';
catalog['End tour'] = 'Terminer';
catalog['English'] = 'Anglais';
catalog['Euro'] = 'Euro';
catalog['Event <a>{{event}}</a>, in application Organizer'] = '\u00c9v\u00e9nement <a>{{event}}</a>, dans l\'application Agenda';
catalog['Event reminders'] = 'Rappels de l\'\u00e9v\u00e9nement';
catalog['Everything that happens in <i>Vosae</i> will appear here in realtime, allowing you an easy overview of your company.'] = 'Tout ce qui se passe dans <i>Vosae</i> appara\u00eetra ici en temps r\u00e9el, vous permettant d\'avoir tr\u00e8s simplement une vue d\'ensemble de votre entreprise.';
catalog['Field street address of receiver address must not be blank'] = 'L\'adresse du client est requise';
catalog['Field street address of sender address must not be blank'] = 'L\'adresse de l\'\u00e9metteur est requise';
catalog['File type not allowed'] = 'Ce type de fichier n\'est pas autoris\u00e9';
catalog['Finally, <strong>Save</strong> (or <strong>Cancel</strong>) your item to add it to <i>Vosae</i>.'] = 'Enfin, <strong>Cr\u00e9ez</strong> (ou <strong>Annulez</strong>) votre article pour l\'ajouter \u00e0 <i>Vosae</i>.';
catalog['Firstname field must not be blank'] = 'Le pr\u00e9nom est requis';
catalog['France'] = 'France';
catalog['French'] = 'Fran\u00e7ais';
catalog['From here you can define the default reminders of your calendar. Then, when you will create an event in this calendar, these reminders will be used. By default there are no reminders.'] = 'Depuis ici vous pouvez d\u00e9finir les rappels par d\u00e9faut de votre agenda. Ensuite, lorsque vous allez cr\u00e9er un \u00e9v\u00e9nement dans cet agenda, ces rappels seront utilis\u00e9s. Par d\u00e9faut, il n\'y a pas de rappels.';
catalog['From here, you can see and access the last <strong>Overdue invoices</strong> and <strong>Quotes to bill</strong>.'] = '\u00c0 partir d\'ici, vous pouvez voir et acc\u00e9der \u00e0 vos derni\u00e8res <strong>Factures en retard</strong> et vos <strong>Devis \u00e0 Facturer</strong>.';
catalog['From these tabs you can quickly navigate to your <strong>Invoices</strong>, <strong>Quotations</strong> and <strong>Items</strong>.'] = '\u00c0 partir de ces onglets vous pouvez acc\u00e9der rapidement \u00e0 vos <strong>Factures</strong>, <strong>Devis</strong> et <strong>Articles</strong>. ';
catalog['Great Britain'] = 'Grande-Bretagne';
catalog['Here you can define the price of your item and indicate any applicable tax as well as the currency. You can add or remove taxes and supported currencies in your <strong>Settings</strong>.'] = 'Ici vous pouvez pr\u00e9ciser le prix de votre article et indiquer toutes les taxes qui s\'y appliquent ainsi que la devise. Vous pouvez ajouter ou supprimer des taxes ou des devises support\u00e9es via vos <strong>Param\u00e8tres</strong>.';
catalog['Home cell'] = 'Portable (personnel)';
catalog['Home fax'] = 'Fax (personnel)';
catalog['Home'] = 'Domicile';
catalog['Hong Kong dollar'] = 'Dollar de Hong Kong';
catalog['If you have created at least one <strong>Organization</strong>, you can add the contact to it. It\'s the perfect way to easily organise and find your contacts.'] = 'Si vous avez cr\u00e9\u00e9 au moins une <strong>Organisation</strong>, vous pouvez y ajouter un contact. C\'est la meilleure fa\u00e7on pour facilement organiser et retrouver vos contacts.';
catalog['If you want to add more information to the <strong>Event</strong>, you can specify a <i>Location</i>, write a <i>Description</i>, change the <i>Color</i> or add a <i>Reminder</i>.'] = 'Si vous voulez ajouter davantage d\'informations \u00e0 l\'<strong>\u00c9v\u00e9nement</strong>, vous pouvez pr\u00e9ciser son <i>Lieu</i>, \u00e9crire une <i>Description</i>, changer la <i>Couleur</i> ou ajouter un <i>Rappel</i>.';
catalog['In <span class=\'orange\'>{{count}}</span> company'][0] = 'Dans <span class=\'orange\'>{{count}}</span> entreprise';
catalog['In <span class=\'orange\'>{{count}}</span> company'][1] = 'Dans <span class=\'orange\'>{{count}}</span> entreprises';
catalog['Indian rupee'] = 'Roupie indienne';
catalog['Invoice <a>{{invoice}}</a>, in application Invoicing'] = 'Facture <a>{{invoice}}</a>, dans l\'application Facturation';
catalog['Invoice items (at least one is required)'] = 'Articles de la facture (au moins un obligatoire)';
catalog['Invoice must be linked to an organization or a contact'] = 'La facture doit \u00eatre li\u00e9e \u00e0 une organisation ou \u00e0 un contact';
catalog['Invoice must have a currency'] = 'Une devise doit \u00eatre assign\u00e9e \u00e0 la facture';
catalog['Invoicing Dashboard'] = 'Tableau de bord de Facturation';
catalog['Invoicing date (required field)'] = 'Date de facturation (champ obligatoire)';
catalog['Invoicing permissions'] = 'Permissions sur la facturation';
catalog['Invoicing reference (auto-generated)'] = 'R\u00e9f\u00e9rence de la facture (auto-g\u00e9n\u00e9r\u00e9e)';
catalog['Invoicing\'s settings has been successfully updated'] = 'Vos param\u00e8tres de facturation ont \u00e9t\u00e9 correctement mis \u00e0 jour';
catalog['It\'s the right place to quickly add an <strong>Invoice</strong>, <strong>Quotation</strong> or <strong>Item</strong>!'] = 'C\'est le bon endroit pour ajouter rapidement une <strong>Facture</strong>, un <strong>Devis<strong/> ou un <strong>Article</strong> !';
catalog['Item currency must not be blank'] = 'La devise d\'un article est requise';
catalog['Item description must not be blank'] = 'La description d\'un article est requise';
catalog['Item price (required field)'] = 'Prix de l\'article (champ obligatoire)';
catalog['Item reference (required field)'] = 'R\u00e9f\u00e9rence de l\'article (champ obligatoire)';
catalog['Item reference must not be blank'] = 'La r\u00e9f\u00e9rence d\'un article est requise';
catalog['Item tax must not be blank'] = 'La taxe d\'un article est requise';
catalog['Item type (required field)'] = 'Type d\'article (champ obligatoire)';
catalog['Item unit price must not be blank'] = 'Le prix unitaire d\'un article est requis';
catalog['Items description must not be blank'] = 'La description des articles est requise';
catalog['Items reference must not be blank'] = 'La r\u00e9f\u00e9rence des articles est requise';
catalog['Japanese yen'] = 'Yen japonais';
catalog['Last entries'] = 'Derniers ajouts';
catalog['Looking for a <strong>Contact</strong>, an <strong>Invoice</strong> or <strong>Events</strong>? Start by typing any keyword and we\'ll do the rest for you.'] = 'Vous cherchez un <strong>Contact</strong>, une <strong>Facture</strong> ou des <strong>\u00c9v\u00e9nements</strong> ? Commencez par taper un mot-cl\u00e9 et nous faisons le reste.';
catalog['Luxembourg'] = 'Luxembourg';
catalog['Mexican peso'] = 'Peso mexicain';
catalog['Miss'] = 'Mlle';
catalog['More informations'] = 'Plus d\'informations';
catalog['Moroccan dirham'] = 'Dirham marocain';
catalog['Mr'] = 'M.';
catalog['Mrs'] = 'Mme';
catalog['Name field must not be blank'] = 'Le nom est requis';
catalog['New Zealand dollar'] = 'Dollar n\u00e9o-z\u00e9landais';
catalog['Next.'] = 'Suiv.';
catalog['No results for "{{queryString}}"'] = 'Aucun r\u00e9sultat pour "{{queryString}}"';
catalog['No results for "{{term}}"'] = 'Aucun r\u00e9sultat pour "{{term}}"';
catalog['No results for \''] = 'Aucun r\u00e9sultat pour \'';
catalog['No separator'] = 'Pas de s\u00e9parateur';
catalog['No'] = 'Non';
catalog['Norwegian krone'] = 'Couronne norv\u00e9gienne';
catalog['Notifications'] = 'Notifications';
catalog['Number'] = 'Nombre';
catalog['Ok'] = 'Ok';
catalog['On almost every page, you can get more information and some tips by clicking on <strong>Info</strong>!'] = 'Sur presque toutes les pages, vous pouvez obtenir plus d\'informations et quelques conseils en cliquant sur <strong>Infos</strong> !';
catalog['Once your invoice is completed, click on the <strong>Create</strong> button. <i>Vosae</i> will save it as a draft.'] = 'Une fois que votre facture est termin\u00e9e, cliquez sur le bouton <strong>Cr\u00e9er</strong>. <i>Vosae</i> va l\'enregistrer en tant que brouillon.';
catalog['Once your quotation is complete, click on the <strong>Create</strong> button. <i>Vosae</i> will save it as a draft.'] = 'Une fois que votre devis est termin\u00e9, cliquez sur le bouton <strong>Cr\u00e9er</strong>. <i>Vosae</i> va l\'enregistrer en tant que brouillon.';
catalog['Only one contact can be selected'] = 'Un seul contact peut \u00eatre s\u00e9lectionn\u00e9';
catalog['Only one item can be selected'] = 'Un seul article peut \u00eatre s\u00e9lectionn\u00e9';
catalog['Only one organization can be selected'] = 'Une seule organisation peut \u00eatre s\u00e9lectionn\u00e9e';
catalog['Only one tax can be selected'] = 'Une seule taxe peut \u00eatre s\u00e9lectionn\u00e9e';
catalog['Only one user or group can be selected'] = 'Un seul utilisateur ou groupe peut \u00eatre s\u00e9lectionn\u00e9';
catalog['Organization'] = 'Organisation';
catalog['Organization\'s information (required field)'] = 'Information de l\'Organisation (champ obligatoire)';
catalog['Organization\'s settings has been successfully updated'] = 'Les param\u00e8tres de l\'organisation ont \u00e9t\u00e9 correctement mis \u00e0 jour';
catalog['Organizations page'] = 'Page des organisations';
catalog['Organizer permissions'] = 'Permissions sur l\'agenda';
catalog['Organizer'] = 'Agenda';
catalog['Other'] = 'Autre';
catalog['Others Dashboard'] = 'Autres tableau de bord';
catalog['Phone field must not be blank'] = 'Le t\u00e9l\u00e9phone est requis';
catalog['Please enter 1 more character'][0] = 'Merci de saisir un caract\u00e8re suppl\u00e9mentaire';
catalog['Please enter 1 more character'][1] = 'Merci de saisir {{remainingChars}} caract\u00e8res suppl\u00e9mentaires';
catalog['Please, type at least {{minSearchTerms}} chars'] = 'Merci de saisir un minimum de {{minSearchTerms}} caract\u00e8res';
catalog['Pound sterling'] = 'Livre sterling';
catalog['Prev.'] = 'Pr\u00e9c.';
catalog['Product'] = 'Produit';
catalog['Products & Services'] = 'Produits & Services';
catalog['Products'] = 'Produits';
catalog['Quotation <a>{{quotation}}</a>, in application Invoicing'] = 'Devis <a>{{quotation}}</a>, dans l\'application Facturation';
catalog['Quotation date (required field)'] = 'Date du devis (champ obligatoire)';
catalog['Quotation items (at least one is required)'] = 'Articles du devis (au moins un obligatoire)';
catalog['Quotation must be linked to an organization or a contact'] = 'Le devis doit \u00eatre li\u00e9 \u00e0 une organisation ou \u00e0 un contact';
catalog['Quotation must have a currency'] = 'Une devise doit \u00eatre assign\u00e9e au devis';
catalog['Quotation reference (auto-generated)'] = 'R\u00e9f\u00e9rence du devis (auto-g\u00e9n\u00e9r\u00e9e)';
catalog['Reference'] = 'R\u00e9f\u00e9rence';
catalog['Russian rouble'] = 'Rouble russe';
catalog['Search bar'] = 'Barre de recherche';
catalog['See all contacts'] = 'Tous les contacts';
catalog['See all results for "{{queryString}}"'] = 'Voir tous les r\u00e9sultats pour "{{queryString}}"';
catalog['Service'] = 'Service';
catalog['Services'] = 'Services';
catalog['Settings and Logout'] = 'Param\u00e8tres et D\u00e9connexion';
catalog['Shared with me'][0] = 'Partag\u00e9 avec moi';
catalog['Shared with me'][1] = 'Partag\u00e9s avec moi';
catalog['Sharing (required field)'] = 'Partage (champ obligatoire)';
catalog['Street address field must not be blank'] = 'L\'addresse est requise';
catalog['Summary (not yet implemented)'] = 'R\u00e9sum\u00e9 (pas encore disponible)';
catalog['Swedish krona'] = 'Couronne su\u00e9doise';
catalog['Swiss franc'] = 'Franc suisse';
catalog['Switzerland'] = 'Suisse';
catalog['TOTAL Fiscal year {{fiscalYear}}'] = 'TOTAL Ann\u00e9e fiscale {{fiscalYear}}';
catalog['The <i>due date</i> is extremely useful, both for your customers and also for you. <i>Vosae</i> will notify you when an invoice becomes outdated.'] = 'La <i>date d\'\u00e9ch\u00e9ance</i> est extr\u00eamement utile, autant pour vos clients que pour vous. <i>Vosae</i> vous notifiera quand une facture est arriv\u00e9e \u00e0 \u00e9ch\u00e9ance.';
catalog['The <i>valid until</i> date is extremely useful, both for your customers and also for you. <i>Vosae</i> will notify you when a quotation becomes outdated.'] = 'La date <i>Valable jusqu\'au</i> est extr\u00eamement utile, autant pour vos clients que pour vous. <i>Vosae</i> vous notifiera quand un devis n\'est plus valide.';
catalog['The date of an <strong>Event</strong> can be edited very precisely.'] = 'La date d\'un <strong>\u00c9v\u00e9nement</strong> peut \u00eatre modifi\u00e9 de fa\u00e7on tr\u00e8s pr\u00e9cise.';
catalog['The date on which the <strong>Invoice</strong> was created. <i>Vosae</i> will insert the current date by default but you can edit it by clicking.'] = 'La date \u00e0 laquelle la <strong>Facture</strong> a \u00e9t\u00e9 cr\u00e9\u00e9. <i>Vosae</i> va ajouter par d\u00e9faut la date actuelle mais vous pouvez l\'\u00e9diter en cliquant dessus.';
catalog['The date on which the quotation was created. <i>Vosae</i> will insert the current date by default but you can edit it by clicking here.'] = 'La date \u00e0 laquelle le <strong>Devis</strong> a \u00e9t\u00e9 cr\u00e9\u00e9. <i>Vosae</i> va ajouter par d\u00e9faut la date actuelle mais vous pouvez l\'\u00e9diter en cliquant dessus.';
catalog['The group has been successfully created'] = 'Le groupe a \u00e9t\u00e9 correctement cr\u00e9\u00e9';
catalog['The group has been successfully deleted'] = 'Le groupe a \u00e9t\u00e9 correctement supprim\u00e9';
catalog['The group has been successfully updated'] = 'Le groupe a \u00e9t\u00e9 correctement mis \u00e0 jour';
catalog['The invoice reference is based on your <strong>Settings</strong> (see <strong>Numbering</strong> part) and is automatically added to your invoice once you have saved it.'] = 'La r\u00e9f\u00e9rence de la facture est bas\u00e9e sur vos <strong>Param\u00e8tres</strong> (voir la partie <strong>Num\u00e9rotation</strong> et est automatiquement ajout\u00e9e \u00e0 la facture lorsque vous l\'enregistrez.';
catalog['The maximum number of files exceeded'] = 'Le nombre maximum de fichiers a \u00e9t\u00e9 d\u00e9pass\u00e9';
catalog['The quotation reference is based on your <strong>Settings</strong> (see <strong>Numbering</strong> part) and is automatically added to your quotation once you have saved it.'] = 'La r\u00e9f\u00e9rence du devis est bas\u00e9e sur vos <strong>Param\u00e8tres</strong> (voir la partie <strong>Num\u00e9rotation</strong> et est automatiquement ajout\u00e9e au devis lorsque vous l\'enregistrez.';
catalog['The receiver (required field)'] = 'Le destinataire (champ obligatoire)';
catalog['The reference for your item, for example: <i>Blue Chair</i> or <i>Website</i>. To make it more explicit for your customer (and you), add a description. For example: <i>A beautiful handmade chair</i>.'] = 'La r\u00e9f\u00e9rence de votre article, par exemple: <i>Chaise Bleue</i> ou <i>Site Web</i>. Pour que se soit plus clair pour votre client (et vous), ajoutez une description. Par exemple: <i>Une belle chaise faite main</i>.';
catalog['The tax has been successfully created'] = 'La taxe a \u00e9t\u00e9 correctement cr\u00e9\u00e9e';
catalog['The tax has been successfully deleted'] = 'La taxe a \u00e9t\u00e9 correctement supprim\u00e9e';
catalog['The tax has been successfully updated'] = 'La taxe a \u00e9t\u00e9 correctement mise \u00e0 jour';
catalog['The transmitter (required field)'] = 'L\'\u00e9metteur (champ obligatoire)';
catalog['The user has been successfully created'] = 'L\'utilisateur a \u00e9t\u00e9 correctement cr\u00e9\u00e9';
catalog['The user has been successfully deleted'] = 'L\'utilisateur a \u00e9t\u00e9 correctement supprim\u00e9';
catalog['The user has been successfully updated'] = 'L\'utilisateur a \u00e9t\u00e9 correctement mis \u00e0 jour';
catalog['This button lets you specify whether your item is a product or a service.'] = 'Ce bouton vous permet de d\u00e9finir si votre article est une produit ou un service.';
catalog['This field is required.'] = 'Ce champ est requis.';
catalog['This file is too large'] = 'Ce fichier est trop volumineux';
catalog['This file is too small'] = 'Ce fichier est trop petit';
catalog['This is <i>the name of the calendar</i>. Add the name and the description of your calendar. For example <strong>Work</strong>, <strong>Private</strong>, <strong>My Amazing Project</strong> etc.'] = 'C\'est le <i>nom de l\'agenda</i>. Ajoutez le nom et la description de votre agenda. Par exemple <strong>Travail</strong>, <strong>Personnel</strong>, <strong>Mon Super Projet</strong> etc.';
catalog['This is the <strong>Contact\'s</strong> information. Add his <i>First name</i> and <i>Last name</i> as well as his <i>Role</i> (e.g. CEO, Product Manager, etc.).'] = 'Ce sont les informations sur le <strong>Contact</strong>. Ajoutez son <i>Pr\u00e9nom</i> et son <i>Nom</i> ainsi que son <i>R\u00f4le</i> (par exemple PDG, chef de produit, etc.)';
catalog['This is the <strong>Invoice</strong> transmitter, <i>Vosae</i> automatically makes it easier by filling it with your information.'] = 'C\'est l\'\u00e9metteur de la <strong>Facture</strong>, <i>Vosae</i> le remplit avec vos informations pour que se soit plus simple.';
catalog['This is the <strong>Organization\'s</strong> page. On this page <i>Vosae</i> lists all of your organizations. It\'s a useful way of sorting your contacts. You can view them by company or by group.'] = 'Ceci est la page des <strong>Organisations</strong>. Sur cette page <i>Vosae</i> liste toutes vos organisations. C\'est tr\u00e8s utile pour classer vos contacts. Vous pouvez les consulter par entreprise ou par groupe.';
catalog['This is the main view of your <strong>Organizer</strong>. <i>Vosae</i> displays all your upcoming events for the current month. You can easily add a new event by clicking on the day or time-slot of your choice. Once created, you can move it to a different slot by dragging and dropping. Simply click on any event to see all the details.'] = 'Il s\'agit de la vue principale de votre <strong>Agenda</strong>. <i>Vosae</i> affiche tous vos \u00e9v\u00e9nements \u00e0 venir pour le mois en cours. Vous pouvez facilement ajouter un nouvel \u00e9v\u00e9nement en cliquant sur le jour ou le cr\u00e9neau horaire de votre choix. Une fois cr\u00e9\u00e9, vous pouvez le d\u00e9placer sur une autre plage horaire par glisser-d\u00e9poser. Il vous suffit de cliquer sur n\'importe quel \u00e9v\u00e9nement pour voir ses d\u00e9tails.';
catalog['This is the most important part of a quotation. You can insert any item previously added in your <strong>Items</strong> page.'] = 'Il s\'agit de la partie la plus importante d\'un devis. Vous pouvez ins\u00e9rer n\'importe quel article pr\u00e9c\u00e9demment ajout\u00e9 dans votre partie <strong>Articles</strong>.';
catalog['This is the most important part of an invoice. You can insert any item previously added in your <strong>Items</strong> page.'] = 'Il s\'agit de la partie la plus importante d\'une facture. Vous pouvez ins\u00e9rer n\'importe quel article pr\u00e9c\u00e9demment ajout\u00e9 dans votre partie <strong>Articles</strong>.';
catalog['This is the name of the <strong>Organization</strong>. It\'s used in <strong>Quotations</strong> or <strong>Invoices</strong>.'] = 'C\'est le nom de l\'<strong>Organisation</strong>. Il est utilis\u00e9 pour les <strong>Devis</strong> et les <strong>Factures</strong>.';
catalog['This is the quotation transmitter, <i>Vosae</i> makes it quicker by automatically filling it with the relevant info.'] = 'Ceci est l\'\u00e9metteur du devis, <i>Vosae</i> le remplit automatiquement avec vos informations pour que se soit plus simple.';
catalog['This is your <strong>Invoicing</strong> dashboard. It is the main view for the <strong>Invoicing</strong> application.'] = 'Ceci est votre tableau de bord de <strong>Facturation</strong>. C\'est la page principale de votre application de <strong>Facturation</strong>.';
catalog['This provides an overview of your invoicing, accompanied by informative statistics.'] = 'Ceci donne un aper\u00e7u de votre facturation, accompagn\u00e9 de statistiques informatives.';
catalog['Timeline options'] = 'Options du flux d\'activit\u00e9s';
catalog['Timeline'] = 'Flux d\'activit\u00e9s';
catalog['Timezone'] = 'Fuseau horaire';
catalog['To <i>see all your contacts</i> just click on this link.'] = 'Pour voir <i>tous vos contacts</i> il suffit de cliquer sur ce lien.';
catalog['To define'] = '\u00c0 d\u00e9finir';
catalog['Today'] = 'Aujourd\'hui';
catalog['Total tax included'] = 'Total TTC';
catalog['Turkish lira'] = 'Livre turque';
catalog['Type your search here'] = 'Saisissez votre recherche ici';
catalog['Unit price'] = 'Prix unitaire';
catalog['United States dollar'] = 'Dollar am\u00e9ricain';
catalog['United States'] = '\u00c9tats-Unis';
catalog['Unknown'] = 'Inconnue';
catalog['Uploaded datas exceed file size'] = 'Les donn\u00e9es t\u00e9l\u00e9charg\u00e9es d\u00e9passent la taille du fichier';
catalog['Valid until (required field)'] = 'Valable jusqu\'au (champ obligatoire)';
catalog['Validity date'] = 'Date de validit\u00e9';
catalog['Want to change your settings, add a new organization, contact the <strong>Support</strong> or logout from <i>Vosae</i> ? This is the right place to click !'] = 'Vous voulez changer vos param\u00e8tres, ajouter une nouvelle organisation, contacter le <strong>Support</strong> ou vous d\u00e9connecter de <i>Vosae</i> ? C\'est le bon endroit !';
catalog['With <i>Vosae</i> you can invoice in a range of currencies. You just have to select the desired currency and <i>Vosae</i> will convert it.'] = 'Avec <i>Vosae</i> vous pouvez facturer dans de nombreuses devises. Vous avez juste \u00e0 s\u00e9lectionner la devise d\u00e9sir\u00e9e et <i>Vosae</i> va s\'occuper de la conversion.';
catalog['With <i>Vosae</i> you can make a quotation in a range of currencies. You just have to select the desired currency and <i>Vosae</i> will convert it.'] = 'Avec <i>Vosae</i> vous pouvez faire un devis dans de nombreuses devises. Vous avez juste \u00e0 s\u00e9lectionner la devise d\u00e9sir\u00e9e et <i>Vosae</i> va s\'occuper de la conversion.';
catalog['Work cell'] = 'Portable (travail)';
catalog['Work fax'] = 'Fax (travail)';
catalog['Work'] = 'Bureau';
catalog['Works at {{corporateName}}'] = 'Travaille \u00e0 {{corporateName}}';
catalog['Yes'] = 'Oui';
catalog['You can change which calendar the <strong>Event</strong> belongs to. If you have a lot of calendars just start typing the name and <i>Vosae</i> will pull it up for you.'] = 'Vous pouvez changer \u00e0 quel <strong>Agenda</strong> appartient l\'<strong>\u00c9v\u00e9nement</strong>. Si vous avez beaucoup d\'agenda commencez simplement \u00e0 \u00e9crire son nom et <i>Vosae</i> va le retrouver pour vous.';
catalog['You can choose the magnification of the display. The more you zoom, the more details you\'ll see.'] = 'Vous pouvez choisir le type d\'affichage. Plus vous zoomez, plus vous verrez de d\u00e9tails.';
catalog['You can choose to share your calendar with <strong><i>Vosae</i> users</strong>. It\'s for example very useful to work with your colleagues. You can set right to <strong>Read</strong>, <strong>Write</strong>, <strong>Own</strong> or <strong>None</strong>'] = 'Vous pouvez choisir de partager votre agenda avec <strong>des utilisateurs de <i>Vosae</i></strong>. C\'est par exemple tr\u00e8s utile pour travailler avec vos coll\u00e8gues. Vous pouvez d\u00e9finir le droit de <strong>Lire</strong>, <strong>\u00c9crire</strong>, de <strong>Propri\u00e9taire</strong> ou <strong>Aucun</strong>.';
catalog['You can easily navigate through your <strong>Applications</strong> by clicking on the icons.'] = 'Vous pouvez facilement naviguer dans vos <strong>Applications</strong> en cliquant sur \u200b\u200bles ic\u00f4nes.';
catalog['You can hide or reveal any app in the <i>Timeline</i>. It\'s very useful if you have a lot of informations displayed.'] = 'Vous pouvez masquer ou afficher n\'importe quelle application dans le <i>Flux d\'activit\u00e9s</i>. Cela est tr\u00e8s utile si vous avez beaucoup d\'informations affich\u00e9es.';
catalog['You can indicate a period or specific day for your <strong>Organizer</strong> to display by clicking on the arrows. If you want to go to today simply click on the middle button.'] = 'Vous pouvez choisir la p\u00e9riode ou un jour pr\u00e9cis pour votre <strong>Agenda</strong> en cliquant sur les fl\u00e8ches. Si vous voulez retourner \u00e0 aujourd\'hui, cliquez simplement sur le bouton du milieu.';
catalog['You can select a color for your calendar. This allows you to see it and find it faster.'] = 'Vous pouvez s\u00e9lectionner une couleur pour votre agenda. Cela vous permet de le voir et de le trouver plus rapidement.';
catalog['You can select a timezone for your calendar.'] = 'Vous pouvez s\u00e9lectionner le fuseau horaire de votre agenda.';
catalog['Your API key has been successfully created'] = 'Votre cl\u00e9 d\'API a \u00e9t\u00e9 correctement cr\u00e9\u00e9e';
catalog['Your API key has been successfully deleted'] = 'Votre cl\u00e9 d\'API a \u00e9t\u00e9 correctement supprim\u00e9e';
catalog['Your API key has been successfully updated'] = 'Votre cl\u00e9 d\'API a \u00e9t\u00e9 correctement mise \u00e0 jour';
catalog['Your calendar has been successfully created'] = 'Votre agenda a \u00e9t\u00e9 correctement cr\u00e9\u00e9';
catalog['Your calendar has been successfully deleted'] = 'Votre agenda a \u00e9t\u00e9 correctement supprim\u00e9';
catalog['Your calendar has been successfully updated'] = 'Votre agenda a \u00e9t\u00e9 correctement mis \u00e0 jour';
catalog['Your contact has been successfully created'] = 'Votre contact a \u00e9t\u00e9 correctement cr\u00e9\u00e9';
catalog['Your contact has been successfully deleted'] = 'Votre contact a \u00e9t\u00e9 correctement supprim\u00e9';
catalog['Your contact has been successfully updated'] = 'Votre contact a \u00e9t\u00e9 correctement mis \u00e0 jour';
catalog['Your credit note has been successfully created'] = 'Votre avoir a \u00e9t\u00e9 correctement cr\u00e9\u00e9';
catalog['Your credit note has been successfully deleted'] = 'Votre avoir a \u00e9t\u00e9 correctement supprim\u00e9';
catalog['Your credit note has been successfully updated'] = 'Votre avoir a \u00e9t\u00e9 correctement mis \u00e0 jour';
catalog['Your down payment invoice has been successfully created'] = 'Votre facture d\'acompte a \u00e9t\u00e9 correctement cr\u00e9\u00e9';
catalog['Your down payment invoice has been successfully deleted'] = 'Votre facture d\'acompte a \u00e9t\u00e9 correctement supprim\u00e9e';
catalog['Your down payment invoice has been successfully updated'] = 'Votre facture d\'acompte a \u00e9t\u00e9 correctement mise \u00e0 jour';
catalog['Your event has been successfully created'] = 'Votre \u00e9v\u00e9nement a \u00e9t\u00e9 correctement cr\u00e9\u00e9';
catalog['Your event has been successfully deleted'] = 'Votre \u00e9v\u00e9nement a \u00e9t\u00e9 correctement supprim\u00e9';
catalog['Your event has been successfully updated'] = 'Votre \u00e9v\u00e9nement a \u00e9t\u00e9 correctement mis \u00e0 jour';
catalog['Your invoice has been cancelled'] = 'Votre facture a \u00e9t\u00e9 annul\u00e9e';
catalog['Your invoice has been successfully created'] = 'Votre facture a \u00e9t\u00e9 correctement cr\u00e9\u00e9e';
catalog['Your invoice has been successfully deleted'] = 'Votre facture a \u00e9t\u00e9 correctement supprim\u00e9e';
catalog['Your invoice has been successfully updated'] = 'Votre facture a \u00e9t\u00e9 correctement mise \u00e0 jour';
catalog['Your item has been successfully created'] = 'Votre article a \u00e9t\u00e9 correctement cr\u00e9\u00e9';
catalog['Your item has been successfully deleted'] = 'Votre article a \u00e9t\u00e9 correctement supprim\u00e9';
catalog['Your item has been successfully updated'] = 'Votre article a \u00e9t\u00e9 correctement mis \u00e0 jour';
catalog['Your organization has been successfully created'] = 'Votre organisation a \u00e9t\u00e9 correctement cr\u00e9\u00e9e';
catalog['Your organization has been successfully deleted'] = 'Votre organisation a \u00e9t\u00e9 correctement supprim\u00e9e';
catalog['Your organization has been successfully updated'] = 'Votre organisation a \u00e9t\u00e9 correctement mise \u00e0 jour';
catalog['Your payment has been successfully added'] = 'Votre paiement a \u00e9t\u00e9 correctement ajout\u00e9';
catalog['Your quotation has been successfully created'] = 'Votre devis a \u00e9t\u00e9 correctement cr\u00e9\u00e9';
catalog['Your quotation has been successfully deleted'] = 'Votre devis a \u00e9t\u00e9 correctement supprim\u00e9';
catalog['Your quotation has been successfully updated'] = 'Votre devis a \u00e9t\u00e9 correctement mis \u00e0 jour';
catalog['Your quotation has been transformed into an invoice'] = 'Votre devis a \u00e9t\u00e9 transform\u00e9 en facture';
catalog['Zoom'] = 'Zoom';
catalog['_ (underscore)'] = '_ (tiret-bas)';
catalog['all-day'] = 'Jour';
catalog['attendee response statusConfirmed'] = 'Confirm\u00e9';
catalog['attendee response statusDeclined'] = 'D\u00e9clin\u00e9e';
catalog['attendee response statusMaybe'] = 'Peut-\u00eatre';
catalog['attendee response statusParticipation confirmed'] = 'Participation confirm\u00e9e';
catalog['attendee response statusParticipation declined'] = 'Participation d\u00e9clin\u00e9e';
catalog['attendee response statusParticipation uncertain'] = 'Participation incertaine';
catalog['attendee response statusParticipation unknown'] = 'Participation non renseign\u00e9e';
catalog['attendee response statusUnknown'] = 'Inconnue';
catalog['calendar acl rule rolecan edit events'] = 'Peut \u00e9diter les \u00e9v\u00e9nements';
catalog['calendar acl rule rolecan see events'] = 'Peut visualiser les \u00e9v\u00e9nements';
catalog['calendar acl rule rolehas no access'] = 'n\'a aucun acc\u00e8s';
catalog['calendar acl rule roleis owner'] = 'est propri\u00e9taire';
catalog['calendar colorNone'] = 'Aucune';
catalog['calendar list colorBlue'] = 'Bleu';
catalog['calendar list colorDark blue'] = 'Bleu fonc\u00e9';
catalog['calendar list colorDark green'] = 'Vert fonc\u00e9';
catalog['calendar list colorDark purple'] = 'Violet fonc\u00e9';
catalog['calendar list colorFluorescent green'] = 'Vert fluo';
catalog['calendar list colorGreen'] = 'Vert';
catalog['calendar list colorOrange'] = 'Orange';
catalog['calendar list colorPurple'] = 'Violet';
catalog['calendar list colorRed'] = 'Rouge';
catalog['dateundefined'] = 'non d\u00e9finie';
catalog['datevariable'] = 'variable';
catalog['day'] = 'jour';
catalog['dddd, MMMM D YYYY'] = 'dddd D MMMM YYYY';
catalog['invoiceMark as registered'] = 'Valider';
catalog['invoice stateCancelled'] = 'Annul\u00e9e';
catalog['invoice stateDraft'] = 'Brouillon';
catalog['invoice stateOverdue'] = 'En retard';
catalog['invoice statePaid'] = 'R\u00e9gl\u00e9e';
catalog['invoice statePart paid'] = 'Partiellement r\u00e9gl\u00e9e';
catalog['invoice stateRegistered'] = 'Valid\u00e9e';
catalog['month'] = 'mois';
catalog['payment conditions30 days end of month'] = '30 jours fin de mois';
catalog['payment conditions30 days end of month, the 10th'] = '30 jours fin de mois, le 10';
catalog['payment conditions30 days'] = '30 jours';
catalog['payment conditions45 days end of month'] = '45 jours fin de mois';
catalog['payment conditions45 days end of month, the 10th'] = '45 jours fin de mois, le 10';
catalog['payment conditions45 days'] = '45 jours';
catalog['payment conditions60 days end of month'] = '60 jours fin de mois';
catalog['payment conditions60 days end of month, the 10th'] = '60 jours fin de mois, le 10';
catalog['payment conditions60 days'] = '60 jours';
catalog['payment conditionsCash'] = 'Comptant';
catalog['payment conditionsCustom'] = 'Personalis\u00e9es';
catalog['payment methodBank transfer'] = 'Virement bancaire';
catalog['payment methodCash'] = 'Esp\u00e8ces';
catalog['payment methodCheck'] = 'Ch\u00e8que';
catalog['payment methodCredit card'] = 'Carte de cr\u00e9dit';
catalog['payment methodOther'] = 'Autre';
catalog['payment typeundefined'] = 'non d\u00e9fini';
catalog['quotationMark as approved'] = 'Marquer comme approuv\u00e9';
catalog['quotationMark as awaiting approval'] = 'Marquer comme en attente d\'approbation';
catalog['quotationMark as refused'] = 'Marquer comme refus\u00e9';
catalog['quotation stateApproved'] = 'Approuv\u00e9';
catalog['quotation stateAwaiting approval'] = 'En attente d\'approbation';
catalog['quotation stateDraft'] = 'Brouillon';
catalog['quotation stateExpired'] = 'Expir\u00e9';
catalog['quotation stateInvoiced'] = 'Factur\u00e9';
catalog['quotation stateRefused'] = 'Refus\u00e9';
catalog['reminder entryE-mail'] = 'E-mail';
catalog['reminder entryNotification'] = 'Notification';
catalog['time formath(:mm)t'] = 'H\'h\'(mm)';
catalog['time formath(:mm)tt'] = 'H\'h\'(mm)';
catalog['time formath:mm{ - h:mm}'] = 'H:mm{ - H:mm}';
catalog['undefined'] = 'non d\u00e9fini';
catalog['week'] = 'semaine';
catalog['{{role}} at {{corporateName}}'] = '{{role}} \u00e0 {{corporateName}}';


function gettext(msgid) {
  var value = catalog[msgid];
  if (typeof(value) == 'undefined') {
    return msgid;
  } else {
    return (typeof(value) == 'string') ? value : value[0];
  }
}

function ngettext(singular, plural, count) {
  value = catalog[singular];
  if (typeof(value) == 'undefined') {
    return (count == 1) ? singular : plural;
  } else {
    return value[pluralidx(count)];
  }
}

function gettext_noop(msgid) { return msgid; }

function pgettext(context, msgid) {
  var value = gettext(context + '\x04' + msgid);
  if (value.indexOf('\x04') != -1) {
    value = msgid;
  }
  return value;
}

function npgettext(context, singular, plural, count) {
  var value = ngettext(context + '\x04' + singular, context + '\x04' + plural, count);
  if (value.indexOf('\x04') != -1) {
    value = ngettext(singular, plural, count);
  }
  return value;
}

function interpolate(fmt, obj, named) {
  if (named) {
    return fmt.replace(/%\(\w+\)s/g, function(match){return String(obj[match.slice(2,-2)])});
  } else {
    return fmt.replace(/%s/g, function(match){return String(obj.shift())});
  }
}

/* formatting library */

var formats = new Array();

formats['DATETIME_FORMAT'] = 'j F Y H:i:s';
formats['DATE_FORMAT'] = 'j F Y';
formats['DECIMAL_SEPARATOR'] = ',';
formats['MONTH_DAY_FORMAT'] = 'j F';
formats['NUMBER_GROUPING'] = '3';
formats['TIME_FORMAT'] = 'H:i:s';
formats['FIRST_DAY_OF_WEEK'] = '1';
formats['TIME_INPUT_FORMATS'] = ['%H:%M:%S', '%H:%M'];
formats['THOUSAND_SEPARATOR'] = '\u00a0';
formats['DATE_INPUT_FORMATS'] = ['%d/%m/%Y', '%d/%m/%y', '%d.%m.%Y', '%d.%m.%y', '%Y-%m-%d'];
formats['YEAR_MONTH_FORMAT'] = 'F Y';
formats['SHORT_DATE_FORMAT'] = 'j N Y';
formats['SHORT_DATETIME_FORMAT'] = 'j N Y H:i:s';
formats['DATETIME_INPUT_FORMATS'] = ['%d/%m/%Y %H:%M:%S', '%d/%m/%Y %H:%M', '%d/%m/%Y', '%d.%m.%Y %H:%M:%S', '%d.%m.%Y %H:%M', '%d.%m.%Y', '%Y-%m-%d %H:%M:%S', '%Y-%m-%d %H:%M:%S.%f', '%Y-%m-%d %H:%M', '%Y-%m-%d'];

function get_format(format_type) {
    var value = formats[format_type];
    if (typeof(value) == 'undefined') {
      return format_type;
    } else {
      return value;
    }
}

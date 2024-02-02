public with sharing class ContactTriggerHelper {
    
    //! Prevent creating duplicate contact eith same Name and Email
    public static void duplicateContact(List<Contact> newContactList) {

        Map<String,Contact> newMapContact = new Map<String,Contact>();

        if (!newContactList.isEmpty()) {
            for (Contact con : newContactList) {

                if (con.Email != null && con.FirstName != null && con.LastName != null) {
                    newMapContact.put(con.Email, con);
                }
            }
        }
        //* Query the records
        if (!newMapContact.isEmpty()) {

            Map<String,Contact> mapExistingCon = new Map<String,Contact>();

            for (Contact oldContact : [SELECT FirstName, LastName, Email FROM Contact WHERE Email IN: newMapContact.keySet()]) {
                
                mapExistingCon.put(oldContact.Email, oldContact); 

                System.debug('map Detials :' + mapExistingCon);
            } 
            //* lopp through the contact records 
                for (String oldCon : mapExistingCon.keySet()) {

                    if (newMapContact.containsKey(oldCon) && (newMapContact.get(oldCon).FirstName == mapExistingCon.get(oldCon).FirstName) && (newMapContact.get(oldCon).LastName == mapExistingCon.get(oldCon).LastName)) {
                        
                        newMapContact.get(oldCon).FirstName.addError('Duplicate contact with same first name');
                        newMapContact.get(oldCon).LastName.addError('Duplicate contact with same Last name');
                        newMapContact.get(oldCon).Email.addError('Duplicate contact with same Email');
                    } 

            }
            
        }
    }
    //! Check account active__c field before creating a new contact
    public static void stopCreatingNewContactAcountInactive(List<Contact> newContactList) {
        Map<Id,Contact> mapContact = new Map<Id,Contact> (); //* Collect the account id as key
        
        if (!newContactList.isEmpty()) {
            for (Contact newCon : newContactList) {
                //*condition 
                if (newCon.AccountId != Null) {
                    
                    mapContact.put(newCon.AccountId, newCon);
                    
                }
            }
        }
        //* Query the account field
        List<Account> queyAccount = [SELECT Id, Active__c FROM Account WHERE Id IN:mapContact.keySet() WITH USER_MODE];
        if (!queyAccount.isEmpty()) {
            //* Loop through accounts 
            for (Account acc : queyAccount) {
                //* Condition to check
                if (acc.Active__c == 'No') {

                    mapContact.get(acc.Id).addError('You can\'t create Contact on inactive account');
                }
            }

        }
    }
    //!Update the contact FAX field with phone number
    public static void upfateFax(List<Contact> newContactList) {
        
        if (!newContactList.isEmpty()) {
            //* loop through the list
            for (Contact newCon : newContactList) {
                //*Check the condition
                if (newCon.Phone != null) {
                    newCon.Fax = newCon.Phone;
                }
            }
        }
    }
    //! Populate the billing and mailing address from account
    public static void updateMailingBillingFromAccount(List<Contact> newContactList){

        Map<Id,Contact> mapContactsAccountId = new Map<Id,Contact>(); //* Declare the map to collect accId as key

        if (!newContactList.isEmpty()) {
            //* Loop through the records
            for (Contact newCon : newContactList) {
                //* Check for the condition
                if (newCon.AccountId != Null) {
                    mapContactsAccountId.put(newCon.AccountId, newCon);
                }
            }
        }
        if (!mapContactsAccountId.isEmpty()) {
            //* Query all the fields from the account
            List<Account> listAccountAddress = [SELECT Id, ShippingStreet, ShippingCountry, ShippingState, ShippingPostalCode, ShippingCity, 
                                                BillingCity, BillingCountry, BillingState, BillingStreet, BillingPostalCode FROM Account 
                                                WHERE Id IN:mapContactsAccountId.keySet()];
            //*Loop through the list
            for (Account accAddress : listAccountAddress) {
                //* Contact Shipping address
                mapContactsAccountId.get(accAddress.Id).MailingStreet     = accAddress.ShippingStreet;
                mapContactsAccountId.get(accAddress.Id).MailingCity       = accAddress.ShippingCity;
                mapContactsAccountId.get(accAddress.Id).MailingCountry    = accAddress.ShippingCountry;
                mapContactsAccountId.get(accAddress.Id).MailingPostalCode = accAddress.ShippingPostalCode;
                mapContactsAccountId.get(accAddress.Id).MailingState      = accAddress.ShippingState;
                //* Contact Other Address
                mapContactsAccountId.get(accAddress.Id).OtherCountry      = accAddress.BillingCountry;
                mapContactsAccountId.get(accAddress.Id).OtherCity         = accAddress.BillingCity;
                mapContactsAccountId.get(accAddress.Id).OtherState        = accAddress.BillingState;
                mapContactsAccountId.get(accAddress.Id).OtherPostalCode   = accAddress.BillingPostalCode;
                mapContactsAccountId.get(accAddress.Id).OtherStreet       = accAddress.BillingStreet;

            }
        }
    }
    //! Update the account information on the Opportunity
    
    public static void updateAccountDetialsOnOpportunity(List<Contact> newContactList, Map<Id,Contact> newContactMap) {
        Map<Id,Contact> mapContactAccId = new Map<Id,Contact>(); //* Collect the contacts with accId as key

        if (!newContactList.isEmpty()) {
            
            for (Contact newCon : newContactList) {
                //* Check the accountID != null
                if (newCon.AccountId != null) {
                    mapContactAccId.put(newCon.AccountId , newCon);   
                }

            }
        }
        //* Query the opportunities for the account Id
        if (!mapContactAccId.isEmpty()) {
            
            List<Opportunity> listOpps = [SELECT Id, AccountId, Account.Name, Account.Industry, Account.Rating, Account.Phone  FROM Opportunity WHERE AccountId IN: mapContactAccId.keySet() WITH USER_MODE];
                        
            //* Loop through listOpps to upda the fields
            if (!listOpps.isEmpty()) {
                for (Opportunity updateOpp : listOpps) {
                    if (updateOpp.AccountId != Null) {
                        
                        updateOpp.Account_Rating__c   = updateOpp.Account.Rating;
                        updateOpp.Account_Industry__c = updateOpp.Account.Industry;
                        updateOpp.Account_Name__c     = updateOpp.Account.Name;
                        updateOpp.Account_Phone__c    = updateOpp.Account.Phone;
                        
                    }
                    
                }
            }
        //* Update the opportuntiy list 
        try {
            update as user listOpps;
        } catch (System.DmlException dmlExp) {

            List<System_Event__c> listErrros = new List<System_Event__c>(); //* add the error to the system event object

            for (Integer i = 0; i < dmlExp.getNumDml(); i++) {

                System_Event__c errorRecord = Logger.loggError(dmlExp.getStackTraceString(), dmlExp.getMessage(), dmlExp.getDmlId(i));
                listErrros.add(errorRecord);
            }
            
            insert as user listErrros;
        }

        } 
        
    }
    //! update the contact Active field
    public static void updateActiveStatusFromAccount(List<Contact> newContactList) {
        Map<Id,Contact> mapConAccId = new Map<Id,Contact>(); //* Collect the account ids
        if (!newContactList.isEmpty()) {
            
            for (Contact con : newContactList) {
                //* Collect the accid
                if (con.AccountId != null) {
                    mapConAccId.put(con.AccountId, con);
                }
            }
        }
        //* Query the account field to update contact
        for (Account acc : [SELECT Id, Active__c FROM Account WHERE Id IN:mapConAccId.keySet()]) {
            
            if (acc.Active__c != Null) {

                mapConAccId.get(acc.Id).Active__c = acc.Active__c;
            }
        }
    }
}
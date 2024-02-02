public with sharing class ContactTriggerHandler {
    //* Before Insert
    public static void handleBeforeInsert(List<Contact> newContactList) {

        ContactTriggerHelper.upfateFax(newContactList); //* Update the contact FAX field with phone number
        ContactTriggerHelper.updateMailingBillingFromAccount(newContactList); //* Fill the contact address
        ContactTriggerHelper.stopCreatingNewContactAcountInactive(newContactList);//* Stop contact creation
        ContactTriggerHelper.updateActiveStatusFromAccount(newContactList);//* Update Active status on contact
        ContactTriggerHelper.duplicateContact(newContactList);//* Stop creating duplicate contact
    }
    //* Before Update
    public static void handleBeforeUpdate(List<Contact> newContactList) {
        ContactTriggerHelper.upfateFax(newContactList); //* Update the contact FAX field with phone number
    }
    //* After Insert
    public static void handleAfterInsert(List<Contact> newContactList, Map<Id,Contact> newContactMap) {
        ContactTriggerHelper.updateAccountDetialsOnOpportunity(newContactList, newContactMap);

        //* Update the account nuber of contacts field
        Set<Id> setAccId = new Set<Id>(); //* Collect the account Ids
        if(!newContactMap.isEmpty()) {
            for (Contact con : newContactMap.values()) {
                //* Condition to check 
                if (con.AccountId != null) {
                    setAccId.add(con.AccountId);
                }
            }
            ContactTriggerHelper.updateAccountContacts(setAccId); //* call the helper class
        }
        
    }
    //* After Update
    public static void handleAfterUpdate(Map<Id,Contact> newContactMap, Map<Id,Contact> oldContactMap) {
        
        //*Update the number of contacts on Account
        Set<Id> setAccId = new Set<Id>();//* Collect the account Id's
        if (!newContactMap.values().isEmpty()) {
            for (Contact con : newContactMap.values()) {
                //* Condition to check
                if (con.AccountId != oldContactMap.get(con.Id).AccountId) {

                    setAccId.add(con.AccountId);
                    setAccId.add(oldContactMap.get(con.Id).AccountId);
                }
            }
            ContactTriggerHelper.updateAccountContacts(setAccId); //* Call the helper class
        }
        
    }
}
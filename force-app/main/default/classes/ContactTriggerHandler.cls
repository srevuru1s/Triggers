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
    public static void handleAfterInsert(List<Contact> newContactList, Map<id,Contact> newContactMap) {
        ContactTriggerHelper.updateAccountDetialsOnOpportunity(newContactList, newContactMap);
    }
}
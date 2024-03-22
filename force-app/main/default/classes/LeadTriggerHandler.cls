/**
 * @description       : 
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @group             : 
 * @last modified on  : 03-21-2024
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
**/
public with sharing class LeadTriggerHandler {
  
  public static void handleBeforeInsert(List<Lead> newListLead) {
    //! Check for duplicates
    LeadTriggerHelper.checkDuplicateLead(newListLead);

    //! Update the lead Matching Account
    if (newListLead?.isEmpty()) 
      return;
    List<String> leadCompany = new List<String>();
    //* Loop through the lead record
    for (Lead newLead : newListLead) {
        leadCompany.add(newLead.Company);
    }
    
    //* Collect the records 
    Map<String, Account> existingAccountRecord = new Map<String, Account>(); 

    //* Query the existing records
    for (Account acc : [SELECT Id, Name FROM Account WHERE Name IN :leadCompany WITH USER_MODE LIMIT 50000]) {
        existingAccountRecord.put(acc.Name, acc);               
    }
    //* Loop through the new records records
    if (!existingAccountRecord.isEmpty()) {
        
        for (Lead newLead : newListLead) {
        //* check the condition
          if (existingAccountRecord.containsKey(newLead.Company)) {
              newLead.Matching_Account__c = existingAccountRecord.get(newLead.Company).Id;
          }
      }
    }
  }
}
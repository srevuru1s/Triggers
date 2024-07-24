/**
 * @description       : 
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @group             : 
 * @last modified on  : 07-03-2024
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

  public static void handleBeforeUpdate(List<Lead> newListLead, Map<Id,Lead> mapOldLeads) {

    Map<String,String> updatedLeads = new Map<String,String>(); //* collcet the new updated leads

    if (newListLead?.isEmpty()) {
      return;
    } else {
      for (Lead newLead : newListLead) {
        if (newLead.Email != mapOldLeads.get(newLead.Id).Email || newLead.Company != mapOldLeads.get(newLead.Id).Company) {

          updatedLeads.put(newLead.Email, newLead.Company);
        }
      }
    }      
    
    //* Query the records 
    if (!updatedLeads.isEmpty()) {
      Map<String,Lead> existingLeadRecords = new Map<String,Lead>(); //* collect the old leads
      //* Loop Through the records
      for (Lead oldLeads : [SELECT Id, Name, Company, Email FROM Lead
                                                          WHERE Email IN: updatedLeads.keySet() AND Company IN: updatedLeads.values() AND Id NOT IN : newListLead
                                                          WITH USER_MODE LIMIT 50000]) {

          existingLeadRecords.put(oldLeads.Email, oldLeads);                                                    

          }

      //* Calling duplicate check method 
      LeadTriggerHelper.duplicateLeadCheck(newListLead, existingLeadRecords);  

    }
  }
  
  public static void handleAfterDelete(Map<Id, Lead> mapNewLeads) {

    if (!mapNewLeads.isEmpty()) {
      
        //* calling the before insert method
        LeadTriggerHelper.checkDuplicateLead(mapNewLeads.values());
    }
  } 
}
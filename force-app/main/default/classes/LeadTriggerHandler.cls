public with sharing class LeadTriggerHandler {
    public static void handleBeforeInsert(List<Lead> newListLead) {
        
        if (newListLead.isEmpty()) return;

        Map<Id,Lead> mapLeadRecords = new Map<Id,Lead>(); //* Collect lead records
        List<String> listEmail = new List<String>();      //* lead names
        List<String> listCompany = new List<String>();    //* lead email

        //* Loop through the records
        for (Lead newLead : newListLead) {

            if(newLead.Email != null && newLead.Company != null) {

                listEmail.add(newLead.Email);
                listCompany.add(newLead.Company);
                mapLeadRecords.put(newLead.Id, newLead);
            }
        }
        
        //*Query the existing records
        List<Lead> existingLeadRecords = [SELECT Id, Email, Company From Lead WHERE Email IN:listEmail AND Company IN:listCompany WITH USER_MODE LIMIT 50000];
        List<String> listOldLeadCompany = new List<String>();//* Old lead company
        List<String> listOldLeadEmail   = new List<String>(); //* old lead email
        
        if (!existingLeadRecords.isEmpty()) {
            //*Loop through old records
            for (Lead oldLead : existingLeadRecords) {
            
                listOldLeadCompany.add(oldLead.Company);
                listOldLeadEmail.add(oldLead.Email);
            }    
        } 
            //* Loop through the new records
            for (Lead newLead : mapLeadRecords.values()) {
                //*Duplicate lead check
                if (listOldLeadEmail.contains(newLead.Email) && listOldLeadCompany.contains(newLead.Company)) {
                    newLead.Email.addError('Duplicate lead with same email');
                    newLead.Company.addError('Duplicate lead with same company');
                } else {
                    existingLeadRecords.add(newLead);
                }
            } 
    }
}
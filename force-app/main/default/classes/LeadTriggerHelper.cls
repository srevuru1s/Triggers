/**
 * @description       : 
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @group             : 
 * @last modified on  : 03-21-2024
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
**/
public with sharing class LeadTriggerHelper {

    //* Duplicate check 

    public static void checkDuplicateLead(List<Lead> newListLead) {
        
        if (newListLead?.isEmpty())
        return;

        
        List<String> listEmail = new List<String>(); //* lead names
        List<String> listCompany = new List<String>(); //* lead email

        //* Loop through the records
        for (Lead newLead : newListLead) {
            if (newLead.Email != null && newLead.Company != null) {
                listEmail.add(newLead.Email);
                listCompany.add(newLead.Company);
                
            }
        }
        //*Query the existing records
        List<Lead> existingLeadRecords = [
            SELECT Id, Email, Company
            FROM Lead
            WHERE Email IN :listEmail AND Company IN :listCompany
            WITH USER_MODE
            LIMIT 50000
        ];
        List<String> listOldLeadCompany = new List<String>(); //* Old lead company
        List<String> listOldLeadEmail = new List<String>(); //* old lead email

        if (!existingLeadRecords.isEmpty()) {
            //*Loop through old records
            for (Lead oldLead : existingLeadRecords) {
            listOldLeadCompany.add(oldLead.Company);
            listOldLeadEmail.add(oldLead.Email);
            }
        }
        //* Loop through the new records
        for (Lead newLead : newListLead) {
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
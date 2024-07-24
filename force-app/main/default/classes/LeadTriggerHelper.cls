/**
 * @description       : 
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @group             : 
 * @last modified on  : 07-05-2024
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
**/
public with sharing class LeadTriggerHelper {

    //* Duplicate check 
    public static void checkDuplicateLead(List<Lead> newListLead) {
        
        Map<String,String> newMapLeads = new Map<String, String>(); //* Collect the new lead records

        //* Loop through the records
        for (Lead newLead : newListLead) {
            if (!String.isEmpty(newLead.Email) && !String.isEmpty(newLead.Company)) {       
                //* adding the new leads to Map
                newMapLeads.put(newLead.Email, newLead.Company);
            }
            Integer mapIteams = newMapLeads.size();
        }

        //*Query the existing records
        Map<String,Lead> existingMapLeadRecords = new Map<String, Lead>(); //* Lead map records

        for (Lead existingLead : [SELECT Id, Email, Company
                                    FROM Lead
                                    WHERE Email IN :newMapLeads.keySet() AND Company IN :newMapLeads.values() AND Id NOT IN : newListLead
                                    WITH USER_MODE
                                    LIMIT 50000]) {          
                existingMapLeadRecords.put(existingLead.Email, existingLead); //* add to the map
            }
        //? Calling the duplicate check method
        duplicateLeadCheck(newListLead, existingMapLeadRecords);
        

    }

    //* Dupplicate check conditions
    public static void duplicateLeadCheck(List<Lead> listLeads, Map<String, Lead> existingMapLeads) {

        for (Lead newLead : listLeads) {
        
            if (existingMapLeads.containsKey(newLead.Email) && existingMapLeads.get(newLead.Email).Company == newLead.Company) {

                newLead.addError('Duplicate Lead Record');
                newLead.Email.addError('Ducplicate Email Id');
                newLead.Company.addError('Ducplicate Company Name');
            } else {
                existingMapLeads.put(newLead.Email, newLead);
            }
        }  

    }
}
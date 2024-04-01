/**
 * @description       : 
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @group             : 
 * @last modified on  : 03-30-2024
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
**/
public with sharing class CaseEnumSwitch {
    
    public static void updateCaseStatus (Id caseId, CaseEnum.Status status) {

        //* Query the Case
        Case ecase = [SELECT Id, Status__c FROM Case WHERE Id =: caseId LIMIT 1];
        String caseStatus;
        switch on status {
            when CANCELED {
                caseStatus = 'Closed';
            }
            when DELETED {
                caseStatus = 'Deleted';
            }
            when ACTIVE {
                caseStatus = 'Active';
            }
        }
        ecase.Status__c = caseStatus;
        update as USER eCase;
    }
}
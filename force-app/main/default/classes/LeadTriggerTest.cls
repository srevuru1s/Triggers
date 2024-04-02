@isTest
public with sharing class LeadTriggerTest {
    
    @TestSetup
    public static void makeData(){
        
        Lead leadRecord = new Lead();

        leadRecord.FirstName = 'Industry';
        leadRecord.LastName  = 'CRM';
        leadRecord.Company   = 'Salesforce';
        leadRecord.Email     = 'salesforce@mail.com';
  
        insert leadRecord;
    }
    //*Before insert test
    @isTest
    public static void beforeInsert() {
        
        Test.startTest();
        Lead leadRecord = new Lead();
        leadRecord.FirstName = 'Industry';
        leadRecord.LastName  = 'CRM';
        leadRecord.Company   = 'Salesforce';
        leadRecord.Email     = 'salesforce@mail.com';
        
        try {
            insert leadRecord; 
               
        } catch (Exception allExp) { 
        }
        Test.stopTest();
    }
}
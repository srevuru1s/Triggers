public with sharing class OpportunityTriggerHelper {
    
    //! if the Discount & Amount field is not blank then calculate the discount
    public static void discountClaculation(List<Opportunity> newOppList) {

        if (!newOppList.isEmpty()) {
            //*Loop through the records
            for (Opportunity newOpp : newOppList) {
                
                //* check the condition
                if (newOpp.Discount__c != Null) {
                    
                    Decimal discount             = (newOpp.Discount__c * newOpp.Amount)/100;
                    newOpp.Discounted_Price__c   = (newOpp.Amount-discount);
                }
            }
        }
    }
    //! Create a Task record to Opp when the account is blank
    public static void opportunityTaskCreation(List<Opportunity> newOppList) {
        List<Task> listTask = new List<Task>(); //* List of task record

        if (!newOppList.isEmpty()) {
            //*loop through the records
            for (Opportunity newOpp : newOppList) {
                //* Condition check
                if (newOpp.AccountId == null) {
                    Task newTask = new Task();
                    newTask.Description     = 'Opportunity is created without Account please assign an account';
                    newTask.Subject         = 'Opportunity is created without Account';
                    newTask.ActivityDate    = System.today().addDays(7);
                    newTask.Status          = Null;
                    newTask.WhatId          = Null;
                    newTask.OwnerId         = Null;

                    listTask.add(newTask);
                }
            }
        }
        if (!listTask.isEmpty()) {
            try {
                insert as user listTask;
            } catch (System.DmlException dmlExp) {
                
                List<System_Event__c> listErrros = new List<System_Event__c>(); //* add the error to the system event object

                for (Integer i = 0; i < dmlExp.getNumDml(); i++) {

                    System_Event__c errorRecord = Logger.loggError(dmlExp.getStackTraceString(), dmlExp.getMessage(), dmlExp.getDMLId(i));
                    listErrros.add(errorRecord);
                }
                
                insert as user listErrros;
            }
        }
    }
    //! Update Opp Active field from Account
    public static void addActiveStatus(List<Opportunity> newOppList) {
        
        Map<Id,Opportunity> mapOppAccId = new Map<Id,Opportunity>(); //* Collect the opps with accid

        if (!newOppList.isEmpty()) {
            for (Opportunity opp : newOppList) {
                if (opp.AccountId != Null) {
                    mapOppAccId.put(opp.AccountId, opp);
                }
            }
        }
        //*Query the account field
        if (!mapOppAccId.isEmpty()) {
            
            for (Account acc : [SELECT Id, Active__c FROM Account WHERE Id IN: mapOppAccId.keySet()]) {
                if (acc.Active__c != Null) {
                    
                    mapOppAccId.get(acc.Id).Active__C = acc.Active__c;
                }
            }
        }
    }
    //! Update the amount field to 1000 if it is blank
    public static void updateOppAmount(List<Opportunity> newOppList) {
        Set<Id> oppIds = new Set<Id>();//* opp that need to updated
        if (!newOppList.isEmpty()) {
            for (Opportunity opp : newOppList) {
                
                if (opp.Account == Null) {
                    oppIds.add(opp.Id);
                }
            }
        }
        //* Query the opp fields to update
        List<Opportunity> oppsNeedToUpdate = new List<Opportunity>();

        for (Opportunity updateOpp : [SELECT Id, Amount FROM Opportunity WHERE Id IN:oppIds WITH USER_MODE]) {
            if (updateOpp.Amount == Null) {
                
                updateOpp.Amount = 1000;
                oppsNeedToUpdate.add(updateOpp);
            }
        }
        if (!oppsNeedToUpdate.isEmpty()) {
            try {
                update as user oppsNeedToUpdate;
            } catch (System.DmlException dmlExp) {
                
                List<System_Event__c> listErrros = new List<System_Event__c>(); //* add the error to the system event object

                for (Integer i = 0; i < dmlExp.getNumDml(); i++) {

                    System_Event__c errorRecord = Logger.loggError(dmlExp.getStackTraceString(), dmlExp.getMessage(), dmlExp.getDMLId(i));
                    listErrros.add(errorRecord);
                }
                
                insert as user listErrros;
            }
        }
        
    }
}
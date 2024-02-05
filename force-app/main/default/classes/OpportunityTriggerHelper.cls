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
    //! Update the Account with Opp Amount 
    public static void updateOppAmountOnAccount(Map<Id,Opportunity> mapNewOpp) {
        
        List<Account> listOpenOppAmountAccount = new List<Account>();//* Collect the accounts to update open opp Amount
        List<Account> listClosedOppAmountAccount = new List<Account>();//* Collect the accounts to update closed opp Amount
        if (!mapNewOpp.isEmpty()) {
            //* Query the Opportunity Amounts closed and Open
            List<AggregateResult> closedOppAggresult = [SELECT SUM(Amount) totalClosedAmount, AccountId FROM Opportunity WHERE AccountId IN: mapNewOpp.keySet() AND 
                                                        StageName NOT IN ('Closed Lost', 'Closed Won') WITH USER_MODE GROUP BY AccountId LIMIT 50000];
            
            List<AggregateResult> openOppdAggresult  = [SELECT SUM(Amount) totalOpenAmount, AccountId FROM Opportunity WHERE AccountId IN: mapNewOpp.keySet() AND 
                                                        StageName IN ('Closed Lost', 'Closed Won') WITH USER_MODE GROUP BY AccountId LIMIT 50000];

            //* First Loop closed Amount
            if (!closedOppAggresult.isEmpty()) {
                //* Loop through the records
                for (AggregateResult aggResult : closedOppAggresult) {
                    
                    Decimal amount = (Decimal) aggResult.get('totalClosedAmount');
                    Id accId       = (Id) aggResult.get('AccountId');

                    Account updateAcc                      = new Account();
                    updateAcc.Id                           = accId;
                    updateAcc.Sum_of_Closed_Opportunity__c = amount;
                    
                    listClosedOppAmountAccount.add(updateAcc);
                }
            }
            //* Second Loop for open Opp's Amount     
            if (!openOppdAggresult.isEmpty()) {
                //* Loop through the records
                for (AggregateResult aggResult : openOppdAggresult) {
                    
                    Decimal amount = (Decimal) aggResult.get('totalOpenAmount');
                    Id accId       = (Id) aggResult.get('AccountId');


                    Account updateAcc                      = new Account();
                    updateAcc.Id                           = accId;
                    updateAcc.Sum_of_Open_Opportunity__c   = amount;
                    
                    listOpenOppAmountAccount.add(updateAcc);
                }
            }                                      
            
            if ((!listOpenOppAmountAccount.isEmpty()) || (!listClosedOppAmountAccount.isEmpty())) {
                try {
                    update as user listOpenOppAmountAccount;
                    update as user listClosedOppAmountAccount;
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

    //!Update the opp new Owner in the description
    public static void updateOppNewOwner(List<Opportunity> newOppList, Map<Id,Opportunity> oldMapOpp) {
        Map<Id,Opportunity> newOwnerOpp = new Map<Id,Opportunity>(); //* collect the opps with new Owner
        if (!newOppList.isEmpty()) {
            
            for (Opportunity opp : newOppList) {
                if (opp.OwnerId != null && opp.OwnerId != oldMapOpp.get(opp.Id).OwnerId) {
                    
                    newOwnerOpp.put(opp.OwnerId, opp);
                }
            }
        }
        //* Loop through the new Opps
        if (!newOwnerOpp.isEmpty()) {
            //* Query the user records to get the name and email of the owner
            Map<Id,User> listUserDetails = new Map<Id,User>([SELECT Id, Name, Email FROM User WHERE Id IN: newOwnerOpp.keySet() WITH USER_MODE LIMIT 50000]);

            for (Opportunity newOpp : newOwnerOpp.values()) {

                    newOpp.Description = listUserDetails.get(newOpp.OwnerId).Name + listUserDetails.get(newOpp.OwnerId).Email;

            }
        }
    }
}
/**
 * @description       : 
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @group             : 
 * @last modified on  : 02-16-2024
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
**/
public with sharing class OpportunityTriggerHelper {
    
    //! if the Discount & Amount field is not blank then calculate the discount
    public static void discountClaculation(List<Opportunity> newOppList) {
        if (!newOppList.isEmpty()) return;
         
            //*Loop through the records
            for (Opportunity newOpp : newOppList) {
                
                //* check the condition
                if (newOpp.Discount__c != Null) {
                    
                    Decimal discount             = (newOpp.Discount__c * newOpp.Amount)/100;
                    newOpp.Discounted_Price__c   = (newOpp.Amount-discount);
                  
                }
            }
        
    }
    //! Create a Task record to Opp when the account is blank
    public static void opportunityTaskCreation(List<Opportunity> newOppList) {
        
        if (newOppList.isEmpty()) return; 
        List<Task> listTask = new List<Task>(); //* List of task record

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
        //* DML on Records    
        if (!listTask.isEmpty()) {
            try {
                insert as user listTask;
            } catch (DmlException dmlExp) {
                Logger.triggererror(dmlExp);
            } catch (Exception allExp) {
                Logger.triggerAllErrors(allExp);
            }
        }
    }
    //! Update Opp Active field from Account
    public static void addActiveStatus(List<Opportunity> newOppList) {
        if (newOppList.isEmpty()) return;

        Map<Id,Opportunity> mapOppAccId = new Map<Id,Opportunity>(); //* Collect the opps with accid
        //* Loop through the records
            for (Opportunity opp : newOppList) {
                if (opp.AccountId != Null) {
                    mapOppAccId.put(opp.AccountId, opp);
                    
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
        if (newOppList.isEmpty()) return;

        Set<Id> oppIds = new Set<Id>();//* opp that need to updated
            //* loop through the records    
            for (Opportunity opp : newOppList) {
                if (opp.Account == Null) {
                    oppIds.add(opp.Id);
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
            } catch (DmlException dmlExp) {
                Logger.triggererror(dmlExp);
            } catch (Exception allExp) {
                Logger.triggerAllErrors(allExp);
            }
        }  
    }
    //! Update the Account with Opp Amount 
    public static void updateOppAmountOnAccount(Map<Id,Opportunity> mapNewOpp) {
        if (mapNewOpp.isEmpty()) return;

        Set<Id> openOppAccId    = new Set<Id>(); //* collect the open opps account Id
        Set<Id> closedOppAccId  = new Set<Id>(); //* collect the closed opps account Id
            //* Loop through the opps to run the query 
            for (Opportunity opp : mapNewOpp.values()) {

                if(opp.StageName != 'Closed Lost' && opp.StageName != 'Closed Won') {
                    openOppAccId.add(opp.AccountId);   
                } else {    
                    closedOppAccId.add(opp.AccountId);
                }
                
            }

            //* Query the open Opportunity Amounts 
            List<Account> listOpenOppAmountAccount = new List<Account>();//* Collect the accounts to update open opp Amount
            
            if (!openOppAccId.isEmpty()) {
            
                List<AggregateResult> openOppdAggresult  = [SELECT SUM(Amount) totalOpenAmount, AccountId FROM Opportunity WHERE AccountId IN: openOppAccId 
                                                            WITH USER_MODE GROUP BY AccountId LIMIT 50000]; 
                //* Loop through the agg results
                for (AggregateResult aggResult : openOppdAggresult) {
                    
                    Decimal amount = (Decimal) aggResult.get('totalOpenAmount');
                    Id accId       = (Id) aggResult.get('AccountId');

                    Account updateAcc                      = new Account();
                    updateAcc.Id                           = accId;
                    updateAcc.Sum_of_Open_Opportunity__c   = amount;
                    
                    listOpenOppAmountAccount.add(updateAcc);
                }
            }
            //* Query the closed Opportunity Amount
            List<Account> listClosedOppAmountAccount = new List<Account>();//* Collect the accounts to update closed opp Amount
            
            if(!closedOppAccId.isEmpty()) {
                List<AggregateResult> closedOppAggresult = [SELECT SUM(Amount) totalClosedAmount, AccountId FROM Opportunity WHERE AccountId IN: closedOppAccId
                                                             WITH USER_MODE GROUP BY AccountId LIMIT 50000];

                //* Loop through the aggresults
                for (AggregateResult aggResult : closedOppAggresult) {
                    
                    Decimal amount = (Decimal) aggResult.get('totalClosedAmount');
                    Id accId       = (Id) aggResult.get('AccountId');

                    Account updateAcc                      = new Account();
                    updateAcc.Id                           = accId;
                    updateAcc.Sum_of_Closed_Opportunity__c = amount;
                    
                    listClosedOppAmountAccount.add(updateAcc);
                }
            }
            
            //* Bulkify the code to insert/update the account reords                              
            
            if ((!listOpenOppAmountAccount.isEmpty()) || (!listClosedOppAmountAccount.isEmpty())) {
                try {
                    update as user listOpenOppAmountAccount;
                    update as user listClosedOppAmountAccount;
                } catch (DmlException dmlExp) {
                    
                    Logger.triggererror(dmlExp);
                } catch (Exception allExp) {
                    Logger.triggerAllErrors(allExp);
                }
            }
        
    }

    //!Update the opp new Owner in the description
    public static void updateOppNewOwner(List<Opportunity> newOppList, Map<Id,Opportunity> oldMapOpp) {
        if (newOppList.isEmpty()) return;
        Map<Id,Opportunity> newOwnerOpp = new Map<Id,Opportunity>(); //* collect the opps with new Owner
                    
            for (Opportunity opp : newOppList) {
                if (opp.OwnerId != null && opp.OwnerId != oldMapOpp.get(opp.Id).OwnerId) {
                    
                    newOwnerOpp.put(opp.OwnerId, opp);
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
    //!Add sales Rep field on the Opp
    public static void addSalesRepName(List<Opportunity> newOppList) {
        if(newOppList.isEmpty()) return;
        Map<Id,Opportunity> mapOpp = new Map<Id,Opportunity>();//* collect the opps that need to be updated
        
            for (Opportunity opp : newOppList) {
                if(opp.Sales_Representative__c == null) {
                    mapOpp.put(opp.Id, opp);
                }
            }
    
        //* Loop Through the Map
        List<Opportunity> listOppsToUpdate = new List<Opportunity>(); //* collect the opps
        if (!mapOpp.isEmpty()) {
            for (Opportunity opp : mapOpp.values()) {
                
                Opportunity newOpp = new Opportunity();
                newOpp.Sales_Representative__c = opp.OwnerId;
                newOpp.Id                      = opp.Id;
                listOppsToUpdate.add(newOpp);
            }
        }
        if (!listOppsToUpdate.isEmpty()) {
            try {
                update as user listOppsToUpdate;
                
            } catch (DmlException dmlExp) {
                Logger.triggererror(dmlExp);    
            } catch (Exception allExp) {
                Logger.triggerAllErrors(allExp);
            }
        
       Integer totalDML = Limits.getLimitDmlStatements();
       System.debug('Total DMLS:' + totalDML);
       Integer executedDMLs = Limits.getDmlStatements();
       System.debug('Executed DMLS:' + executedDMLs);
       
    }
}
}
/**
 * @description       : 
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @group             : 
 * @last modified on  : 04-09-2024
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
**/
public with sharing class AccountTriggerHandler {

    //* Before Insert
    public static void handleBeforeInsert(List<Account> newAccountList) {
        AccountTriggerHelper.accountDuplicateCheck(newAccountList); //! prevent duplication
        AccountTriggerHelper.helperBeforeInsertUpdate(newAccountList);//!Set the account Billing Address to shipping address
        //! Set the account field to Industry and if Description is blank then "Account Description is blank"
        if (!newAccountList.isEmpty()) {
            //* Loop through the accounts 
            for (Account acc : newAccountList) {
                //* check for the condition 
                acc.Industry = 'Education';
                if (acc.Description == Null) {
                    acc.Description = 'Account Description is blank';
                    
                }

            }
        }

    }
    //* Before Update
    public static void handleBeforeUpdate(List<Account> newAccountList) {
        AccountTriggerHelper.helperBeforeInsertUpdate(newAccountList);//!Set the account Billing Address to shipping address
    }
    //* Before Delete
    public static void handleBeforeDelete(Map<Id,Account> mapOldAccount) {

        if (!mapOldAccount.isEmpty()) {

            Map<Id,Integer> mapOpps = new Map<Id,Integer>();//* collect the AccountId and No of Opps
            for (AggregateResult aggResult : [SELECT COUNT(Id) oppCount, AccountId FROM Opportunity WHERE AccountId IN : mapOldAccount.keySet() WITH USER_MODE GROUP BY AccountId LIMIT 50000]) {
                
                Id oppAccId    = (Id) aggResult.get('AccountId');
                Integer noOpps = (Integer) aggResult.get('oppCount');

                mapOpps.put(oppAccId, noOpps);
            }
            //* Loop through the Accounts
            for (Account delAcc : mapOldAccount.values()) {
                
                if (mapOpps.containsKey(delAcc.Id) && mapOpps.get(delAcc.Id) > 0) {
                    
                    delAcc.addError('This account can\'t be deleted with opportunities');
                }
            }
        }
        
    }
    //* After Insert
    public static void handleAfterInsert(List<Account> newAccountList) {
        AccountTriggerHelper.accountLocations(newAccountList); //! Create N locations
        
        //! Create a task record when an new account gets created
        List<Task> listAccountTask = new List<Task>(); //* To insert the task records
        if (!newAccountList.isEmpty()) {
            //* loop through the accounts
            for (Account acc : newAccountList) {
                
                //* Create a new Task Record
                Task accountTask          = new Task();
                accountTask.Subject       = 'Created from Apex Trigger';
                accountTask.Description   = 'Created from Apex Trigger';
                accountTask.ActivityDate  = System.today() + 7;
                accountTask.Status        = 'Not Started';
                accountTask.Priority      = 'High';
                accountTask.WhatId        = acc.Id;
                accountTask.OwnerId       = acc.OwnerId;
                
                listAccountTask.add(accountTask);
            }
            //* Bulkfy the code
            if (!listAccountTask.isEmpty()) {
                try {
                    insert as user listAccountTask;
                } catch (System.DmlException dmlExp) {

                    List<System_Event__c> listErrros = new List<System_Event__c>(); //* add the error to the system event object

                    for (Integer i = 0; i < dmlExp.getNumDml(); i++) {

                        System_Event__c errorRecord = Logger.loggError(dmlExp.getStackTraceString(), dmlExp.getMessage(), dmlExp.getDmlId(i));
                        listErrros.add(errorRecord);
                    }
                    
                    insert as user listErrros;
                }
            }
        }
    }
    //* After Update
    public static void handleAfterUpdate(List<Account> newAccountList, Map<Id,Account> oldMapAccount) {
        
        AccountTriggerHelper.updateContactOpportunityOwnerId(newAccountList, oldMapAccount); //* Update account owner id
        //!update the status fields on contact and account
        Set<Id> setAccountId = new Set<Id>(); //* collect the new map records

        if (!newAccountList.isEmpty()) {
            //* Loop through the reocrds
            for (Account newAccount : newAccountList) {
                //* Condition to check 
                if (newAccount.Active__c != null && (newAccount.Active__c != oldMapAccount.get(newAccount.Id).Active__c)) {
                    
                    setAccountId.add(newAccount.Id);
                }
            }
        }
        
        //* Query the records for contact and opps
        List<Contact> listContactToUpdate  = new List<Contact>(); //* List of contacts to update
        List<Opportunity> listOppToUpdate  = new List<Opportunity>(); //* list of opps to update

        if (!setAccountId.isEmpty()) {
            List<Account> listNewAccount = [SELECT Id, Active__c, (SELECT 	Active__c FROM Contacts), (SELECT Active__c FROM Opportunities) FROM Account WHERE Id IN: setAccountId];
            
            if (!listNewAccount.isEmpty()) {
                //* Loop through the account 
                for (Account newAcc : listNewAccount) {
                
                        //* loop through the child contact record
                        for (Contact updateCon : newAcc.Contacts) {
                            
                            updateCon.Active__c = newAcc.Active__c;
                            listContactToUpdate.add(updateCon);
                        }
                                    //* Loop through the child oppp records
                                    for (Opportunity updateOpp : newAcc.Opportunities) {
                                        
                                        updateOpp.Active__c = newAcc.Active__c;
                                        listOppToUpdate.add(updateOpp);
                                    }
                }
                //* Bulkify the code for contacts update
                try {
                    
                    update as user listContactToUpdate;

                } catch (System.DmlException dmlExp) {

                    List<System_Event__c> listErrros = new List<System_Event__c>(); //* add the error to the system event object

                    for (Integer i = 0; i < dmlExp.getNumDml(); i++) {

                        System_Event__c errorRecord = Logger.loggError(dmlExp.getStackTraceString(), dmlExp.getMessage(), dmlExp.getDmlId(i));
                        listErrros.add(errorRecord);
                    }
                }        
                //* Bulkify the code for account
                try {
                    
                    update as user listOppToUpdate;

                } catch (System.DmlException dmlExp) {

                    List<System_Event__c> listErrros = new List<System_Event__c>(); //* add the error to the system event object

                    for (Integer i = 0; i < dmlExp.getNumDml(); i++) {

                        System_Event__c errorRecord = Logger.loggError(dmlExp.getStackTraceString(), dmlExp.getMessage(), dmlExp.getDmlId(i));
                        listErrros.add(errorRecord);
                    }
                    insert as user listErrros;
                }    
            }
        }
    }

    
}
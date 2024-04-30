/**
 * @description       : 
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @group             : 
 * @last modified on  : 04-30-2024
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
**/
public with sharing class TaskTriggerHandler {
    
    /**After Update */
    public static void updateOpportunity(Map<Id, Task> newMapTask) {

        Set<Id> setOfOppId = new Set<Id>(); //* Initialize the set to collect the opportunities
        //* Check the new taks values
        if (newMapTask?.isEmpty()) {
            return;
        } else {
            //* Iterate through the new map values
            for (Task tsk : newMapTask.values()) {
                if (tsk.Status == 'Completed') {
                    //* collect the completed tasks
                    if (tsk.WhatId != null && tsk.WhatId.getSObjectType() == Opportunity.getSObjectType()) {
                        setOfOppId.add(tsk.whatId);    
                    }
                }
            } 
        }    
        //* Collect the accountID 
        Set<Id> accId = new Set<Id>();

        if (setOfOppId?.isEmpty()) {
            return;
        } else {
            
            //* Query account ID associated to the oppp 
            List<Opportunity> opps = [SELECT Id, AccountId FROM Opportunity WHERE Id IN : setOfOppId WITH USER_MODE];
            //* Initialize the map to collect the data

            if(opps?.isEmpty() == false) {
                for (Opportunity opp : opps) {
                    if (opp.AccountId != null) {
                        accId.add(opp.AccountId);
                    }
                }
            }    
        }
        //* Collect the Opps that need to be updated

        List<Opportunity> toBeUpdated = new List<Opportunity>();

        //*  Check the account id is not empty 
        if(accId?.isEmpty() == false) {


            //* Query the opportunities
            List<Opportunity> ops = [SELECT ID, StageName FROM Opportunity WHERE AccountId IN : accId WITH USER_MODE];
            //* Check the opportunities is not empty
            if (ops?.isEmpty() == false) {
                //* Iterate through the opportunities
                for (Opportunity op : ops) {
                    //* Update the opportunity stage
                    if (op.StageName != 'Closed Won' && op.StageName != 'Closed Lost' ) {
                        op.StageName = 'Closed Lost';
                        //* Add the opportunity to the to be updated list
                        tobeUpdated.add(op);
                    }    
                }
            }
        }
        //* Check the tobeUpdated list is not empty
        if (tobeUpdated?.isEmpty() == false) {
            //! Update the opportunity
            try {
                
                update as user tobeupdated;
            } catch (DmlException dmlExp) {

                Logger.triggererror(dmlExp);

            } catch (Exception allExp) {

                Logger.triggerAllErrors(allExp);
            }
        }    
        
    }
}
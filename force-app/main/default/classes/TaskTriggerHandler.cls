/**
 * @description       : 
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @group             : 
 * @last modified on  : 05-01-2024
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

        //* calling the helper method to update the opps
        if (accId?.size() > 0) {

            TaskTriggerHelper.updateOppStageToCloseWon(accId);
        } 
        
    }
}
/**
 * @description       : 
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @group             : 
 * @last modified on  : 07-15-2024
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
**/
public with sharing class OpportunityTriggerHandler {
    //* Before Insert
    public static void handleBeforeInsert(List<Opportunity> newOppList) {
        OpportunityTriggerHelper.discountClaculation(newOppList);//! Discount calculation
        OpportunityTriggerHelper.addActiveStatus(newOppList); //! Add Active field to opp
        OpportunityTriggerHelper.updateDescription(newOppList); //! Update the Account description to opp
    }
    //* Before Update
    public static void handleBeforeUpdate(List<Opportunity> newOppList, Map<Id,Opportunity> oldMapOpp) {
        OpportunityTriggerHelper.discountClaculation(newOppList);//! Discount calculation
        OpportunityTriggerHelper.updateOppNewOwner(newOppList, oldMapOpp); //!Update the opps Description when owner change

    }
    //* After Insert
    public static void handleAfterInsert(List<Opportunity> newOppList) {
        OpportunityTriggerHelper.opportunityTaskCreation(newOppList);
        OpportunityTriggerHelper.updateOppAmount(newOppList);
        OpportunityTriggerHelper.addSalesRepName(newOppList);
        
        //* Update amount on Account 
        Map<Id,Opportunity> mapOppAccountId = new Map<Id,Opportunity>(); //* Collect the account Ids
        if (newOppList?.size() >0) {
            for (Opportunity newOpp : newOppList) {
                if (newOpp.AccountId != null) {
                    mapOppAccountId.put(newOpp.AccountId, newOpp);
                }
            }
            OpportunityTriggerHelper.updateOppAmountOnAccount(mapOppAccountId);
        }
    }
    //* After Update
    public static void handleAfterUpdate(List<Opportunity> newOppList, Map<Id,Opportunity> oldMapOpp) {

        if (newOppList.isEmpty()) return;
        //* addSalesRep Name Trigger
        Map<Id,Opportunity> mapOppToUpdate = new Map<Id,Opportunity>();//*Collect the map to update
        
            for (Opportunity newOpp : newOppList) {
                if(newOpp.Sales_Representative__c == null || newOpp.Sales_Representative__c != oldMapOpp.get(newOpp.Id).Sales_Representative__c) {
                    mapOppToUpdate.put(newOpp.Id, newOpp);
                }
            }
        OpportunityTriggerHelper.addSalesRepName(mapOppToUpdate.values());

        //* Update opp Amount on the Account
            Map<Id, Opportunity> mapClosedOpp = new Map<Id,Opportunity>(); //* collect the closed opps
            Map<Id,Opportunity> mapOpenOpp = new Map<Id,Opportunity>(); //* collect the opp has new amount and open ops
            
            for (Opportunity newOpp : newOppList) {
                if (newOpp.Amount != oldMapOpp.get(newOpp.Id).Amount || newOpp.StageName != oldMapOpp.get(newOpp.Id).StageName) {

                    if (newOpp.StageName != 'Closed Lost' || newOpp.StageName != 'Closed Won') {
                        mapOpenOpp.put(newOpp.AccountId, newOpp);
                        mapClosedOpp.put(oldMapOpp.get(newOpp.Id).AccountId, oldMapOpp.get(newOpp.Id));
                    } else {
                        mapOpenOpp.put(oldMapOpp.get(newOpp.Id).AccountId, oldMapOpp.get(newOpp.Id));
                        mapClosedOpp.put(newOpp.AccountId, newOpp);
                    }
                }
            }

            //* calling the helper class
            if (mapOpenOpp?.size() > 0) {
                OpportunityTriggerHelper.updateOppAmountOnAccount(mapOpenOpp);
            }
            if (mapClosedOpp?.size() > 0) {
                OpportunityTriggerHelper.updateOppAmountOnAccount(mapClosedOpp);
            }
    }
    //*After Delete
    public static void handleAfterDelete(Map<Id,Opportunity> oldMapRecords) {
        if (oldMapRecords.isEmpty()) return;
        
        Map<Id,Opportunity> mapOppWithAccountId = new Map<Id,Opportunity>(); //* Map of opp with account id as key
        //* loop through the old map Records
        for (Opportunity oldOpp : oldMapRecords.values()) {
            //* check for the condition 
            if(oldOpp.AccountId != null && oldOpp.Amount != null && oldOpp.Amount != 0) {
                mapOppWithAccountId.put(oldOpp.AccountId, oldOpp);
            }
        }
        if (!mapOppWithAccountId.isEmpty()) {
             //* calling the helper class
            OpportunityTriggerHelper.updateOppAmountOnAccount(mapOppWithAccountId);   
        }
    }
    //* After Undelete
    public static void handleAfterUndelete(List<Opportunity> listNewOpps) {
        if (listNewOpps.isEmpty()) return; 

        Map<Id,Opportunity> mapOppWithAccountId  = new Map<Id,Opportunity>(); //* Map of opp with account id as key
        //* loop through the records
        for (Opportunity newOpps : listNewOpps) {
            //* check for the condition
            if(newOpps.AccountId != null && newOpps.Amount != 0) {
                mapOppWithAccountId.put(newOpps.AccountId, newOpps);
            }
        }
        if (mapOppWithAccountId?.size() > 0) {
            //* calling the helper class
            OpportunityTriggerHelper.updateOppAmountOnAccount(mapOppWithAccountId);   
        }
    }

}
public with sharing class OpportunityTriggerHandler {
    //* Before Insert
    public static void handleBeforeInsert(List<Opportunity> newOppList) {
        OpportunityTriggerHelper.discountClaculation(newOppList);//! Discount calculation
        OpportunityTriggerHelper.addActiveStatus(newOppList); //! Add Active field to opp
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
        if (!newOppList.isEmpty()) {
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
        Map<Id,Opportunity> mapOppToUpdate = new Map<Id,Opportunity>();//*Collect the map to update
        if (!newOppList.isEmpty()) {
            for (Opportunity newOpp : newOppList) {
                if(newOpp.Sales_Representative__c == null || newOpp.Sales_Representative__c != oldMapOpp.get(newOpp.Id).Sales_Representative__c) {

                    mapOppToUpdate.put(newOpp.Id, newOpp);
                }
            }
        }
        OpportunityTriggerHelper.addSalesRepName(mapOppToUpdate.values());
    }

}
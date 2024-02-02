public with sharing class OpportunityTriggerHandler {
    //* Before Insert
    public static void handleBeforeInsert(List<Opportunity> newOppList) {
        OpportunityTriggerHelper.discountClaculation(newOppList);//! Discount calculation
        OpportunityTriggerHelper.addActiveStatus(newOppList); //! Add Active field to opp
    }
    //* Before Update
    public static void handleBeforeUpdate(List<Opportunity> newOppList) {
        OpportunityTriggerHelper.discountClaculation(newOppList);//! Discount calculation
    }
    //* After Insert
    public static void handleAfterInsert(List<Opportunity> newOppList) {
        OpportunityTriggerHelper.opportunityTaskCreation(newOppList);
        OpportunityTriggerHelper.updateOppAmount(newOppList);
    }
}
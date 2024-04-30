/**
 * @description       : 
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @group             : 
 * @last modified on  : 04-30-2024
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
**/
public with sharing class OpportunityLineItemsTriggerHelper {
    public static void updateTotalLineItems(Set<Id> oppIds) {

        List<Opportunity> oppsToUpdate = new List<Opportunity>(); //* List of new Opps
        
        if (oppIds?.size() > 0) {

            //* Query the number of Opprtunities in the Opportunity Line items
        List<AggregateResult> aggResult = [SELECT COUNT(Id) totalOppLines, OpportunityId FROM OpportunityLineItem WHERE OpportunityId IN :oppIds WITH USER_MODE GROUP BY OpportunityId LIMIT 50000];

            if (aggResult?.size() > 0) {
                //* Get the count and assign it to the field on the Opportunity
                for (AggregateResult agg : aggResult) {

                        Integer totalLineItems = (Integer) agg.get('totalOppLines');
                        String oppId   = (String) agg.get('OpportunityId');

                        Opportunity updateOpp                     = new Opportunity();
                        updateOpp.Id                              = oppId;      
                        updateOpp.Total_Opportunity_Line_Items__c = totalLineItems;

                        oppsToUpdate.add(updateOpp);
                    }     
            }

        }
        
        //* Update the opps 
        if (oppsToUpdate?.size() > 0) {
            try {
                update as user oppsToUpdate;
            } catch (DmlException dmlExp) {
                Logger.triggererror(dmlExp);
            } catch (Exception allExp) {
                Logger.triggerAllErrors(allExp);
            }
        }
    }
}
/**
 * @description       : 
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @group             : 
 * @last modified on  : 04-30-2024
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
**/
public with sharing class OpportunityLineItemsTriggerHandler {

    /**After Insert */
    public static void countNumberOfLineItems(List<OpportunityLineItem> newListLineItems, Map<Id,OpportunityLineItem> newMapLineItems) {

        //* Collect the Opp Ids
        Set<Id> opportunityIds = new Set<Id>();
        //* Get the new list of records inserted
        if (newListLineItems?.isEmpty()) {
            return;
        } else {
            //* iterate over the list to get the opportunity Id   
            
            for (OpportunityLineItem lineItem : newListLineItems) {
                if (lineItem.OpportunityId != null) {
                    opportunityIds.add(lineItem.OpportunityId);    

                    }
            }
            //* Call the helper to update the opps

            OpportunityLineItemsTriggerHelper.updateTotalLineItems(opportunityIds);
        }
    }
    /**After Delete */
    public static void deletedLineItems(Map<Id, OpportunityLineItem> oldMapLineItems) {
        
        //* Collect the Opp Ids
        Set<Id> opportunityIds = new Set<Id>();

        //* Get the new list of records inserted
        if (oldMapLineItems?.isEmpty()) {
            return;
        } else {
            //* iterate over the list to get the opportunity Id
            
            for (OpportunityLineItem lineItem : oldMapLineItems.values()) {
                if (lineItem.OpportunityId != null) {
                    opportunityIds.add(lineItem.OpportunityId);
                }
            }
        }
        //* calling the helper class to update the opps
        OpportunityLineItemsTriggerHelper.updateTotalLineItems(opportunityIds);
    }
}
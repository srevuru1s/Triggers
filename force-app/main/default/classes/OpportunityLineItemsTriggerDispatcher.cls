/**
 * @description       : 
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @group             : 
 * @last modified on  : 04-30-2024
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
**/
public with sharing class OpportunityLineItemsTriggerDispatcher {
    public static void dispatcher(System.TriggerOperation operationType) {

        switch on operationType {

            when BEFORE_INSERT  {
    
            }
            when AFTER_INSERT {
                OpportunityLineItemsTriggerHandler.countNumberOfLineItems(Trigger.new, (Map<Id,OpportunityLineItem>) Trigger.newMap);
            }
            when BEFORE_UPDATE {
    
            }
            when AFTER_UPDATE {
    
            }
            when AFTER_DELETE {
                OpportunityLineItemsTriggerHandler.deletedLineItems((Map<Id,OpportunityLineItem>) Trigger.oldMap);
            }
            when AFTER_UNDELETE {

            }
        }
    }
}
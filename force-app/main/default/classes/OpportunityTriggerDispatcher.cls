/**
 * @description       : 
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @group             : 
 * @last modified on  : 02-16-2024
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
**/
public with sharing class OpportunityTriggerDispatcher {
    public static void dipatcher(System.TriggerOperation operationType) {
        switch on operationType {
            WHEN BEFORE_INSERT  {
                OpportunityTriggerHandler.handleBeforeInsert(Trigger.new);
            }
            WHEN AFTER_INSERT {
                OpportunityTriggerHandler.handleAfterInsert(Trigger.new);
            }
            WHEN BEFORE_UPDATE {
                OpportunityTriggerHandler.handleBeforeUpdate(Trigger.new, (Map<Id,Opportunity>)Trigger.OldMap);
            }
            WHEN AFTER_UPDATE {
                OpportunityTriggerHandler.handleAfterUpdate(Trigger.new, (Map<Id,Opportunity>)Trigger.OldMap);
            }
            WHEN BEFORE_DELETE {
                
            }
            WHEN AFTER_DELETE {
                OpportunityTriggerHandler.handleAfterDelete((Map<Id,Opportunity>) Trigger.OldMap);
            }
            WHEN AFTER_UNDELETE {
                OpportunityTriggerHandler.handleAfterUndelete(Trigger.new);
            }
        }
    }
}
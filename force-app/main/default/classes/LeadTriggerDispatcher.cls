/**
 * @description       : 
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @group             : 
 * @last modified on  : 07-03-2024
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
**/
public with sharing class LeadTriggerDispatcher {
    public static void dispatcher(System.TriggerOperation operationType) {
        switch on operationType {
            WHEN BEFORE_INSERT  {
        
                LeadTriggerHandler.handleBeforeInsert(Trigger.new);
            }
            WHEN AFTER_INSERT {
                
            }
            WHEN BEFORE_UPDATE {
                
                LeadTriggerHandler.handleBeforeUpdate(Trigger.new, (Map<Id,Lead>) Trigger.oldMap);
            }
            WHEN AFTER_UPDATE {
                
            }
            WHEN BEFORE_DELETE {
                
            }
            WHEN AFTER_DELETE {
                
            }
            WHEN AFTER_UNDELETE {
                LeadTriggerHandler.handleAfterDelete((Map<Id,Lead>) Trigger.newMap);
            }
        }
    }
}
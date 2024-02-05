public with sharing class ContactTriggerDispatcher {
    public static void dipatcher(System.TriggerOperation operationType) {
        switch on operationType {
            WHEN BEFORE_INSERT  {
                ContactTriggerHandler.handleBeforeInsert(Trigger.new);
            }
            WHEN AFTER_INSERT {
                ContactTriggerHandler.handleAfterInsert(Trigger.new, (Map<Id,Contact>) Trigger.newMap);
            }
            WHEN BEFORE_UPDATE {
                ContactTriggerHandler.handleBeforeUpdate(Trigger.new);
            }
            WHEN AFTER_UPDATE {
                ContactTriggerHandler.handleAfterUpdate((Map<Id,Contact>) Trigger.newMap, (Map<Id,Contact>) Trigger.oldMap);
            }
            WHEN BEFORE_DELETE {  
                
            }
            WHEN AFTER_DELETE {
                ContactTriggerHandler.hanleAfterDelete((Map<Id,Contact>) Trigger.oldMap);
            }
            WHEN AFTER_UNDELETE {
                ContactTriggerHandler.handleAfterUndelete((Map<Id,Contact>) Trigger.newMap);
            }
            
        }
    }
}
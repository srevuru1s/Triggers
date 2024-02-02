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
                
            }
            WHEN BEFORE_DELETE {
                
            }
            WHEN AFTER_DELETE {
                
            }
            WHEN AFTER_UNDELETE {
                
            }
        }
    }
}
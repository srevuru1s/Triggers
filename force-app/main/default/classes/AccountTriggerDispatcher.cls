public with sharing class AccountTriggerDispatcher {
    
    public static void dispatcher(System.TriggerOperation operationType) {
        switch on operationType {
            WHEN BEFORE_INSERT  {
                AccountTriggerHandler.handleBeforeInsert(Trigger.new);
            }
            WHEN AFTER_INSERT {
                AccountTriggerHandler.handleAfterInsert(Trigger.new);
            }
            WHEN BEFORE_UPDATE {
                AccountTriggerHandler.handleBeforeUpdate(Trigger.new);
            }
            WHEN AFTER_UPDATE {
                AccountTriggerHandler.handleAfterUpdate(Trigger.new, (Map<Id,Account>) Trigger.oldMap);
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
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
                OpportunityTriggerHandler.handleBeforeUpdate(Trigger.new);
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
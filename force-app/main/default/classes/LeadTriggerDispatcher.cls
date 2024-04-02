public with sharing class LeadTriggerDispatcher {
    public static void dispatcher(System.TriggerOperation operationType) {
        switch on operationType {
            WHEN BEFORE_INSERT  {
               
                LeadTriggerHandler.handleBeforeInsert(Trigger.new);
            }
            WHEN AFTER_INSERT {
                
            }
            WHEN BEFORE_UPDATE {
                
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
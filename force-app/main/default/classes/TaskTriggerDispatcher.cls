/**
 * @description       : 
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @group             : 
 * @last modified on  : 04-30-2024
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
**/
public with sharing class TaskTriggerDispatcher {
    public static void dispatcher(System.TriggerOperation operationType) {
        switch on operationType {
            when BEFORE_INSERT  {
            }
            when AFTER_INSERT {

            }
            when BEFORE_UPDATE  {
            }
            when AFTER_UPDATE {
                TaskTriggerHandler.updateOpportunity((Map<Id, Task>) Trigger.newMap);
            }
            when BEFORE_DELETE {
            }
            when AFTER_DELETE {
            }
            when AFTER_UNDELETE {
            }
        }
    }    
    
}
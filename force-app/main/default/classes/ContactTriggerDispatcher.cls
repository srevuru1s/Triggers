public with sharing class ContactTriggerDispatcher {
  public static void dipatcher(System.TriggerOperation operationType) {
    switch on operationType {
      when BEFORE_INSERT {
        ContactTriggerHandler.handleBeforeInsert(Trigger.new);
      }
      when AFTER_INSERT {
        ContactTriggerHandler.handleAfterInsert(
          Trigger.new,
          (Map<Id, Contact>) Trigger.newMap
        );
      }
      when BEFORE_UPDATE {
        ContactTriggerHandler.handleBeforeUpdate(Trigger.new);
      }
      when AFTER_UPDATE {
        ContactTriggerHandler.handleAfterUpdate(
          (Map<Id, Contact>) Trigger.newMap,
          (Map<Id, Contact>) Trigger.oldMap
        );
      }
      when BEFORE_DELETE {
      }
      when AFTER_DELETE {
        ContactTriggerHandler.hanleAfterDelete(
          (Map<Id, Contact>) Trigger.oldMap
        );
      }
      when AFTER_UNDELETE {
        ContactTriggerHandler.handleAfterUndelete(
          (Map<Id, Contact>) Trigger.newMap
        );
      }
    }
  }
}

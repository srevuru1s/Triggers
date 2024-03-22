public with sharing class AccountTriggerDispatcher {
  public static void dispatcher(System.TriggerOperation operationType) {
    switch on operationType {
      when BEFORE_INSERT {
        AccountTriggerHandler.handleBeforeInsert(Trigger.new);
      }
      when AFTER_INSERT {
        AccountTriggerHandler.handleAfterInsert(Trigger.new);
      }
      when BEFORE_UPDATE {
        AccountTriggerHandler.handleBeforeUpdate(Trigger.new);
      }
      when AFTER_UPDATE {
        AccountTriggerHandler.handleAfterUpdate(
          Trigger.new,
          (Map<Id, Account>) Trigger.oldMap
        );
      }
      when BEFORE_DELETE {
        AccountTriggerHandler.handleBeforeDelete(
          (Map<Id, Account>) Trigger.oldMap
        );
      }
      when AFTER_DELETE {
      }
      when AFTER_UNDELETE {
      }
    }
  }
}

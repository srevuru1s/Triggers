public with sharing class LeadTriggerDispatcher {
  public static void dispatcher(System.TriggerOperation operationType) {
    switch on operationType {
      when BEFORE_INSERT {
        LeadTriggerHandler.handleBeforeInsert(Trigger.new);
      }
      when AFTER_INSERT {
      }
      when BEFORE_UPDATE {
      }
      when AFTER_UPDATE {
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

/**
 * @description       :
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @group             :
 * @last modified on  : 02-16-2024
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
 **/
public with sharing class OpportunityTriggerDispatcher {
  public static void dipatcher(System.TriggerOperation operationType) {
    switch on operationType {
      when BEFORE_INSERT {
        OpportunityTriggerHandler.handleBeforeInsert(Trigger.new);
      }
      when AFTER_INSERT {
        OpportunityTriggerHandler.handleAfterInsert(Trigger.new);
      }
      when BEFORE_UPDATE {
        OpportunityTriggerHandler.handleBeforeUpdate(
          Trigger.new,
          (Map<Id, Opportunity>) Trigger.OldMap
        );
      }
      when AFTER_UPDATE {
        OpportunityTriggerHandler.handleAfterUpdate(
          Trigger.new,
          (Map<Id, Opportunity>) Trigger.OldMap
        );
      }
      when BEFORE_DELETE {
      }
      when AFTER_DELETE {
        OpportunityTriggerHandler.handleAfterDelete(
          (Map<Id, Opportunity>) Trigger.OldMap
        );
      }
      when AFTER_UNDELETE {
        OpportunityTriggerHandler.handleAfterUndelete(Trigger.new);
      }
    }
  }
}

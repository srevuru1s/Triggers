/**
 * @description       : 
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @group             : 
 * @last modified on  : 04-29-2024
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
**/
trigger OpportunityLineItemsTrigger on OpportunityLineItem (before insert, after insert, before update, after update, before delete, after delete, after undelete) {

    OpportunityLineItemsTriggerDispatcher.dispatcher(Trigger.operationType);
}
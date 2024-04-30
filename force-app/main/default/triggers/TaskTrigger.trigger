/**
 * @description       : 
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @group             : 
 * @last modified on  : 04-30-2024
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
**/
trigger TaskTrigger on Task (before insert, after insert, before update, after update, before delete, after delete, after undelete) {
    TaskTriggerDispatcher.dispatcher(Trigger.operationType);
}


trigger OpportunityTrigger on Opportunity(
  before insert,
  after insert,
  before update,
  after update,
  before delete,
  after delete,
  after undelete
) {
  OpportunityTriggerDispatcher.dipatcher(Trigger.OperationType);
}

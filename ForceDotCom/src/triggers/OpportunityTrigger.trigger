trigger OpportunityTrigger on Opportunity (before insert, before update, before delete, after insert, after update, after delete) {
    OpportunityTriggerHandler handler = new OpportunityTriggerHandler(trigger.new, trigger.old, trigger.newMap, trigger.oldMap);
    
    if(Trigger.isAfter && Trigger.isInsert) {
        handler.handleAfterInsert();
    }
    
    if(Trigger.isAfter && Trigger.isUpdate) {
        handler.handleAfterUpdate();
    }
    
    if(Trigger.isAfter && Trigger.isDelete) {
        handler.handleAfterDelete();
    }
}
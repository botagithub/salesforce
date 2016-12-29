trigger AccountTrigger on Account (before insert, before update, before delete, after insert, after update, after delete) {
	AccountTriggerHandler triggerHandler = new AccountTriggerHandler(Trigger.new, Trigger.old, Trigger.newMap,Trigger.oldMap);
    
    if(Trigger.isBefore && Trigger.isInsert) {
        triggerHandler.handleBeforeInsert();
    }
    
    if(Trigger.isBefore && Trigger.isDelete) {
        triggerHandler.handlerBeforeDelete();
    }
    
    if(Trigger.isAfter && Trigger.isUpdate) {
        triggerHandler.handleAfterInsert();
    }
}
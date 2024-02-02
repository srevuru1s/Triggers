public with sharing class Logger {
    
    public static System_Event__c loggError(String stackError, String message, String failedRecord) {

        System_Event__c event          = new System_Event__c();
        event.message__c               = message;
        event.Complete_Trace_String__c = stackError;
        event.Name                     = 'error while dml operation';
        event.Failed_Record_Id__c      = failedRecord;
        return event;
    }
}
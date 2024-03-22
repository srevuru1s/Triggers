public with sharing class Logger {
  public static System_Event__c loggError(
    String stackError,
    String message,
    String failedRecord
  ) {
    System_Event__c event = new System_Event__c();
    event.message__c = message;
    event.Complete_Trace_String__c = stackError;
    event.Name = 'error while dml operation';
    event.Failed_Record_Id__c = failedRecord;
    return event;
  }

  public static void triggererror(DmlException dmlExp) {
    List<System_Event__c> listErrros = new List<System_Event__c>(); //* add the error to the system event object
    Integer noOfRecords = dmlExp.getNumDml();
    for (Integer i = 0; i < noOfRecords; i++) {
      System_Event__c errorRecord = loggError(
        dmlExp.getStackTraceString(),
        dmlExp.getMessage(),
        dmlExp.getDMLId(i)
      );
      listErrros.add(errorRecord);
    }
    insert as user listErrros;
  }

  public static void triggerAllErrors(Exception allExp) {
    System_Event__c errorRecord = loggError(
      allExp.getStackTraceString(),
      allExp.getMessage(),
      allExp.getTypeName()
    );
    insert as user errorRecord;
  }
}

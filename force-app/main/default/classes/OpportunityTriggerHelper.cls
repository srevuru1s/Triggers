/**
 * @description       :
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @group             :
 * @last modified on  : 07-08-2024
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
 **/
public with sharing class OpportunityTriggerHelper {
  //! if the Discount & Amount field is not blank then calculate the discount
  public static void discountClaculation(List<Opportunity> newOppList) {
    if (!newOppList.isEmpty())
      return;

    //*Loop through the records
    for (Opportunity newOpp : newOppList) {
      //* check the condition
      if (newOpp.Discount__c != null) {
        Decimal discount = (newOpp.Discount__c * newOpp.Amount) / 100;
        newOpp.Discounted_Price__c = (newOpp.Amount - discount);
      }
    }
  }
  //! Create a Task record to Opp when the account is blank
  public static void opportunityTaskCreation(List<Opportunity> newOppList) {
    if (newOppList.isEmpty())
      return;
    List<Task> listTask = new List<Task>(); //* List of task record

    //*loop through the records
    for (Opportunity newOpp : newOppList) {
      //* Condition check
      if (newOpp.AccountId == null) {
        Task newTask = new Task();
        newTask.Description = 'Opportunity is created without Account please assign an account';
        newTask.Subject = 'Opportunity is created without Account';
        newTask.ActivityDate = System.today().addDays(7);
        newTask.Status = null;
        newTask.WhatId = null;
        newTask.OwnerId = null;

        listTask.add(newTask);
      }
    }
    //* DML on Records
    if (!listTask.isEmpty()) {
      try {
        insert as user listTask;
      } catch (DmlException dmlExp) {
        Logger.triggererror(dmlExp);
      } catch (Exception allExp) {
        Logger.triggerAllErrors(allExp);
            }
    }
  }
  //! Update Opp Active field from Account
  public static void addActiveStatus(List<Opportunity> newOppList) {
    if (newOppList.isEmpty())
      return;

    Map<Id, Opportunity> mapOppAccId = new Map<Id, Opportunity>(); //* Collect the opps with accid
    //* Loop through the records
    for (Opportunity opp : newOppList) {
      if (opp.AccountId != null) {
        mapOppAccId.put(opp.AccountId, opp);
      }
    }

    //*Query the account field
    if (!mapOppAccId?.isEmpty()) {
      for (Account acc : [
        SELECT Id, Active__c
        FROM Account
        WHERE Id IN :mapOppAccId.keySet()
      ]) {
        if (acc.Active__c != null) {
          mapOppAccId.get(acc.Id).Active__C = acc.Active__c;
        }
      }
    }
  }
  //! Update the amount field to 1000 if it is blank
  public static void updateOppAmount(List<Opportunity> newOppList) {
    if (newOppList.isEmpty())
      return;

    Set<Id> oppIds = new Set<Id>(); //* opp that need to updated
    //* loop through the records
    for (Opportunity opp : newOppList) {
      if (opp.Account == null) {
        oppIds.add(opp.Id);
      }
    }

    //* Query the opp fields to update
    List<Opportunity> oppsNeedToUpdate = new List<Opportunity>();
    for (Opportunity updateOpp : [
      SELECT Id, Amount
      FROM Opportunity
      WHERE Id IN :oppIds
      WITH USER_MODE
    ]) {
      if (updateOpp.Amount == null) {
        updateOpp.Amount = 1000;
        oppsNeedToUpdate.add(updateOpp);
      }
    }
    if (!oppsNeedToUpdate.isEmpty()) {
      try {
        update as user oppsNeedToUpdate;
      } catch (DmlException dmlExp) {
        Logger.triggererror(dmlExp);
      } catch (Exception allExp) {
        Logger.triggerAllErrors(allExp);
      }
    }
  }
  //! Update the Account with Opp Amount
  public static void updateOppAmountOnAccount(Map<Id, Opportunity> mapNewOpp) {
    if (mapNewOpp.isEmpty())
      return;

    Map<Id,Account> mapOpenOppAccount   = new Map<Id,Account>();
    Map<Id,Account> mapClosedOppAccount = new Map<Id,Account>();

    //* Loop through the opps to run the query
    for (Opportunity opp : mapNewOpp.values()) {
      if (opp.StageName != 'Closed Lost' && opp.StageName != 'Closed Won') {
        mapOpenOppAccount.put(opp.AccountId, new Account(Id = opp.AccountId, Sum_of_Open_Opportunity__c = 0));
      } else {
        mapClosedOppAccount.put(opp.AccountId, new Account(Id = opp.AccountId, Sum_of_Closed_Opportunity__c = 0));
      }
    }

    //* Query the open Opportunity Amounts
    
      if (!mapOpenOppAccount .isEmpty()) {
        List<AggregateResult> openOppdAggresult = [
          SELECT SUM(Amount) totalOpenAmount, AccountId
          FROM Opportunity
          WHERE AccountId IN :mapOpenOppAccount.keySet()
          AND StageName != 'Closed Won'
          AND StageName != 'Closed Lost'
          WITH USER_MODE
          GROUP BY AccountId
          LIMIT 50000
        ];
      //* Loop through the agg results
      for (AggregateResult aggResult : openOppdAggresult) {
        Decimal amount = (Decimal) aggResult.get('totalOpenAmount');
        Id accId = (Id) aggResult.get('AccountId');

        mapOpenOppAccount.put(accId, new Account(Id = accId, Sum_of_Open_Opportunity__c = amount));
      }
    }
    //* Query the closed Opportunity Amount

    if (!mapClosedOppAccount.isEmpty()) {
      List<AggregateResult> closedOppAggresult = [
        SELECT SUM(Amount) totalClosedAmount, AccountId
        FROM Opportunity
        WHERE AccountId IN :mapClosedOppAccount.keySet()
        AND (StageName = 'Closed Won'
        OR StageName = 'Closed Lost')
        WITH USER_MODE
        GROUP BY AccountId
        LIMIT 50000
      ];

      //* Loop through the aggresults
      for (AggregateResult aggResult : closedOppAggresult) {
        Decimal amount = (Decimal) aggResult.get('totalClosedAmount');
        Id accId = (Id) aggResult.get('AccountId');

        mapClosedOppAccount.put(accId, new Account(Id = accId, Sum_of_Closed_Opportunity__c = amount));
      }
    }

    //* Bulkify the code to insert/update the account reords

    if (
      (!mapOpenOppAccount.isEmpty()) ||
      (!mapClosedOppAccount.isEmpty())
    ) {
      try {
        update as user mapOpenOppAccount.values();
        update as user mapClosedOppAccount.values();
      } catch (DmlException dmlExp) {
        Logger.triggererror(dmlExp);
      } catch (Exception allExp) {
        Logger.triggerAllErrors(allExp);
      }
    }
  }

  //!Update the opp new Owner in the description
  public static void updateOppNewOwner(List<Opportunity> newOppList,Map<Id, Opportunity> oldMapOpp) {
    if (newOppList.isEmpty())
      return;
    Map<Id, Opportunity> newOwnerOpp = new Map<Id, Opportunity>(); //* collect the opps with new Owner

    for (Opportunity opp : newOppList) {
      if (opp.OwnerId != null && opp.OwnerId != oldMapOpp.get(opp.Id).OwnerId) {
        newOwnerOpp.put(opp.OwnerId, opp);
      }
    }

    //* Loop through the new Opps
    if (!newOwnerOpp.isEmpty()) {
      //* Query the user records to get the name and email of the owner
      Map<Id, User> listUserDetails = new Map<Id, User>(
        [
          SELECT Id, Name, Email
          FROM User
          WHERE Id IN :newOwnerOpp.keySet()
          WITH USER_MODE
          LIMIT 50000
        ]
      );

      for (Opportunity newOpp : newOwnerOpp.values()) {
        newOpp.Description =
          listUserDetails.get(newOpp.OwnerId).Name +
          listUserDetails.get(newOpp.OwnerId).Email;
      }
    }
  }
  //!Add sales Rep field on the Opp
  public static void addSalesRepName(List<Opportunity> newOppList) {
    if (newOppList.isEmpty())
      return;
    Map<Id, Opportunity> mapOpp = new Map<Id, Opportunity>(); //* collect the opps that need to be updated

    for (Opportunity opp : newOppList) {
      if (opp.Sales_Representative__c == null) {
        mapOpp.put(opp.Id, opp);
      }
    }

    //* Loop Through the Map
    List<Opportunity> listOppsToUpdate = new List<Opportunity>(); //* collect the opps
    if (!mapOpp.isEmpty()) {
      for (Opportunity opp : mapOpp.values()) {
        Opportunity newOpp = new Opportunity();
        newOpp.Sales_Representative__c = opp.OwnerId;
        newOpp.Id = opp.Id;
        listOppsToUpdate.add(newOpp);
      }
    }
    if (!listOppsToUpdate.isEmpty()) {
      try {
        update as user listOppsToUpdate;
      } catch (DmlException dmlExp) {
        Logger.triggererror(dmlExp);
      } catch (Exception allExp) {
        Logger.triggerAllErrors(allExp);
      }

      Integer totalDML = Limits.getLimitDmlStatements();
      System.debug('Total DMLS:' + totalDML);
      Integer executedDMLs = Limits.getDmlStatements();
      System.debug('Executed DMLS:' + executedDMLs);
    }
  }

  //! Update the OPP description to Account Description
  public static void updateDescription(List<Opportunity> newOppList) {

    //? Collect opp AccountID's
    List<Id> accId = new List<Id>();

    //? Check the list of new records
    if(!newOppList?.isEmpty()) {
      //? Check the condition of accountId field on opp record
      for (Opportunity newOpp : newOppList) {

        if(newOpp?.AccountId != null) {
          accId.add(newOpp.AccountId);
        }
      }
    }
    //? Query the account records
    if(!accid?.isEmpty()) {
      
      Map<Id,Account> mapAcc = new Map<Id,Account>([SELECT Id, Description FROM Account WHERE ID IN: accId WITH USER_MODE]);

      if(!mapAcc?.isEmpty()) {
        for(Opportunity newOpp : newOppList) {
          
          if(mapAcc.containsKey(newOpp.AccountId)) {

            newOpp.Description = mapAcc.get(newOpp.AccountId).Description;
          }
        }
      }

    }
  }
}
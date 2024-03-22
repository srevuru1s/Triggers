public with sharing class AccountTriggerHelper {
  //!Set the account Billing Address to shipping address && Update the shipping address with billing if they are blank
  public static void helperBeforeInsertUpdate(List<Account> newAccountList) {
    if (!newAccountList.isEmpty()) {
      //* loop through the accounts

      for (Account acc : newAccountList) {
        //* check the condition
        if (
          acc.ShippingStreet == null ||
          acc.ShippingCity == null ||
          acc.ShippingState == null ||
          acc.ShippingPostalCode == null ||
          acc.ShippingCountry == null
        ) {
          acc.ShippingStreet = acc.BillingStreet;
          acc.ShippingCity = acc.BillingStreet;
          acc.ShippingState = acc.BillingState;
          acc.ShippingPostalCode = acc.BillingPostalCode;
          acc.ShippingCountry = acc.BillingCountry;
        }
      }
    }
  }
  //! Update the account's contact and Opportuity Owner Id
  public static void updateContactOpportunityOwnerId(
    List<Account> newAccountList,
    Map<Id, Account> oldMap
  ) {
    Map<Id, Account> mapAcc = new Map<Id, Account>(); //* Collect the account details

    if (!newAccountList.isEmpty()) {
      for (Account acc : newAccountList) {
        //* Condition to check the accid
        if (acc.OwnerId != oldMap.get(acc.Id).OwnerId) {
          mapAcc.put(acc.Id, acc);
        }
      }
    }
    if (!mapAcc.isEmpty()) {
      //*Query the accounts opp and contacts
      List<Contact> conToUpdate = new List<Contact>(); //* Collect the contact records
      List<Opportunity> oppToUpdate = new List<Opportunity>(); //* Collect the opps

      Map<Id, Account> queryAcc = new Map<Id, Account>(
        [
          SELECT
            Id,
            ownerId,
            (SELECT Id, AccountId FROM Contacts),
            (SELECT Id, AccountId FROM Opportunities)
          FROM Account
          WHERE Id IN :mapAcc.keySet()
          WITH USER_MODE
        ]
      );

      for (Id accId : mapAcc.keySet()) {
        if (queryAcc.containsKey(accId)) {
          conToUpdate = queryAcc.get(accId).Contacts;
          oppToUpdate = queryAcc.get(accId).Opportunities;
        }
      }
      //* Loop through contacts
      if (!conToUpdate.isEmpty()) {
        for (Contact con : conToUpdate) {
          if (mapAcc.containsKey(con.AccountId)) {
            con.OwnerId = mapAcc.get(con.AccountId).OwnerId;
          }
        }
      }

      //* Loop through the oppp
      if (!oppToUpdate.isEmpty()) {
        for (Opportunity opp : oppToUpdate) {
          if (mapAcc.containsKey(opp.AccountId)) {
            opp.OwnerId = mapAcc.get(opp.AccountId).OwnerId;
          }
        }
      }

      //* Bulkify the code for account
      try {
        update as user oppToUpdate;
        update as user conToUpdate;
      } catch (System.DmlException dmlExp) {
        List<System_Event__c> listErrros = new List<System_Event__c>(); //* add the error to the system event object

        for (Integer i = 0; i < dmlExp.getNumDml(); i++) {
          System_Event__c errorRecord = Logger.loggError(
            dmlExp.getStackTraceString(),
            dmlExp.getMessage(),
            dmlExp.getDmlId(i)
          );
          listErrros.add(errorRecord);
        }
      }
    }
  }
  //! Duplicate Accounts
  public static void accountDuplicateCheck(List<Account> newAccountList) {
    Map<String, String> mapAcc = new Map<String, String>();

    if (!newAccountList.isEmpty()) {
      for (Account acc : newAccountList) {
        mapAcc.put(acc.Name, acc.Rating);
        System.debug('Map of records getting inserted :' + mapAcc);
      }
    }
    //* Query the existing accounts
    List<Account> existingAcc = ([
      SELECT Name, Rating
      FROM Account
      WHERE
        Name IN :mapAcc.keySet()
        AND Rating IN :mapAcc.values()
        AND Id NOT IN :newAccountList
    ]);
    if (!existingAcc.isEmpty()) {
      for (Account newAcc : newAccountList) {
        if (
          mapAcc.containsKey(newAcc.Name) &&
          mapAcc.get(newAcc.Name) == newAcc.Rating
        ) {
          newAcc.addError('We alreday has the same account name and rating');
        } else {
          existingAcc.add(newAcc);
        }
      }
    }
  }
  //! Create N of locatons as per the number on account
  public static void numberOfLocations(List<Account> newAccountList) {
    if (!newAccountList.isEmpty()) {
      for (Account acc : newAccountList) {
        if (acc.NumberofLocations__c != null) {
        }
      }
    }
  }
  //!Create number of locations
  public static void accountLocations(List<Account> newAccountList) {
    List<Custom_Locations__c> listAccLocation = new List<Custom_Locations__c>(); //* Collect the locations

    if (!newAccountList.isEmpty()) {
      for (Account acc : newAccountList) {
        if (acc.Number_Of_Locations__c != null) {
          for (Integer i = 1; i <= acc.Number_Of_Locations__c; i++) {
            Custom_Locations__c accLocations = new Custom_Locations__c();
            accLocations.Account__c = acc.Id;
            accLocations.City__c = acc.ShippingCity;
            accLocations.Name = acc.Name;
            accLocations.OwnerId = acc.OwnerId;

            listAccLocation.add(accLocations);
          }
        }
      }
      //* Bulkfy the code
      if (!listAccLocation.isEmpty()) {
        try {
          insert as user listAccLocation;
        } catch (System.DmlException dmlExp) {
          List<System_Event__c> listErrros = new List<System_Event__c>(); //* add the error to the system event object

          for (Integer i = 0; i < dmlExp.getNumDml(); i++) {
            System_Event__c errorRecord = Logger.loggError(
              dmlExp.getStackTraceString(),
              dmlExp.getMessage(),
              dmlExp.getDmlId(i)
            );
            listErrros.add(errorRecord);
          }

          insert as user listErrros;
        }
      }
    }
  }
  // //!Update the account sales rep field
  // public static void addSalesRepFiledAccount(List<Account> newAccountList) {

  //     if (!newAccountList.isEmpty()) {
  //         //* Loop through the records
  //         for (Account acc : newAccountList) {
  //             if(acc.Sale)
  //         }
  //     }
  // }
}

/**
 * @description       : 
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @group             : 
 * @last modified on  : 06-04-2024
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
**/
public with sharing class PS_SOQLDemo {

    //! Search accounts 
    public static void searchAccount(String accName) {
        String searchField = '%'+accName+'%';

        List<Account> searchAccounts = [SELECT Id, Name FROM Account WHERE Name LIKE : searchField];
        System.debug('The searched Accounts 🧾: '+ searchAccounts);
    }

    //* Polymorphic query 
    public static void polymorphicQuery() {

        List<Task> taskRecords = [SELECT Id, WhoId, WhatId, TYPEOF Who
                                    WHEN Contact 
                                    THEN Id, Name
                                    WHEN Lead
                                    THEN Id, Name, Phone END,
                                    TYPEOF What
                                    WHEN Account
                                    THEN Id, Name, Industry
                                    WHEN Opportunity
                                    THEN Id, Name, Amount END
                                    FROM Task];
                                    
        System.debug('The poly query :🧬' + taskRecords.size());

        for (Task t : taskRecords) {
            if (t.Who instanceof Contact) {
                Contact con = t.Who;
                System.debug('The contact record :' + con);
            }
            if (t.Who instanceof Lead) {
                Lead led = t.Who;
                System.debug('The lead records :' + led);
            }
            if (t.What instanceof Account) {
                Account acc = t.What;
                System.debug('The account records:' + acc);
            }
        }
    }
    //* For loop demo
    public static void soqlForLoopDemo() {
        
        //* Loop on Account
        for (Account acc : [SELECT Id, Name From Account WITH USER_MODE LIMIT 10]) {

            for (Integer i=0; i <= 10; i++) {

                System.debug('This is my Account :🥊' + i + acc);
            }
            
        }
    }

    //* List of industries
    public static void accountIndustriesName(List<String> accIndustries, String accName) {

        String accSearch = '%'+accName+'%';
        //* Run the query 
        List<Account> acc = [SELECT Id, Name FROM Account WHERE Industry IN : accIndustries AND Name Like : accSearch];
        System.debug('Account size :🧷'+ acc.size());
    }
    
    //* All Methods for soql
    public static void allSOQL() {

        //* All contacts without account
        List<Contact> conNoAccount = [SELECT Id, Name FROM Contact WHERE AccountId = NULL WITH USER_MODE];
        System.debug('The size of contact with no Account :'+ conNoAccount.size());

        List<Contact> conWithAccount = [SELECT Id, Name FROM Contact WHERE AccountId = NULL WITH USER_MODE];
        System.debug('The size of contact with Account:'+ conWithAccount.size());

        List<Account> accWithoutContact = [SELECT Id, Name FROM Account WHERE Id NOT IN (SELECT AccountId FROM Contact WHERE AccountId != null) WITH USER_MODE];
        System.debug('The account records without contacts :' + accWithoutContact.size());

        List<AggregateResult> accWithOneMinContact = [SELECT COUNT(Id), AccountId accId FROM Contact WHERE AccountId != NULL WITH USER_MODE GROUP BY AccountId HAVING COUNT(Id) > 1];
        for (AggregateResult aggRes : accWithOneMinContact) {
            
            String accountId = (String) aggRes.get('accId');
            System.debug('The accountID with one contact :' + accountId);
        }

    }

}
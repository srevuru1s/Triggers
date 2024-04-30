
Map<Integer,String> myCourses = new Map<Integer,String>();
myCourses.put(100, 'Java');
myCourses.put(101, 'JavaScript');
myCourses.put(100, 'Salesforce');
myCourses.put(100, 'C+++');
Map<Integer,String> myCourses1 = new Map<Integer,String>();
System.debug('My Values in Map ***'+ myCourses.values());
System.debug('My Keys in Map ***'+ myCourses.keySet());
System.debug('My Map has a key ***'+ myCourses.containsKey(100));


String myAccName = [SELECT Id, Name FROM Account LIMIT 1].Name;
System.debug('The soql Name ***:' + myAccName);

String accId = [SELECT Id, AccountId, Account.Name FROM Contact WHERE AccountId != null LIMIT 1].AccountId;
System.debug('The Account ifd *** '+ accId);

Integer allAccounts = [SELECT COUNT() FROM Account];
System.debug('All ** '+ allAccounts);


List<AggregateResult> aggResults = [SELECT COUNT(ID) totalOpps, StageName  FROM Opportunity WITH USER_MODE GROUP BY StageName];

for (AggregateResult agg : aggResults) {
    Integer oppTotal = (Integer) agg.get('totalOpps');
    System.debug('The number of Opp ***'+ oppTotal);
    String oppStageName = (String) agg.get('StageName');
    System.debug('The Opp Stage Name :'+ oppStageName);
}

for (Account myAcc : [SELECT Id, Name, (SELECT Id, Name FROM Contacts) From Account WHERE Name LIKE '%Test%' WITH USER_MODE LIMIT 1]) {
    System.debug('My Account ***:'  + myAcc);
    for (Contact myContact : myAcc.Contacts) {
        System.debug('My Contacts to Acc :' + myContact);
    }
}



for ( AggregateResult myAgg : [SELECT COUNT(ID), Name, Rating FROM Account GROUP BY Name, Rating]) {
    System.debug(myAgg);
}

List<Task> myTask = [SELECT Id, WhoId, WhatId FROM Task];
System.debug('MY TASK ***'+ myTask);    


List<List<SObject>> soslResults = [FIND '*uni*' IN ALL FIELDS RETURNING Account(Id, Name),
                                    Contact(Id, Name, Email), Opportunity, Lead, Case];
System.debug('The SOSL Results ***'+ soslResults);
List<Account> myAccount = soslResults.get(0);
System.debug('Accounts **:'+ myAccount);                            


List<String> myList = new List<String>{'sagar', 'ava', 'sagar', 'ava'};
System.debug(myList);
Set<String> mySet = new Set<String>();
mySet.addAll(myList);
System.debug('Here is the list :' + mySet);
System.debug('Here is the list :' + mySet.size());

Map<Id,Account> myAccount  = new Map<Id,Account>();

List<Account> myList = [SELECT Id, Name FROM Account LIMIT 20];
Set<Id> mySet = new Set<Id>();
for (Account acc : myList) {
    myAccount.put(acc.Id, acc);
    mySet.add(acc.Id);
}
System.debug('The size of the Map: '+ myAccount?.size());
System.debug('The Ids from the List :' + mySet);
System.debug('Map Contains the values :' + myAccount.containsKey('001am000000fer9AAA'));
System.debug('Keys in the map:' + myAccount.values());
System.debug('Keys in the Map :' + myAccount.keySet());

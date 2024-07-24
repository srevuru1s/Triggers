
Integer i = 0;

for (List<Contact> con : [SELECT Id, FirstName FROM Contact]) {

    con.get(0).FirstName = 'My Name id Sagar';
    i++;
    System.debug('Updated contact:' + con.get(0).FirstName);
}
System.debug('The number of iterations of FOR :' + i);

Map<Id,Contact> myContact = new Map<Id,Contact>([SELECT Id, FirstName From Contact]);
System.debug(myContact.size());
System.debug(myContact.get('003am0000007FdRAAU').FirstName);


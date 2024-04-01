// Use .apex files to store anonymous Apex.
// You can execute anonymous Apex in VS Code by selecting the
//     apex text and running the command:
//     SFDX: Execute Anonymous Apex with Currently Selected Text
// You can also execute the entire file by running the command:
//     SFDX: Execute Anonymous Apex with Editor Contents

Map<String,Map<String,String>> accountContactOpportunityMap = new Map<String,Map<String,String>>();

Map<String,String> accContactMap = new Map<String,String>();
Map<String,String> accOpportunityMap = new Map<String,String>();
Map<String,String> contactOpportunityMap = new Map<String,String>();


for (Account acc : [SELECT Id, Name, (SELECT Id, FirstName FROM Contacts ORDER BY LastModifiedDate DESC LIMIT 1), (SELECT Id, Name FROM Opportunities ORDER BY LastModifiedDate DESC LIMIT 1) FROM Account LIMIT 10]) {
    
    if(acc.Contacts.size() >0 && acc.Opportunities.size() > 0){

        accContactMap.put(acc.Name, acc.Contacts[0].FirstNameName);
        
        accOpportunityMap.put(acc.Name, acc.Opportunities[0].Name);

        contactOpportunityMap.put(accContactMap.get(acc.Name), accOpportunityMap.get(acc.Name));

        accountContactOpportunityMap.put(acc.Name, contactOpportunityMap);
    }
}

System.debug('Parentmap Details :' + accountContactOpportunityMap);

CaseEnumSwitch.updateCaseStatus('500am000000HhsjAAC', CaseEnum.Status.ACTIVE);

List<String> myName = new List<String>();
myName.add('Sagar');
myName.add('Ava');
String myDaughter = (String) myName.get(0);

System.debug('Ava Revuru 🤩:'+ myDaughter);

/**
 * @description       : 
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @group             : 
 * @last modified on  : 06-05-2024
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
**/
public with sharing class DMLDemo {

    public static void insertDemo(String name, String rating, String phone) {
        Account acc = new Account();
        acc.Name    = name;
        acc.Rating  = rating;
        acc.Phone   = phone;

        insert as user acc;
    }
    public static void insertForLoopDemo() {
        
        List<Account> listAcc = new List<Account>();

        for (Integer i = 0; i < 150; i++) {
        
            Account acc = new Account();
            acc.Name    = 'Apex ' + i;
            acc.Rating  = 'Hot';
            acc.Phone   = '123456565' + i;

            listAcc.add(acc);
        }    
        insert as user listAcc;
    }

    public static void updateDemo() {
        
        List<Account> accUpdate = new List<Account>();

        for (Account acc : [SELECT Id, Name, Phone FROM Account WHERE Name LIKE '%Apex%' LIMIT 150]) {

            acc.Name = acc.Name + ' Updated';

            accUpdate.add(acc);
        }
        update as user accUpdate;
    }    
    public static void deleteDemo() {
        
        List<Account> accUpdate = [SELECT Id, Name, Phone FROM Account WHERE Name LIKE '%Apex%' LIMIT 150];

        delete as user accUpdate;
    }    
    public static void undeleteDemo() {
        
        List<Account> accUpdate = [SELECT Id, Name, Phone FROM Account WHERE Name LIKE '%Apex%' LIMIT 150 ALL ROWS];

        undelete as user accUpdate;
    } 
}
/**
 * @description       : 
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @group             : 
 * @last modified on  : 04-09-2024
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
**/
public with sharing class StaticMethod {
    public static Integer rollNumber = 0;
    //* To access the class level variable we can use this key word
    private Decimal balance;
    
    public StaticMethod() {
        rollNumber ++;
        System.debug('Constructor called ***:'+ rollNumber);
        this.balance = rollNumber + 0.1;
        System.debug('Private variable in constructor ***'+ this.balance);
    }
    
    public void method1() {
        System.debug('Method 1 is called');
        System.debug('Private variable');
        System.debug('The Balance ***: '+ this.balance);
        this.balance +=  0.12;
        System.debug('Private value ***'+ this.balance);
        
    }
}
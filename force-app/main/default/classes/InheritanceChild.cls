/**
 * @description       : 
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @group             : 
 * @last modified on  : 04-09-2024
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
**/
public with sharing class InheritanceChild extends InheritanceDemo{

    public InheritanceChild(Decimal initialBalance) {
        super(initialBalance);
        Integer myScore = 900;
        System.debug('My Score ***:' + myScore);    
    }
    
    public void display() {
        System.debug('Balance from parent ***:'+balance);
    }

    public override Decimal getBalance() {
        Decimal myPayment = 44.56;
        return myPayment;
    }
}
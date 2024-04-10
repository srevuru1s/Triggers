/**
 * @description       : 
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @group             : 
 * @last modified on  : 04-09-2024
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
**/
public with sharing virtual class InheritanceDemo {
    protected Decimal balance;
    private Integer myAccountNumber = 200202;
    
    public InheritanceDemo(Decimal initialBalance) {
        this.balance = initialBalance > = 0 ? initialBalance : 0;
        System.debug('Balance in parent constructor **:'+ this.balance);
    }

    protected virtual Decimal getBalance() {
        return balance;
    }
}
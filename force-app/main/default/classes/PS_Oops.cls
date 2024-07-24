/**
 * @description       : 
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @group             : 
 * @last modified on  : 06-04-2024
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
**/
public with sharing class PS_Oops {
    
    String name;
    public static Integer myNumber;



    {
        String instanceName = 'This is instance block';
        System.debug('This is the instance block');
    
    }

    Static {
        String staticBlock = 'This is static block';
        System.debug('This is the static block');
    }

    private PS_Oops() {
        System.debug('Hello Im the constructor');
        this.name = 'Sagar';
        System.debug('Name value :' + this.name);
    }

    //* returning the instance
    public static PS_Oops getInstance() {
        return new PS_Oops();
    }

    public static void myFirstMethod() {
        System.debug('Im in the first static method');
        myNumber = 10;
        System.debug('This is the number :' + myNumber);
    }

    public void mySecondMethod() {
        System.debug('Im in the secons instance method');
        System.debug('Printing the this :'+this);
        System.debug('Im refering the sinstance variable :' + this.name);
    }

}
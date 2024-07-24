/**
 * @description       : 
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @group             : 
 * @last modified on  : 06-06-2024
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
**/
public with sharing abstract class PS_Shape {

    public PS_Shape(String name){

    }

    // public abstract Decimal abstractMethod();

    public void displayArea(){
        System.debug('Im the display abstarct class method');
    }
}
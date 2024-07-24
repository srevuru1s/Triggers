/**
 * @description       : 
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @group             : 
 * @last modified on  : 06-06-2024
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
**/
public with sharing class PS_Circle extends PS_Shape {
    
    // public override Decimal abstractMethod() {
    //     System.debug('The area of circle method from child');
    //     return 0.5;
    // }

    public PS_Circle() {
        super('circle');
        System.debug('This is the circle constructor.');
        super.displayArea();
    }
    
}
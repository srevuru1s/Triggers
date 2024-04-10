/**
 * @description       : 
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @group             : 
 * @last modified on  : 04-09-2024
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
**/
public with sharing class ImplementClass implements IShape{
    

    public void draw(){
        System.debug('ImplementClass.draw() -> This method has been invoked.');
    }

    public String getColor(){
        return 'Grey';
    }

    public String name(){
        return 'Ava';
    }

}
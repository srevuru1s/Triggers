/**
 * @description       : 
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @group             : 
 * @last modified on  : 05-23-2024
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
**/
public with sharing class PS_GetterSetter {

    public String name { public get {

        System.debug('get name is working...');
        return 'getName() is working...';
        }  public set{

        System.debug('set name is working...');
        this.name = value;
        System.debug(this.name);
        }
    }

    Integer myNumber;

    //? General Methods to call the variables
    public String getName(){
        System.debug('getName() is working...');
        this.name = 'Ava Revuru';
        return name;
    }
    public Integer getMyNumber(){
        System.debug('getMyNumber() is working...');
        this.myNumber = 001;
        return myNumber;
    }

    public static void callByValue(Integer a, Integer b) {
        a = 5;
        b = 10;

        System.debug('The values of a and b:' + a + ' ' + b);
        System.debug('The values of a and b after passing by value:' + a + ' ' + b);
    }

    public static List<Integer> callByReference(List<Integer> list1, List<Integer> list2) {
        list1.add(1);
        list2.add(2);

        return list2;
    }    
}
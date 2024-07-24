/**
 * @description       : 
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @group             : 
 * @last modified on  : 06-06-2024
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
**/
public virtual class PS_Marker {

    protected String markerName;
    protected String color;

    protected PS_Marker() {
        System.debug('This is the marker constructor.');
        // super('Marker', 'Marker'); //* calling the parent class constructor
        // this.markerName = markerName;
        // this.color = color;   
    }
    

    protected virtual void write(){

        System.debug('Hello Im parent class method');
    }

    protected virtual void writeNew(){
        System.debug('This is the virtual method');
    }
}
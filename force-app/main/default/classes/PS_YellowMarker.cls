/**
 * @description       : 
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @group             : 
 * @last modified on  : 06-06-2024
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
**/
public class PS_YellowMarker extends PS_Marker {

    public PS_YellowMarker(){
        System.debug('This is the yellow marker constructor.');
        // super('Yellow Marker', 'Yellow'); //* calling the parent class constructor
    }
        // super('Yellow Marker', 'Yellow'); //* calling the parent class constructor
    
    public void printInfo(){

        System.debug(super.markerName);
        System.debug(super.color);
        super.write();
        super.writeNew();
    }

    public override void write(){

        System.debug('Hello Im over wriding the yellow marker to Red');
    }

    public override void writeNew(){

        System.debug('This is the virtual override method');
    }
}
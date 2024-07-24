/**
 * @description       : 
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @group             : 
 * @last modified on  : 05-01-2024
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
**/
public with sharing class TaskTriggerHelper {
    public static void updateOppStageToCloseWon(Set<Id> accId) {

        //* Collect the Opps that need to be updated

        List<Opportunity> toBeUpdated = new List<Opportunity>();

        //*  Check the account id is not empty 
        if(accId?.isEmpty() == false) {


            //* Query the opportunities
            List<Opportunity> ops = [SELECT ID, StageName FROM Opportunity WHERE AccountId IN : accId WITH USER_MODE];
            //* Check the opportunities is not empty
            if (ops?.isEmpty() == false) {
                //* Iterate through the opportunities
                for (Opportunity op : ops) {
                    //* Update the opportunity stage
                    if (op.StageName != 'Closed Won' && op.StageName != 'Closed Lost' ) {
                        op.StageName = 'Closed Won';
                        //* Add the opportunity to the to be updated list
                        tobeUpdated.add(op);
                    }    
                }
            }
        }
        //* Check the tobeUpdated list is not empty
        if (tobeUpdated?.isEmpty() == false) {
            //! Update the opportunity
            try {
                
                update as user tobeupdated;
            } catch (DmlException dmlExp) {

                Logger.triggererror(dmlExp);

            } catch (Exception allExp) {

                Logger.triggerAllErrors(allExp);
            }
        }
    }
}
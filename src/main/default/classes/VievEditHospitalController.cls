/**
 * Created by dominik.barchanski on 27.04.2022.
 */

public with sharing class VievEditHospitalController {
    public Hospital__c hosp { get; set; }
    public String docId { get; set; }
    public List<Contract__c> listOfContract {get;set;}
    public Boolean pageMode { get; set; }
    public VievEditHospitalController(ApexPages.StandardController controller) {
        for (ChildRelationship relation : SObjectType.Hospital__c.getChildRelationships()){

        }


        List<String> fields = new List<String>(Schema.getGlobalDescribe().get('Hospital__c').getDescribe().fields.getMap().keySet());
        List<String> fieldsContract = new List<String>(Schema.getGlobalDescribe().get('Contract__c').getDescribe().fields.getMap().keySet());
        docId = ApexPages.currentPage().getparameters().get('id');
        if (docId != null) {
            pageMode = (ApexPages.currentPage().getParameters().get('mode') == 'edit' ? true : false);
            hosp = Database.query('SELECT ' + String.join(fields, ',') + ' FROM Hospital__c WHERE Id =:docId LIMIT 1');
            listOfContract = Database.query('SELECT ' + String.join(fieldsContract, ',') + ' FROM Contract__c WHERE Hospital_Names__c =:docId ');
        }else{
            hosp = new Hospital__c();
        }
    }

    public PageReference save() {

        try {
            if(hosp.Id !=null){
                hosp.TriggerProcess__c = false;
                hosp.Schedule_Counter__c = 0 ;
                update hosp;
                PageReference pageRef = new PageReference('/apex/ViewHospital?id='+ hosp.id).setRedirect(true);
                return pageRef;
            }else {
                hosp.TriggerProcess__c = false;
                hosp.Schedule_Counter__c = 0 ;
                insert hosp;
                PageReference pageRef = new PageReference('/apex/ViewHospital?id='+ hosp.Id).setRedirect(true);
                return pageRef;
            }
        } catch (DmlException e) {
            ApexPages.addMessages(e);
        }
        return null;
    }

    public PageReference saveAndNew() {
        save();
        return new PageReference('/apex/EditHospital').setRedirect(true);

    }
    public void DeleteHospital() {
        Hospital__c removeHospital = [SELECT Id FROM Hospital__c WHERE Id =: docId LIMIT 1];
        if (removeHospital != null){
            try{
                delete removeHospital;
            }catch (DmlException e){
                ApexPages.addMessages(e);
            }

        }
    }
}
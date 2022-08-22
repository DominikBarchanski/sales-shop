/**
 * Created by dominikbarchanski on 21/05/2022.
 */

global with sharing class REST_HospitalDTO {
    global String hospitalId;
    global String hospitalExternalId;
    global String hospitalName;
    global String hospitalPhone;
    global String hospitalEmail;
    global String hospitalCountry;
    global String hospitalCity;
    global String hospitalStreet;
    global String paramId;
    global Boolean hospitalCheckBox;
    global REST_HospitalDTO(Hospital__c hospital) {
        Boolean boolState;
        if(hospital.TriggerProcess__c != true){
            boolState = false;
        }else{
            boolState = true;
        }
        this.hospitalCheckBox = boolState;
        this.hospitalExternalId = hospital.externalId__c;
        this.paramId = hospital.paramId__c;
        this.hospitalId = hospital.Id;
        this.hospitalName = hospital.Name;
        this.hospitalPhone = hospital.Phone__c;
        this.hospitalEmail = hospital.Email__c;
        this.hospitalCountry = hospital.Country__c;
        this.hospitalCity = hospital.City__c;
        this.hospitalStreet = hospital.Street__c;
    }
}
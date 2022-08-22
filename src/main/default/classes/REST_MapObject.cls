/**
 * Created by dominikbarchanski on 21/05/2022.
 */

global with sharing class REST_MapObject {

    global static Hospital__c mapToHospitalFromDTO(REST_HospitalDTO hospitalDTO) {
//        List<Hospital__c> mappedHospital;
        Hospital__c hospitalToList = new Hospital__c();
//        for (REST_HospitalDTO item:hospitalDTO) {
//        if (String.isNotBlank(hospitalDTO.hospitalExternalId)) {
//
//        }else{
//
//        }
//        hospitalToList.externalId__c = hospitalDTO.hospitalExternalId;
        hospitalToList.externalId__c = hospitalDTO.hospitalExternalId;
        hospitalToList.Id = hospitalDTO.hospitalId;
        hospitalToList.Name = hospitalDTO.hospitalName;
        hospitalToList.Phone__c = hospitalDTO.hospitalPhone;
        hospitalToList.Email__c = hospitalDTO.hospitalEmail;
        hospitalToList.Country__c = hospitalDTO.hospitalCountry;
        hospitalToList.City__c = hospitalDTO.hospitalCity;
        hospitalToList.Street__c = hospitalDTO.hospitalStreet;
//        System.debug()
        if (hospitalDTO.hospitalCheckBox != true) {
            hospitalToList.TriggerProcess__c = false;
        }else {
            hospitalToList.TriggerProcess__c = true;
        }
//            mappedHospital.add(hospitalToList);
//        }
        return hospitalToList;

    }
    global static Hospital__c mapToHospitalFromDTOnId(REST_HospitalDTO hospitalDTO) {
//        List<Hospital__c> mappedHospital;
        Hospital__c hospitalToList = new Hospital__c();
//        for (REST_HospitalDTO item:hospitalDTO) {
        hospitalToList.paramId__c = hospitalDTO.hospitalId;
        hospitalToList.externalId__c=hospitalDTO.hospitalExternalId;
        hospitalToList.TriggerProcess__c = hospitalDTO.hospitalCheckBox;
        hospitalToList.Name = hospitalDTO.hospitalName;
        hospitalToList.Phone__c = hospitalDTO.hospitalPhone;
        hospitalToList.Email__c = hospitalDTO.hospitalEmail;
        hospitalToList.Country__c = hospitalDTO.hospitalCountry;
        hospitalToList.City__c = hospitalDTO.hospitalCity;
        hospitalToList.Street__c = hospitalDTO.hospitalStreet;
//            mappedHospital.add(hospitalToList);
//        }
        return hospitalToList;

    }


}
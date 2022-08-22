/**
 * Created by dominikbarchanski on 22/05/2022.
 */

public with sharing class TurboHospitalFinderController {
    public Hospital__c hosp { get; set; }
    public Hospital__c newDoctorToSoap { get; set; }
    public List<REST_HospitalDTO> listOfFindedHosp { get; set; }
    public String selectedCountry { get; set; }
    public String selectedCountryTest { get; set; }
    public Boolean renderRespondTable { get; set; }
    public Boolean renderNewDoctor { get; set; }
    public String hospitalToEdit { get; set; }
    public String HospitalToDeleteDTO { get; set; }
    public String displayClass { get; set; }
    public Hospital__c hospitalToEditInDb { get; set; }
    public Hospital__c hospitalToDeleteInDb { get; set; }
    public String elementList { get; set; }
    public String messageFunction { get; set; }
    public Boolean isClicked { get; set; }
    public String toastThem { get; set; }
    public List<String> picklistItem { get; set; }
    public List<SelectOption> picklistItemSet { get; set; }
    public Map<String, Hospital__c> listOfDTO { get; set; }

    public String searchResultInfo { get; set; }
    private static final String endpoint = 'callout:RestHospital/services/apexrest/HospitalRafal/';
    public TurboHospitalFinderController() {
        searchResultInfo = '';
        toastThem = 'slds-theme_success';
        isClicked = false;
        messageFunction = '';
        displayClass = 'slds-hide';
        hosp = new Hospital__c();
        listOfDTO = new Map<String, Hospital__c>();
        newDoctorToSoap = new Hospital__c();
        renderRespondTable = false;
        renderNewDoctor = false;
        elementList = '';
        hospitalToEdit = null;
        HospitalToDeleteDTO = null;
        hospitalToEditInDb = new Hospital__c();
        hospitalToDeleteInDb = new Hospital__c();
        picklistItem = new List<String>();
        picklistItemSet = new List<SelectOption>();
        picklistValueSet();

    }
//    private static final String endpoint = 'callout:RestHospital/services/apexrest/HospitalRafal/';HospitalRafal

    public PageReference search() {
        Http http = new Http();
        HttpRequest request = new HttpRequest();


        System.debug(selectedCountryTest);

        request.setEndpoint(endpoint + '?Name=' + (hosp.Name == null ? '' : hosp.Name.replace(' ', '+')) + '&Country=' + (selectedCountryTest == null || selectedCountryTest == '-None-' ? '' : selectedCountryTest.replace(' ', '+')));
        request.setHeader('Content-Type', 'application/x-www-form-urlencoded');
        request.setHeader('Content-Type', 'application/json');
        request.setHeader('accept', 'application/json');
        request.setHeader('Authorization', 'Bearer ' + Userinfo.getSessionId());
        request.setMethod('GET');

        listOfDTO = new Map<String, Hospital__c>();
        HttpResponse response = http.send(request);
        String jsonResp = response.getBody();

        listOfFindedHosp = (List<REST_HospitalDTO>) JSON.deserialize(jsonResp, List<REST_HospitalDTO>.class);
        system.debug(listOfFindedHosp);
        renderRespondTable = true;
        for (REST_HospitalDTO item : listOfFindedHosp) {
            Hospital__c hopsToadd = REST_MapObject.mapToHospitalFromDTOnId(item);
//            hospitalWrapper itemToDisp = new hospitalWrapper(hopsToadd);
//            itemToDisp.hopsId =item.hospitalId;
            listOfDTO.put(item.hospitalId, hopsToadd);
        }
        System.debug(listOfDTO);
        LogBuilder.createLog(null, request, response);
        if (selectedCountryTest != null) {
            selectedCountry = selectedCountryTest;
        }
//        selectedCountryTest=null;
        return null;
    }
    public PageReference addDoctorToDB() {

        if (hospitalToEdit != null) {
            if (String.isNotBlank(hospitalToEditInDb.Name)) {
                if (null == null) {
                    messageFunction = 'Record Edited Successfully';
//                ApexPages.AddMessage(new ApexPages.Message(ApexPages.Severity.CONFIRM, ''));
                    displayClass = 'slds-hide';
                    system.debug('objekt kliknięty :' + hospitalToEditInDb);
                    REST_HospitalDTO hospToEdit = new REST_HospitalDTO(hospitalToEditInDb);
                    hospToEdit.hospitalCountry = selectedCountry;
                    system.debug('objekt edytowany :' + hospToEdit);
                    if (String.isNotBlank(hospToEdit.hospitalExternalId)) {
                        hospToEdit.hospitalExternalId = hospToEdit.hospitalId;
                        hospToEdit.hospitalId = hospToEdit.paramId;
                    } else {
                        hospToEdit.hospitalId = hospToEdit.paramId;
                        hospToEdit.hospitalExternalId = null;
                        hospToEdit.paramId = null;
                    }
                    system.debug(hospToEdit);
                    hospToEdit.hospitalId = hospitalToEdit;
//                    if (hospToEdit.hospitalId == hospToEdit.hospitalExternalId) {
//
//                        hospToEdit.hospitalExternalId = null;
//                    }
//                    System.debug(externalid);

                    System.debug('obiekt po edycji' + hospToEdit);

                    hospToEdit.hospitalCheckBox = false;

                    HttpRequest editRequest = REST_Callout.createPatchHospitalRequest(hospToEdit);
                    System.debug('obiekt po zrobieniu zapytania ' + editRequest.getBody());
                    Http http = new Http();
                    HttpResponse response = http.send(editRequest);
                    System.debug(response.getBody());
                    selectedCountry = '';

                    search();
                    LogBuilder.createLog(null, editRequest, response);
                } else {
                    return null;
                }
            } else {
                messageFunction = 'Can\' edit Hospital missing name';
                toastThem = 'slds-theme_error';
//                displayClass = 'hidden';
                displayClass = 'slds-hide';
                return null;
            }
        } else {
            if (String.isNotBlank(hospitalToEditInDb.Name)) {
                if (null == null) {
                    messageFunction = 'Record Created Successfully.';
                    REST_HospitalDTO hospToEdit = new REST_HospitalDTO(hospitalToEditInDb);
                    hospToEdit.hospitalCountry = selectedCountry;
                    HttpRequest editRequest = REST_Callout.createPostHospitalRequest(hospToEdit);
                    Http http = new Http();
                    HttpResponse response = http.send(editRequest);
                    displayClass = 'slds-hide';
                    selectedCountry = '';

                    search();
                    LogBuilder.createLog(null, editRequest, response);
                    return null;
                } else {
                    return null;
                }
            } else {
                messageFunction = 'Can\' add Hospital required name';
                toastThem = 'slds-theme_error';
                displayClass = 'slds-hide';
                return null;
            }
        }


        return null;

    }
    public void picklistValueSet() {

        HttpRequest editRequest = REST_Callout.createPutHospitalRequest();
        Http http = new Http();
        HttpResponse response = http.send(editRequest);
        String jsonResp = response.getBody();
        picklistItem = (List<String>) JSON.deserialize(jsonResp, List<String>.class);
        picklistItemSet.add(new SelectOption('', '-None-'));
        for (String item : picklistItem) {
            picklistItemSet.add(new SelectOption(item, item));
        }
    }
    public PageReference editDoctorToDB() {
        System.debug(hospitalToEdit);
        isClicked = false;
        displayClass = '';
        hospitalToEditInDb = listOfDTO.get(hospitalToEdit);
        selectedCountry = listOfDTO.get(hospitalToEdit).Country__c;
        toastThem = 'slds-theme_success';
        system.debug(hospitalToEditInDb);
        return null;

    }
    public PageReference showModalNew() {
        toastThem = 'slds-theme_success';
        hospitalToEditInDb = new Hospital__c();
        isClicked = false;
        hospitalToEdit = null;
        displayClass = '';
        return null;
    }
    public void cancelAction() {
        hospitalToEditInDb = new Hospital__c();
        toastThem = 'slds-theme_success';
        displayClass = 'slds-hide';
    }
    public void deleteDoctor() {

        hospitalToDeleteInDb = listOfDTO.get(HospitalToDeleteDTO);
        REST_HospitalDTO hospToEdit = new REST_HospitalDTO(hospitalToDeleteInDb);
        hospToEdit.hospitalId = hospToEdit.hospitalExternalId;
        hospToEdit.hospitalExternalId = hospToEdit.paramId;


        HttpRequest deleteRequest = REST_Callout.createDeleteHospitalRequest(hospToEdit);
        System.debug(deleteRequest);
        System.debug(deleteRequest.getBody());
        Http http = new Http();
        HttpResponse response = http.send(deleteRequest);

        System.debug(response.getBody());

        toastThem = 'slds-theme_success';
        messageFunction = 'Hospital Delete';
        search();
        LogBuilder.createLog(null, deleteRequest, response);
    }
}
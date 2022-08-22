/**
 * Created by dominikbarchanski on 15/05/2022.
 */

public with sharing class TurboDoctorFinderController {
    public Doctor__c doc { get; set; }
    public Doctor__c newDoctorToSoap { get; set; }
    public List<soapSforceComSchemasClassSoapservic.DoctorDTO> doctorListFromSoap { get; set; }
    public soapSforceComSchemasClassSoapservic.messageWrapper wholeResponse { get; set; }
    public String responseMessage { get; set; }
    public Boolean renderRespondTable { get; set; }
    public Boolean renderNewDoctor { get; set; }
    public Map<String, doctorWrapper> listOfDTO { get; set; }
    public String DoctorToDelete { get; set; }
    public String DoctorToEdit { get; set; }
    public String displayClass { get; set; }
    public Doctor__c doctorToEditInDb { get; set; }
    public String elementList { get; set; }
    public String messageFunction { get; set; }
    public Boolean isClicked { get; set; }
    public String toastThem { get; set; }
    public String searchResultInfo {get;set;}

    public TurboDoctorFinderController() {
        searchResultInfo= '';
        toastThem = 'slds-theme_success';
        isClicked = false;
        messageFunction = '';
        displayClass = 'slds-hide';
        listOfDTO = new Map<String, doctorWrapper>();
        doc = new Doctor__c();

        doctorToEditInDb = new Doctor__c();
        newDoctorToSoap = new Doctor__c();
        renderRespondTable = false;
        renderNewDoctor = false;
//        DoctorToDelete = '';
        elementList = '';
        DoctorToEdit = null;
    }
    public static soapSforceComSchemasClassSoapservic.SOAPService wS { get; set; }

    public soapSforceComSchemasClassSoapservic.SOAPService SoapConnector() {
        partnerSoapSforceCom.Soap partnerSoap = new partnerSoapSforceCom.Soap();

        partnerSoapSforceCom.LoginResult partnerSoapSession = partnerSoap.login('sztorcu18@gmail.com', 'zaq12wsxCLJrichsgIEduHFCyc1YHIlt');

        String sessionId = partnerSoapSession.sessionId; // Storing session id

        soapSforceComSchemasClassSoapservic.SessionHeader_element webServiceHeader = new soapSforceComSchemasClassSoapservic.SessionHeader_element();
        webServiceHeader.sessionId = sessionId;
        wS = new soapSforceComSchemasClassSoapservic.SOAPService();
        wS.SessionHeader = webServiceHeader;
        return wS;

    }

    public PageReference search() {
        soapSforceComSchemasClassSoapservic.SOAPService webServiceCall = SoapConnector();
//        string lastname
        toastThem = 'slds-theme_success';
        wholeResponse = webServiceCall.getRecord(doc.Name, doc.First_Name__c, doc.Country__c);
        doctorListFromSoap = wholeResponse.doctorList;
        responseMessage = wholeResponse.message;
        listOfDTO = new Map<String, doctorWrapper>();
        renderNewDoctor = false;
        if (responseMessage != null) {
            renderRespondTable = false;
        } else {
            renderRespondTable = true;
            for (soapSforceComSchemasClassSoapservic.DoctorDTO item : doctorListFromSoap) {
                Doctor__c doctorFromApi = new Doctor__c();


                doctorFromApi.Name = item.lastName;
                doctorFromApi.First_Name__c = item.firstName;
                doctorFromApi.Country__c = item.country;
                doctorFromApi.Phone__c = item.phone;
                doctorFromApi.Specialization__c = item.specialty;
                doctorFromApi.Email__c = item.emailAdr;
                doctorWrapper doctorToDisplay = new doctorWrapper(doctorFromApi);
                doctorToDisplay.doctorId = item.drID;
                listOfDTO.put(item.drID, doctorToDisplay);
            }
        }
        if (listOfDTO.size() > 0){
            searchResultInfo = '';
        }else {
            searchResultInfo = '0 Record found';
        }

        return null;
    }
//    public PageReference displayCreateTable() {
//        renderNewDoctor = true;
//        renderRespondTable = false;
//        return null;
//    }
    public PageReference addDoctorToDB() {
        isClicked = true;
        soapSforceComSchemasClassSoapservic.SOAPService webServiceCall = SoapConnector();
        soapSforceComSchemasClassSoapservic.messageWrapper result;

        if (DoctorToEdit != null) {
            if (String.isNotBlank(doctorToEditInDb.Name)) {
                result = webServiceCall.editExistDoctor(DoctorToEdit, doctorToEditInDb.Name, doctorToEditInDb.First_Name__c, doctorToEditInDb.Phone__c, doctorToEditInDb.Email__c, doctorToEditInDb.Specialization__c, doctorToEditInDb.Date_of_birth__c, doctorToEditInDb.Country__c, doctorToEditInDb.City__c, doctorToEditInDb.Street__c);

                if (result.message == null) {
                    messageFunction = 'Record Edited Successfully';
//                ApexPages.AddMessage(new ApexPages.Message(ApexPages.Severity.CONFIRM, ''));
                    displayClass = 'slds-hide';
                    search();
                } else {
                    return null;
                }
            } else {
                messageFunction = 'Can\' edit Doctor missing last name';
                toastThem = 'slds-theme_error';
//                displayClass = 'hidden';
                displayClass = 'slds-hide';
                return null;
            }
        } else {
            if (String.isNotBlank(doctorToEditInDb.Name)) {
                result = webServiceCall.saveNewDoctor(doctorToEditInDb.Name, doctorToEditInDb.First_Name__c, doctorToEditInDb.Phone__c, doctorToEditInDb.Email__c, doctorToEditInDb.Specialization__c, doctorToEditInDb.Date_of_birth__c, doctorToEditInDb.Country__c, doctorToEditInDb.City__c, doctorToEditInDb.Street__c);
                System.debug(result.message);
                if (result.message == null) {
                    messageFunction = 'Record Created Successfully.';
//                ApexPages.AddMessage(new ApexPages.Message(ApexPages.Severity.CONFIRM, 'Record Created Successfully.'));
                    displayClass = 'slds-hide';
                    search();
                    return null;
                } else {
                    return null;
                }
            }else{
                messageFunction = 'Can\' add Doctor required last name';
                toastThem = 'slds-theme_error';
                displayClass = 'slds-hide';
                return null;
            }
        }


        return null;
    }
    public PageReference editDoctorToDB() {
        isClicked = false;
        displayClass = '';
        doctorToEditInDb = listOfDTO.get(DoctorToEdit).doc;
        toastThem = 'slds-theme_success';
        system.debug(doctorToEditInDb);
        return null;
    }
    public PageReference showModalNew() {
        toastThem = 'slds-theme_success';
        isClicked = false;
        doctorToEditInDb = new Doctor__c();
        DoctorToEdit = null;
        displayClass = '';
        return null;
    }
    public void cancelAction() {
        doctorToEditInDb = new Doctor__c();
        toastThem = 'slds-theme_success';
        displayClass = 'slds-hide';
    }
    public void deleteDoctor() {

        soapSforceComSchemasClassSoapservic.SOAPService webServiceCall = SoapConnector();
        webServiceCall.deleteExistDoctor(DoctorToDelete);
        toastThem = 'slds-theme_success';
        messageFunction = 'Doctor Delete';
        search();
    }

    public class doctorWrapper {
        public Doctor__c doc { get; set; }
        public String doctorId { get; set; }
        public doctorWrapper(Doctor__c doctor) {
            this.doc = doctor;
        }
    }
}
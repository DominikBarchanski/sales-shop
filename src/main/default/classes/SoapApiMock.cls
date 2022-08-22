/**
 * Created by dominikbarchanski on 18/05/2022.
 */

@IsTest
global class SoapApiMock implements WebServiceMock {

    public String mode ;
    public static String ADD_DOC = 'ADD_DOC';
    public static String SER_DOC = 'SER_DOC';
    public static String DEL_DOC = 'DEL_DOC';
    public static String UPD_DOC = 'UPD_DOC';
//
    public SoapApiMock(String mockMode) {
        this.mode = mockMode;
    }
//
    global void doInvoke(
            Object stub,
            Object request,
            Map<String, Object> response,
            String endpoint,
            String soapAction,
            String requestName,
            String responseNS,
            String responseName,
            String responseType) {

        if (mode == ADD_DOC) {
            soapSforceComSchemasClassSoapservic.saveNewDoctorResponse_element saveResponse = new soapSforceComSchemasClassSoapservic.saveNewDoctorResponse_element();
            saveResponse.result = new soapSforceComSchemasClassSoapservic.messageWrapper();
            soapSforceComSchemasClassSoapservic.DoctorDTO newDoctorResponse = new soapSforceComSchemasClassSoapservic.DoctorDTO();
            newDoctorResponse.lastName = 'test';
            newDoctorResponse.emailAdr =null;
            newDoctorResponse.specialty =null;
            newDoctorResponse.phone =null;
            newDoctorResponse.country =null;
            newDoctorResponse.firstName =null;
            saveResponse.result.newAddingDoctor = newDoctorResponse;
            response.put('response_x', saveResponse);
        } else if (mode == SER_DOC) {
            soapSforceComSchemasClassSoapservic.getRecordResponse_element searchResponse = new soapSforceComSchemasClassSoapservic.getRecordResponse_element();
            searchResponse.result = new soapSforceComSchemasClassSoapservic.messageWrapper();
            list<soapSforceComSchemasClassSoapservic.DoctorDTO> newDoctorResponseList = new list<soapSforceComSchemasClassSoapservic.DoctorDTO>();
            soapSforceComSchemasClassSoapservic.DoctorDTO newDoctorResponse = new soapSforceComSchemasClassSoapservic.DoctorDTO();
            newDoctorResponse.lastName = 'test';
            newDoctorResponseList.add(newDoctorResponse);
            searchResponse.result.doctorList = newDoctorResponseList;
            response.put('response_x', searchResponse);
        } else if (mode == DEL_DOC) {
            soapSforceComSchemasClassSoapservic.deleteExistDoctorResponse_element deleteResponse = new soapSforceComSchemasClassSoapservic.deleteExistDoctorResponse_element();
            deleteResponse.result = new soapSforceComSchemasClassSoapservic.messageWrapper();
            deleteResponse.result.message = 'You delete doctor';
            response.put('response_x', deleteResponse);
        } else if (mode == UPD_DOC) {
            soapSforceComSchemasClassSoapservic.editExistDoctorResponse_element updateResponse = new soapSforceComSchemasClassSoapservic.editExistDoctorResponse_element();
            updateResponse.result = new soapSforceComSchemasClassSoapservic.messageWrapper();
            soapSforceComSchemasClassSoapservic.DoctorDTO newDoctorResponse = new soapSforceComSchemasClassSoapservic.DoctorDTO();
            newDoctorResponse.lastName = 'test123';
            updateResponse.result.newAddingDoctor = newDoctorResponse;
            response.put('response_x', updateResponse);
        }
    }

}
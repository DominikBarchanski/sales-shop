/**
 * Created by dominikbarchanski on 18/05/2022.
 */

@IsTest
public class CallautSoapService {
    @IsTest
    public static void addDoctorCallout() {
        test.setMock(WebServiceMock.class, new SoapApiMock(SoapApiMock.ADD_DOC));
        soapSforceComSchemasClassSoapservic.SOAPService soapResposne = new soapSforceComSchemasClassSoapservic.SOAPService();
        soapSforceComSchemasClassSoapservic.messageWrapper result = soapResposne.saveNewDoctor('test',null,null,null,null,null,null,null,null);
        soapSforceComSchemasClassSoapservic.DoctorDTO newDoc = new soapSforceComSchemasClassSoapservic.DoctorDTO();
        newDoc.lastName ='test';
        soapSforceComSchemasClassSoapservic.messageWrapper expected = new soapSforceComSchemasClassSoapservic.messageWrapper();
        expected.newAddingDoctor = newDoc;

        System.assertEquals('test',result.newAddingDoctor.lastName);
    }
    @IsTest
    public static void searchDoctorCallout() {
        test.setMock(WebServiceMock.class, new SoapApiMock(SoapApiMock.SER_DOC));
        soapSforceComSchemasClassSoapservic.SOAPService soapResposne = new soapSforceComSchemasClassSoapservic.SOAPService();
        soapSforceComSchemasClassSoapservic.messageWrapper result = soapResposne.getRecord('test',null,null);
        soapSforceComSchemasClassSoapservic.DoctorDTO newDoc = new soapSforceComSchemasClassSoapservic.DoctorDTO();
        newDoc.lastName ='test';
        soapSforceComSchemasClassSoapservic.messageWrapper expected = new soapSforceComSchemasClassSoapservic.messageWrapper();
        expected.newAddingDoctor = newDoc;

        System.assertEquals(expected.newAddingDoctor.lastName,result.doctorList[0].lastName);
    }
    @IsTest
    public static void editDoctorCallout() {
        test.setMock(WebServiceMock.class, new SoapApiMock(SoapApiMock.UPD_DOC));
        soapSforceComSchemasClassSoapservic.SOAPService soapResposne = new soapSforceComSchemasClassSoapservic.SOAPService();
        soapSforceComSchemasClassSoapservic.messageWrapper result = soapResposne.editExistDoctor(null,'test123',null,null,null,null,null,null,null,null);
        soapSforceComSchemasClassSoapservic.DoctorDTO newDoc = new soapSforceComSchemasClassSoapservic.DoctorDTO();
        newDoc.lastName ='test123';
        soapSforceComSchemasClassSoapservic.messageWrapper expected = new soapSforceComSchemasClassSoapservic.messageWrapper();
        expected.newAddingDoctor = newDoc;
        System.assertEquals(expected.newAddingDoctor.lastName,result.newAddingDoctor.lastName);
    }
    @IsTest
    public static void deleteDoctorCallout() {
        test.setMock(WebServiceMock.class, new SoapApiMock(SoapApiMock.DEL_DOC));
        soapSforceComSchemasClassSoapservic.SOAPService soapResposne = new soapSforceComSchemasClassSoapservic.SOAPService();
        soapSforceComSchemasClassSoapservic.messageWrapper result = soapResposne.deleteExistDoctor(null);

        System.assertEquals('You delete doctor',result.message);
    }
}
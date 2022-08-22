/**
 * Created by dominikbarchanski on 04/05/2022.
 */

public with sharing class ImportDoctorsController {
    public Blob inputUserFile { get; set; }
    public String csvAsString { get; set; }
    public String[] csvFileLines { get; set; }
    public List<DoctorWrapper> docListToLoad { get; set; }
    public List<Doctor__c> doctorToPush { get; set; }
    public Boolean displayTable { get; set; }
    public Boolean checkBoxValue { get; set; }
    public Boolean infoVisibility { get; set; }


    public ImportDoctorsController() {
        csvFileLines = new String[]{
        };
        docListToLoad = new List<DoctorWrapper>();
        doctorToPush = new List<Doctor__c>();
        displayTable = false ;
        checkBoxValue = false;
        infoVisibility = false;

    }
    public void processCsv() {

        try {
            csvAsString = blobToString(inputUserFile, 'UTF-8');
            csvFileLines = csvAsString.split('\n');
            docListToLoad = new List<DoctorWrapper>();
            for (Integer i = 1; i < csvFileLines.size(); i++) {
                String[] inputValue = new String[]{
                };
                inputValue = csvFileLines[i].split('","');
                Doctor__c innerDoctor = new Doctor__c();
                DoctorWrapper doc = new DoctorWrapper(innerDoctor);
                doc.innerDoctor.First_Name__c = inputValue[0].mid(1, inputValue[0].length()) == '"' ? null : inputValue[0].mid(1, inputValue[0].length());
                doc.innerDoctor.Name = inputValue[1] == '' ? null : inputValue[1];
                doc.innerDoctor.Phone__c = inputValue[2] == '' ? null : inputValue[2];
                doc.innerDoctor.Email__c = inputValue[3] == '' ? null : inputValue[3];
                doc.innerDoctor.Specialization__c = inputValue[4] == '' ? null : inputValue[4];
                doc.innerDoctor.Date_of_birth__c = inputValue[5] == '' ? null : Date.parse(inputValue[5]);
                doc.innerDoctor.City__c = inputValue[6] == '' ? null : inputValue[6];
                doc.innerDoctor.Street__c = inputValue[7] == '' ? null : inputValue[7];
                doc.innerDoctor.Country__c = inputValue[8].mid(0, inputValue[8].length() - 1) == '"' ? null : inputValue[8].mid(0, inputValue[8].length() - 1);
                doc.checkbox = false;

                docListToLoad.add(doc);
            }
            displayTable = true;
            System.debug(csvAsString);
        } catch (Exception e) {
            ApexPages.Message errorMessage = new ApexPages.Message(ApexPages.Severity.ERROR, 'An error has occurred reading the CSV file' + e.getMessage());
            ApexPages.addMessage(errorMessage);
        }

    }
    public void ImportDoctors() {
        List<Doctor__c> doc = new List<Doctor__c>();
        List<DoctorWrapper> docWrappers = new List<DoctorWrapper>();
        String getErrorMessage = '' ;
        try {
            for (DoctorWrapper addItemToList : docListToLoad) {
                if (addItemToList.checkbox == true) {
                    doc.add(addItemToList.innerDoctor);
                    docWrappers.add(addItemToList);
                } else {
                    addItemToList.importInfo = 'This row was\'t selected';
                    addItemToList.activeLink = true;
                }
            }

            Database.SaveResult[] item = Database.insert(doc, false);
            Integer i = 0;
            for (Database.SaveResult sr : item) {
                if (sr.isSuccess()) {
                    System.debug('message' + sr.getId());
                    docWrappers.get(i).insertedDoctorId = sr.getId();
                    docWrappers.get(i).importInfo = 'Success';
                    docWrappers.get(i).activeLink = false;
                    i++;
                } else {
                    for (Database.Error er : sr.getErrors()) {
                        getErrorMessage += er.getMessage() + ' ';
                        docWrappers.get(i).activeLink = true;
                    }
                    docWrappers.get(i).importInfo = getErrorMessage;
                    i++;
                }
            }

            infoVisibility = true;

        } catch (Exception e) {
            System.debug(e);
        }
    }
    public void AllCheckBoxTrue() {
        for (DoctorWrapper addItemToList : docListToLoad) {
            addItemToList.checkbox = true;
        }
    }
    public void AllCheckBoxFalse() {
        for (DoctorWrapper addItemToList : docListToLoad) {
            addItemToList.checkbox = false;
        }

    }
    public void AllCheckBoxReverse() {
        for (DoctorWrapper addItemToList : docListToLoad) {
            addItemToList.checkbox = !addItemToList.checkbox;
        }
    }
    public static String blobToString(Blob input, String inCharset) {
        String hex = EncodingUtil.convertToHex(input);
        System.assertEquals(0, hex.length() & 1);
        final Integer bytesCount = hex.length() >> 1;
        String[] bytes = new String[bytesCount];
        for (Integer i = 0; i < bytesCount; ++i) {
            bytes[i] = hex.mid(i << 1, 2);
        }
        return EncodingUtil.urlDecode('%' + String.join(bytes, '%'), inCharset);
    }
    public class DoctorWrapper {
        public Doctor__c innerDoctor { get; set; }
        public Boolean checkbox { get; set; }
        public String importInfo { get; set; }
        public String insertedDoctorId { get; set; }
        public Boolean activeLink { get; set; }
        DoctorWrapper(Doctor__c doctor) {
            this.innerDoctor = doctor;
            this.checkbox = false;
            this.importInfo = '';
            this.activeLink = false;
            this.insertedDoctorId = '';
        }
    }
}
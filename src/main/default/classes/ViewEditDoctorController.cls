/**
 * Created by dominik.barchanski on 27.04.2022.
 */

public with sharing class ViewEditDoctorController {
    public Doctor__c doc { get; set; }
    public String docId { get; set; }
    public String fullName { get; set; }
    public List<Contract__c> listOfContract { get; set; }
    public List<Hospital__c> hosp { get; set; }
    public Hospital__c singleHospital { get; set; }
    public Contract__c newContract { get; set; }
    public String hospitalName { get; set; }
    public String hospitalEmail { get; set; }
    public String hospitalPhone { get; set; }
    public Boolean sectionTwoVisibility { get; set; }
    public Boolean sectionThirdVisibility { get; set; }
    public Date startDate { get; set; }
    public Date endDate { get; set; }
    public Integer testVar { get; set; }
    public String errorMessage { get; set; }
    public String messageColor { get; set; }
    public Attachment newPhoto { get; set; }
    private Id parentId { get; set; }
    public Boolean contractWasInserted { get; set; }
    public Contract__c addedContract { get; set; }
    public Decimal loa { get; set; }
    public Decimal lati { get; set; }
    public Boolean displayMap {get;set;}
    public String infoCssClass{get;set;}


    public ViewEditDoctorController(ApexPages.StandardController controller) {
        infoCssClass='';
        contractWasInserted = false;
        sectionTwoVisibility = false;
        sectionThirdVisibility = false;
        newPhoto = new Attachment();
        parentId = controller.getId();
        singleHospital = new Hospital__c();
        newContract = new Contract__c();
        doc = new Doctor__c();
        System.debug(doc.Id);
        List<String> fields = new List<String>(Schema.getGlobalDescribe().get('Doctor__c').getDescribe().fields.getMap().keySet());
        List<String> fieldsContract = new List<String>(Schema.getGlobalDescribe().get('Contract__c').getDescribe().fields.getMap().keySet());
        docId = ApexPages.currentPage().getParameters().get('id');

        if (docId != null) {
            doc = Database.query('SELECT ' + String.join(fields, ',') + ' FROM Doctor__c WHERE Id =:docId LIMIT 1');
            listOfContract = Database.query('SELECT ' + String.join(fieldsContract, ',') + ' FROM Contract__c WHERE Doctors__c =:docId ');

        } else {
            doc = new Doctor__c();
            System.debug(doc.Id);
        }
        fullName = (doc.First_Name__c == null ? '' : doc.First_Name__c) + ' ' + doc.Name;

        mapData();


    }

    public void uploadPhoto() {
        try {

            newPhoto.ParentId = parentId;

            String fileExtension =(newPhoto.Name.substring(newPhoto.Name.indexOf('.')+1) );
            if(fileExtension == 'jpg' || fileExtension== 'jpeg' || fileExtension == 'png' || fileExtension == 'pjpeg' || fileExtension == 'gif' || fileExtension == 'bmp' ){
            newPhoto.Name = 'image';
            insert newPhoto;
            newPhoto = new Attachment();
            }else {
                ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.FATAL, 'Wrong file type');
               ApexPages.addMessage(myMsg);
            }
        } catch (Exception e) {
        }
    }
    public void deletePhoto(){

        newPhoto.ParentId = parentId;
        List<Attachment> img =[SELECT Id FROM Attachment WHERE Name = 'image' AND ParentId = :parentId ];
        delete img;
    }
    public Id getImageId() {
        try {
            Id result = null ;
            List<Attachment> img = [SELECT Id FROM Attachment WHERE Name = 'image' AND ParentId = :parentId ORDER BY CreatedDate DESC];
            if (img.size() > 0) {
                result = img[0].Id;
            } else {
                result = '00P7Q0000010GRcUAM';
            }
            return result;
        } catch (Exception e) {
        }
        return null;
    }
    public void clearLists() {
//        singleHospital.clear()
        if (singleHospital != null) {
            singleHospital.clear();
        }
        singleHospital = new Hospital__c();
        newContract.clear();
    }
    public void selectHospital() {
        errorMessage='';
        infoCssClass='';

    }
    public void hireDoctor() {

        newContract = new Contract__c();
        newContract.Doctors__c = doc.Id;
        newContract.Hospital_Names__c = singleHospital.Id;
        newContract.Start_Date__c = startDate;
        newContract.End_date__c = endDate;

        try {

            if (!contractWasInserted || !(addedContract == newContract)) {


                Database.SaveResult item = Database.insert(newContract);

                if (item.isSuccess()) {
                    System.debug('added');
                    messageColor = 'green';
                    errorMessage = 'You added contract successfully' ;
                    infoCssClass = 'success';
//            ApexPages.addMessage(ApexPages.Message );
                } else {
                    infoCssClass='';
                    System.debug('error');
                    item.getErrors();
                }
                contractWasInserted = true;
                addedContract = newContract.clone();
            } else {
                errorMessage = 'You try add same contract';
                messageColor = 'red';
            }
        } catch (Exception e) {
//            ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.Error, 'You Can Not Add This number'));
            errorMessage = e.getMessage();
            messageColor = 'red';
            System.debug(e);
        }


//        insert newContract;
        System.debug(startDate);
        System.debug(endDate);

    }

    public void findHospital() {
        singleHospital.Name.addError('test');
        errorMessage='';
        infoCssClass='';
        String soqlQuery = 'SELECT Id,Name,Email__c,Phone__c FROM Hospital__c WHERE Name like \'%' + hospitalName + '%\' ';
        if (hospitalEmail != '') {
            soqlQuery += 'AND Email__c like \'%' + hospitalEmail + '%\'';
        }
        if (hospitalPhone != '') {
            soqlQuery += 'AND Phone__c like \'%' + hospitalPhone + '%\'';
        }

        hosp = Database.query(soqlQuery) ;

        testVar = hosp.size();
        system.debug(testVar);
        sectionTwoVisibility = true;
    }
    public void DeleteDoctor() {
        Doctor__c removeDoctor = [SELECT Id FROM Doctor__c WHERE Id = :docId LIMIT 1];
        if (removeDoctor != null) {
            try {
                delete removeDoctor;
            } catch (DmlException e) {
                ApexPages.addMessages(e);
            }

        }


    }

    public PageReference save() {

        try {
            if(doc.Id !=null){
                System.debug(doc);
            update doc;
            PageReference pageRef = new PageReference('/apex/ViewDoctor?id='+ docId).setRedirect(true);
                return pageRef;
            }else {
                System.debug(doc);
                insert doc;
                PageReference pageRef = new PageReference('/apex/ViewDoctor?id='+ doc.Id).setRedirect(true);
                return pageRef;
            }
        } catch (DmlException e) {
            ApexPages.addMessages(e);
        }
       return null;
    }

    public PageReference saveAndNew() {
        save();
        return new PageReference('/apex/EditDoctor').setRedirect(true);

    }
    public String value { get; set; }

    public void anAction() {
        if (value != null && value.length() > 0) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Variable set to [' + value + ']'));
        } else {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Variable not set'));
        }
    }
    public void mapData(){
        if(doc.City__c != null && doc.Country__c != null && doc.Street__c != null) {
            HttpRequest req = new HttpRequest();
            String urlParameters = '';

            if (String.isNotBlank(doc.City__c)) {
                urlParameters += '&city=' + EncodingUtil.urlEncode(doc.City__c, 'UTF-8');
            }
            if (String.isNotBlank(doc.Country__c)) {
                urlParameters += '&country=' + EncodingUtil.urlEncode(doc.Country__c, 'UTF-8');
            }
            if (String.isNotBlank(doc.Street__c)) {
                String replace = doc.Street__c.replace(' ','+');

                urlParameters += '&street=' + replace ;// EncodingUtil.urlEncode(replace, 'UTF-8');
            }

            System.debug(urlParameters);
            String url = 'https://nominatim.openstreetmap.org/search.php?format=json' +
                    urlParameters;
            System.debug(url);
            req.setEndpoint(
                    url
            );
            req.setMethod('GET');
            Http http = new Http();
            HTTPResponse res = http.send(req);
            System.debug(res.getBody());

            List<GeoData> geoData;
            try {
                geoData = (List<GeoData>) JSON.deserialize(
                        res.getBody(),
                        List<GeoData>.class
                );
            } catch (Exception ex) {
                System.debug('Exception : ' + ex);
            }
            System.debug(geoData.size());

            if (geoData != null && geoData.size() > 0) {
                System.debug(geoData);
                lati = Decimal.valueOf(geoData[0].lat);
                loa = Decimal.valueOf(geoData[0].lon);
                displayMap=true;
            }else {
                lati=0;
                loa=0;
            }

        }else{
            displayMap = false;
        }
    }
    public class GeoData {
        public String lat { get; set; }
        public String lon { get; set; }
    }
}
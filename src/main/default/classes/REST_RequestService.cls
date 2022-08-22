/**
 * Created by dominikbarchanski on 21/05/2022.
 */

global with sharing class REST_RequestService {
    global Boolean checkboxState;
    global static REST_Request createRequest(String body) {
        REST_Request syncRequest = new REST_Request(null, null, null);
        try {
            if (body == null || body == '') {
                syncRequest.hospitalDTO = null;
                syncRequest.status = 'error';
                syncRequest.operationType = 'add';

                return syncRequest;
            }
            system.debug('post body:' + body);
            REST_HospitalDTO hospitalDTOS = (REST_HospitalDTO) JSON.deserialize(body, REST_HospitalDTO.class);
            Boolean checkBoxValue;
            JSONParser parser = JSON.createParser(body);

            while (parser.nextToken() != null) {
                if ((parser.getCurrentToken() == JSONToken.FIELD_NAME) && (parser.getText() == 'hospitalTrigger')) {
                    parser.nextToken();
                    checkBoxValue = parser.getText() == 'true' ? true : false;
                }
            }
            hospitalDTOS.hospitalCheckBox = checkBoxValue;

            system.debug('post wrapper dto:' + hospitalDTOS);

            Hospital__c hospitals = REST_MapObject.mapToHospitalFromDTO(hospitalDTOS) ;//mapToHospitalFromDTO(hospitalDTOS);
            System.debug('łape na tworzeniu' + hospitals);

            Database.SaveResult saveResults = Database.insert(hospitals);
            System.debug(saveResults);
            syncRequest.operationType = 'add';
            syncRequest.status = 'success';
            syncRequest.hospitalDTO = hospitalDTOS;
            syncRequest.hospitalDTO.hospitalId = saveResults.getId();


            return syncRequest;
        } catch (Exception e) {
            System.debug(e);
            syncRequest.operationType = 'add';
            syncRequest.status = 'error';
            syncRequest.hospitalDTO = null;
            return syncRequest;
        }
    }
    global static List<REST_HospitalDTO> findHospitalByParam(String hospitalName, String hospitalCountry) {
        List<REST_HospitalDTO> response = new List<REST_HospitalDTO>();
        String soql;
//        String toSoql ;
//        string.isNotBlank(hospitalCountry)? toSoql = 'AND Country__c LIKE :hospitalCountry':''; OR Country__c LIKE :hospitalCountry
        if (String.isNotBlank(hospitalName)) {
            soql = 'SELECT Name, Email__c, Phone__c, Country__c, City__c, Street__c, externalId__c, paramId__c, TriggerProcess__c FROM Hospital__c WHERE Name LIKE \'%' + hospitalName + '%\' ' ;
            if (String.isNotBlank(hospitalCountry) && hospitalCountry != 'null') {
                soql += ' AND Country__c Like  \'%' + hospitalCountry + '%\' ';
            }
            System.debug(hospitalCountry);
            system.debug(soql);
            List<Hospital__c> findedHospitals = Database.query(soql);
            for (Hospital__c item : findedHospitals) {
                response.add(new REST_HospitalDTO(item));
            }
        }
//        List<Hospital__c> findedHospitals = [SELECT Name, Email__c, Phone__c, Country__c, City__c, Street__c, externalId__c, paramId__c, TriggerProcess__c FROM Hospital__c ];

        return response;
    }
    global static REST_Request deleteHospital(String body) {
        REST_Request syncRequest = new REST_Request(null, null, null);
        REST_HospitalDTO hospitalDTOS = (REST_HospitalDTO) JSON.deserialize(body, REST_HospitalDTO.class);
        system.debug(hospitalDTOS);
//        hospitalDTOS.hospitalId = null;
        String tmpId = hospitalDTOS.hospitalId;
        hospitalDTOS.hospitalId =null;


        Hospital__c hospitals = REST_MapObject.mapToHospitalFromDTO(hospitalDTOS) ;
        Hospital__c hospitalToDelete ;

        System.debug(hospitals);
        try{
            hospitals.Id=tmpId;
            delete hospitals;
            syncRequest.hospitalDTO = null;
            syncRequest.status = 'OK';
            syncRequest.operationType = 'Delete';
            return syncRequest;
        }catch(Exception e){
            system.debug('change object');
        }
        if (String.isNotBlank(hospitals.externalId__c)) {
            hospitalToDelete = [SELECT Id FROM Hospital__c WHERE Id = :hospitals.externalId__c LIMIT 1];

        } else {
            hospitalToDelete = [SELECT Id FROM Hospital__c WHERE externalId__c = :tmpId LIMIT 1];

        }


        try {
//                Hospital__c finedHospitals = [SELECT Name, Id FROM Hospital__c WHERE Id = :hospitals.Id LIMIT 1];
            delete hospitalToDelete;
            syncRequest.hospitalDTO = null;
            syncRequest.status = 'OK';
            syncRequest.operationType = 'Delete';
        } catch (Exception e) {
            syncRequest.hospitalDTO = null;
            syncRequest.status = 'ERROR';
            syncRequest.operationType = 'Delete';
        }

        return syncRequest;
    }
    global static REST_Request editHospital(String body) {
        REST_Request syncRequest = new REST_Request(null, null, null);
        System.debug('body edita ' + body);
        REST_HospitalDTO hospitalDTOS = (REST_HospitalDTO) JSON.deserialize(body, REST_HospitalDTO.class);
        Boolean checkBoxValue;
        JSONParser parser = JSON.createParser(body);
        while (parser.nextToken() != null) {
            if ((parser.getCurrentToken() == JSONToken.FIELD_NAME) && (parser.getText() == 'hospitalTrigger')) {
                parser.nextToken();
                checkBoxValue = parser.getText() == 'true' ? true : false;
            }
        }
        hospitalDTOS.hospitalCheckBox = checkBoxValue;
        Hospital__c iditem;
        System.debug('body po deserializacji  ' + hospitalDTOS);
        System.debug(hospitalDTOS.hospitalExternalId);
        System.debug('łape na edyczie' + hospitalDTOS);
        if (hospitalDTOS.hospitalExternalId != null) {

            iditem = [SELECT Id, City__c, Street__c, Name, Country__c, Phone__c, Email__c, externalId__c, paramId__c, TriggerProcess__c FROM Hospital__c WHERE externalId__c = :hospitalDTOS.hospitalExternalId LIMIT 1];
            System.debug(iditem);
            hospitalDTOS.hospitalId = iditem.Id;
            hospitalDTOS.hospitalExternalId = hospitalDTOS.hospitalExternalId;
        } else {
            hospitalDTOS.hospitalExternalId = null;
            iditem = [SELECT Id, City__c, Street__c, Name, Country__c, Phone__c, Email__c, externalId__c, paramId__c, TriggerProcess__c FROM Hospital__c WHERE externalId__c = :hospitalDTOS.hospitalExternalId LIMIT 1];

        }

        Hospital__c hospitals = REST_MapObject.mapToHospitalFromDTO(hospitalDTOS);

        system.debug(hospitals);
        try {

            hospitals.TriggerProcess__c = hospitalDTOS.hospitalCheckBox;
            hospitals.Schedule_Counter__c = 0 ;
            System.debug('satate trigger status : ' + hospitalDTOS.hospitalCheckBox);
            update hospitals;
            // ustalamy na false
            syncRequest.hospitalDTO = hospitalDTOS;
            syncRequest.status = 'OK';
            syncRequest.operationType = 'UPDATE';
        } catch (Exception e) {
            //ustalamy na true
            syncRequest.hospitalDTO = null;
            syncRequest.status = 'Error';
            syncRequest.operationType = 'UPDATE';

        }
        return syncRequest;
    }
}
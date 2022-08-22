/**
 * Created by dominikbarchanski on 24/05/2022.
 */

public with sharing class syncOrgTriggerHelper implements Queueable, Database.AllowsCallouts {
    private String hospID;
    private String mode;
    private Hospital__c wholeObject ;
    public static String ADD_HOP = 'ADD_DOC';
    public static String EDI_HOP = 'EDI_HOP';
    public static String DEL_HOP = 'DEL_DOC';

    public syncOrgTriggerHelper(string hospidtrigger, String modeOpertion) {
        this.hospID = hospidtrigger ;
        this.mode = modeOpertion;
    }
    public syncOrgTriggerHelper(Hospital__c hospitalObject, String modeOpertion) {
        this.wholeObject = hospitalObject ;
        this.mode = modeOpertion;
    }
    public void execute(QueueableContext param1) {
        if (mode == ADD_HOP) {
            Hospital__c newHospital = [SELECT Id, City__c, Street__c, Name, Country__c, Phone__c, Email__c, externalId__c, paramId__c, TriggerProcess__c,Schedule_Counter__c FROM Hospital__c WHERE Id = :hospID LIMIT 1];
            REST_HospitalDTO hospitalDtoToSend = new REST_HospitalDTO(newHospital);
            hospitalDtoToSend.hospitalId = null;
            hospitalDtoToSend.hospitalExternalId = newHospital.Id;
            hospitalDtoToSend.hospitalCheckBox = true;
            HttpRequest postHospital = REST_Callout.createPostHospitalRequest(hospitalDtoToSend);

            Http http = new Http();

            HttpResponse response = http.send(postHospital);
            LogBuilder.createLog(newHospital.Id ,postHospital, response);
            if (response.getStatusCode() != 200){
                newHospital.Schedule_Counter__c = 1;
                update newHospital;
            }
        } else if (mode == EDI_HOP) {

            Hospital__c newHospital = [SELECT Id, City__c, Street__c, Name, Country__c, Phone__c, Email__c, externalId__c, paramId__c, TriggerProcess__c,Schedule_Counter__c FROM Hospital__c WHERE Id = :hospID LIMIT 1];
            newHospital.TriggerProcess__c = true;
            REST_HospitalDTO hospitalDtoToSend = new REST_HospitalDTO(newHospital);
            hospitalDtoToSend.hospitalCheckBox = true;
            if (String.isNotBlank(hospitalDtoToSend.hospitalExternalId)) {
                hospitalDtoToSend.hospitalId = hospitalDtoToSend.hospitalExternalId;
                hospitalDtoToSend.hospitalExternalId = null;
                hospitalDtoToSend.paramId = null;
            } else {
                hospitalDtoToSend.hospitalExternalId = hospitalDtoToSend.hospitalId;
                hospitalDtoToSend.hospitalId = null;
                hospitalDtoToSend.paramId = null;

            }

            HttpRequest req = REST_Callout.createPatchHospitalRequest(hospitalDtoToSend);

            Http http = new Http();
            HttpResponse resp = http.send(req);
            if (resp.getStatusCode() != 200){
                newHospital.Schedule_Counter__c = 1;
                update newHospital;
            }
            LogBuilder.createLog(newHospital.Id,req, resp);
        } else if (mode == DEL_HOP) {

            REST_HospitalDTO hospitalDtoToSend = new REST_HospitalDTO(wholeObject);
            System.debug(hospitalDtoToSend);

            HttpRequest request = REST_Callout.createDeleteHospitalRequest(hospitalDtoToSend);
            Http http = new Http();
            HttpResponse response = http.send(request);
            LogBuilder.createLog(wholeObject.Id,request, response);
            System.debug(response.getBody());
//            if (response.getStatusCode() != 200){
//                wholeObject.Schedule_Counter__c = 1;
//                update newHospital;
//            }

        }
    }


}
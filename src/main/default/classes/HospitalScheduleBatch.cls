/**
 * Created by dominikbarchanski on 28/05/2022.
 */

public with sharing class HospitalScheduleBatch implements Database.Batchable<objectWrapper>, Database.AllowsCallouts {
    public List<Hospital__c> listOfObjectsInHospital { get; set; }
    public Map<String, List<API_Log__c>> mapOfObjectsInLog { get; set; }
    public List<Hospital__c> toUpdateDML { get; set; }
    public List<objectWrapper> wrappedList { get; set; }
    class objectWrapper {
        public Hospital__c hospitalItem;
        public String reqBody;
        public String apiMethod;
        public String endpoint;
        public objectWrapper(Hospital__c hospital) {
            this.hospitalItem = hospital;
        }

    }
    public List<objectWrapper> start(Database.BatchableContext param1) {
        listOfObjectsInHospital = [
                SELECT
                        Id, Schedule_Counter__c, TriggerProcess__c
                FROM Hospital__c
                WHERE ((Schedule_Counter__c != NULL OR Schedule_Counter__c != 0) AND Schedule_Counter__c < 4)
        ];

        mapOfObjectsInLog = new Map<String, List<API_Log__c>>();

//        for (Hospital__c item : [SELECT Id, Schedule_Counter__c, TriggerProcess__c FROM Hospital__c WHERE ((Schedule_Counter__c != NULL OR Schedule_Counter__c != 0) AND Schedule_Counter__c < 4)]) {
//            objectWrapper itemToAdd = new objectWrapper(item);
//            wrappedList.add(itemToAdd);
//        }
//        system.debug(wrappedList);
//        list
//

        for (API_Log__c item : [SELECT Object_Id__c, Request_Body__c, Api_Method__c, Endpiont__c, Create_Date__c FROM API_Log__c WHERE Status_Code__c != 200]) {
            if (String.isNotBlank(item.Object_Id__c) && item.Object_Id__c != '' && item.Object_Id__c != null) {
                try {
                    if (mapOfObjectsInLog.containsKey(item.Object_Id__c)) {
                        mapOfObjectsInLog.get(item.Object_Id__c).add(item);
                    } else {
                        mapOfObjectsInLog.put(item.Object_Id__c, new List<API_Log__c>{
                                item
                        });
                    }
                } catch (Exception e) {

                }
            }
        }
        wrappedList = new List<objectWrapper>();
        system.debug(listOfObjectsInHospital);
        system.debug(mapOfObjectsInLog);
        for (Hospital__c item : listOfObjectsInHospital) {
            if (mapOfObjectsInLog.containsKey(item.Id)) {
                Date createDate = null;
                for (API_Log__c log : mapOfObjectsInLog.get(item.Id)) {

                    if (createDate < log.Create_Date__c || createDate == null) {
                        createDate = log.Create_Date__c;
                        objectWrapper itemToAdd = new objectWrapper(item);
                        itemToAdd.apiMethod = log.Api_Method__c;
                        itemToAdd.reqBody = log.Request_Body__c;
                        itemToAdd.endpoint = log.Endpiont__c;
                        system.debug(itemToAdd);
                        wrappedList.add(itemToAdd);
                    }
                }
                createDate = null;
            }
        }

        return wrappedList;
    }
    public void execute(Database.BatchableContext param1, List<objectWrapper> param2) {
        System.debug(param2);
        toUpdateDML = new List<Hospital__c>();
        for (objectWrapper hosp : param2) {
            system.debug(hosp);
            HttpRequest req = new HttpRequest();
            req.setHeader('Content-Type', 'application/x-www-form-urlencoded');
            req.setHeader('Content-Type', 'application/json');
            req.setHeader('accept', 'application/json');
            req.setHeader('Authorization', 'Bearer ' + Userinfo.getSessionId());
            req.setEndpoint(hosp.endpoint);
            req.setBody(hosp.reqBody);
            req.setMethod(hosp.apiMethod);
            Http http = new Http();
            system.debug(req.getBody());
            HttpResponse res = http.send(req);
            System.debug(res.getBody());
            if (res.getStatusCode() != 200) {
                hosp.hospitalItem.Schedule_Counter__c += 1;
                hosp.hospitalItem.TriggerProcess__c = true;

                toUpdateDML.add(hosp.hospitalItem);
            } else {
                hosp.hospitalItem.Schedule_Counter__c = 0;
                hosp.hospitalItem.TriggerProcess__c = true;
                toUpdateDML.add(hosp.hospitalItem);
            }
        }
        update toUpdateDML;
    }

    public void finish(Database.BatchableContext param1) {

    }


}
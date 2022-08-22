/**
 * Created by dominikbarchanski on 23/05/2022.
 */

public with sharing class REST_calloutTest {
    public static HttpResponse postTest (){
        Http http = new Http();
        HttpRequest postreq = REST_Callout.createPostHospitalRequest(new REST_HospitalDTO(new Hospital__c()));
        HttpResponse response = http.send(postreq);
        return response;
    }
    public static HttpResponse getTest (){
        Http http = new Http();
        HttpRequest request =  new HttpRequest();
        request.setEndpoint('callout:RestHospital/services/apexrest/HospitalRafal/' + '?Name=test');
        request.setHeader('Content-Type', 'application/x-www-form-urlencoded');
        request.setHeader('Content-Type', 'application/json');
        request.setHeader('accept', 'application/json');
        request.setHeader('Authorization','Bearer '+Userinfo.getSessionId());
        request.setMethod('GET');
        HttpResponse response = http.send(request);
        return response;
    }
    public static HttpResponse patchTest (){
        Http http = new Http();
        HttpRequest postreq = REST_Callout.createPatchHospitalRequest(new REST_HospitalDTO(new Hospital__c()));
        HttpResponse response = http.send(postreq);
        return response;
    }
    public static HttpResponse putTest (){
        Http http = new Http();
        HttpRequest postreq = REST_Callout.createPutHospitalRequest();
        HttpResponse response = http.send(postreq);
        return response;
    }
    public static HttpResponse deleteTest (){
        Http http = new Http();
        HttpRequest postreq = REST_Callout.createDeleteHospitalRequest(new REST_HospitalDTO(new Hospital__c()));
        HttpResponse response = http.send(postreq);
        return response;
    }
}
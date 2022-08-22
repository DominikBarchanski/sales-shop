/**
 * Created by dominikbarchanski on 23/05/2022.
 */

global with sharing class REST_Callout {
    private static final String endpoint = 'callout:RestHospital/services/apexrest/HospitalRafal/';
    global static HttpRequest createPostHospitalRequest (REST_HospitalDTO hospitalDTOS){
        HttpRequest request = new HttpRequest();
        request.setEndpoint(endpoint);
        request.setHeader('Content-Type', 'application/x-www-form-urlencoded');
        request.setHeader('Content-Type', 'application/json');
        request.setHeader('accept', 'application/json');
        request.setHeader('Authorization','Bearer '+Userinfo.getSessionId());
        request.setMethod('POST');
        request.setBody(JSON.serialize(hospitalDTOS));
        return request;
    }
    global static HttpRequest createPatchHospitalRequest (REST_HospitalDTO hospitalDTOS){
        HttpRequest request = new HttpRequest();
        request.setEndpoint(endpoint);
        request.setHeader('Content-Type', 'application/x-www-form-urlencoded');
        request.setHeader('Content-Type', 'application/json');
        request.setHeader('accept', 'application/json');
        request.setHeader('Authorization','Bearer '+Userinfo.getSessionId());
        request.setMethod('PATCH');
        request.setBody(JSON.serialize(hospitalDTOS));
        return request;
    }
    global static HttpRequest createDeleteHospitalRequest (REST_HospitalDTO hospitalDTOS){
        HttpRequest request = new HttpRequest();
        request.setEndpoint(endpoint);
        request.setHeader('Content-Type', 'application/x-www-form-urlencoded');
        request.setHeader('Content-Type', 'application/json');
        request.setHeader('accept', 'application/json');
        request.setHeader('Authorization','Bearer '+Userinfo.getSessionId());
        request.setBody(JSON.serialize(hospitalDTOS));
        request.setMethod('DELETE');
//        request.setBody(JSON.serialize(hospitalDTOS));
        return request;
    }
    global static HttpRequest createPutHospitalRequest (){
        HttpRequest request = new HttpRequest();
        request.setEndpoint(endpoint);
        request.setHeader('Content-Type', 'application/x-www-form-urlencoded');
        request.setHeader('Content-Type', 'application/json');
        request.setHeader('accept', 'application/json');
        request.setHeader('Authorization','Bearer '+Userinfo.getSessionId());
        request.setMethod('PUT');
        return request;
    }
}
/**
 * Created by dominikbarchanski on 19/05/2022.
 */
@RestResource(UrlMapping='/searchHospital/*')
global with sharing class REST_RequestController {


    @HttpGet
    global static List<REST_HospitalDTO> getHospitals(){

        RestRequest req = RestContext.request;
        Map<String,String> hospitalReqParam = req.params;
        String hospitalName = hospitalReqParam.get('Name');
        String hospitalCountry = hospitalReqParam.get('Country');
        return REST_RequestService.findHospitalByParam(hospitalName,hospitalCountry);
    }

    @HttpPost
    global static REST_Request addHospital(){
        String body = RestContext.request.requestBody.toString();
        return REST_RequestService.createRequest(body);

    }
    @HttpDelete
    global static REST_Request  deleteHospital (){
        String body = RestContext.request.requestBody.toString();
        return REST_RequestService.deleteHospital(body);
    }

    @HttpPatch
    global static REST_Request updateHospital (){
        // pole dla triger na flase
        String body = RestContext.request.requestBody.toString();
        return REST_RequestService.editHospital(body);
    }
    @HttpPut
    global static List<string> picklistAll (){
        List<string> fulllist = new List<string>();
        for(PicklistEntry picklistEntry : Hospital__c.Country__c.getDescribe().getPicklistValues()) {
            fulllist.add(picklistEntry.getValue());
    }
        return  fulllist;
    }

}
/**
 * Created by dominikbarchanski on 27/05/2022.
 */

public with sharing class LogBuilder {
    public static API_Log__c record ;
    public static void createLog(String objectId, HttpRequest request, HttpResponse response) {
        record= LogBuilder.getBuilder()
                .setEndpoint(request.getEndpoint())
                .setStatusCode(response.getStatusCode())
                .setRequestBody(request.getBody())
                .setResponseBody(response.getBody())
                .setRequest(request.toString())
                .setCreateDate()
                .setApiMethod((request.getMethod()))
                .setObjectId(objectId)
                .save()
                .getRecord();

    }
    public static Builder getBuilder() {
        return new Builder();
    }

    public class Builder {
        public API_Log__c record;

        public Builder() {
            record = new API_Log__c();
        }

        public Builder setEndpoint(String endpoint) {
            record.Endpiont__c = endpoint;
            return this;
        }
        public Builder setRequest(String request) {
            record.Request__c = request;
            return this;
        }
        public Builder setApiMethod(String method){
            record.Api_Method__c = method;
            return this;
        }
        public Builder setObjectId(String Id){
            record.Object_Id__c = Id;
            return this;
        }
        public Builder setStatusCode(Decimal statusCode) {
            record.Status_Code__c = statusCode;
            return this;
        }
        public Builder setCreateDate(){
            record.Create_Date__c = Date.today();
            return this;
        }

        public Builder setRequestBody(String requestBody) {
            record.Request_Body__c = requestBody;
            return this;
        }

        public Builder setResponseBody(String responseBody) {
            record.Response_Body__c = responseBody;
            return  this;
        }

        public Builder save() {
            insert record;
            return  this;
        }

        public API_Log__c getRecord() {
            return record;
        }
    }
}
/**
 * Created by dominikbarchanski on 31/05/2022.
 */

public with sharing class ApiCallController {
    @AuraEnabled
    public static String getRecords(String movieName) {
        String endpoint = 'https://api.themoviedb.org/3/search/movie?api_key=bd9d5c792ac679402f3a4a528a1a46a8&language=en-US&query='+movieName.replace(' ','+')+'&page=1&include_adult=false';
        HttpRequest request = new HttpRequest();
        request.setEndpoint(endpoint);
        request.setHeader('Content-Type', 'application/json');
        request.setHeader('accept', 'application/json');
        request.setMethod('GET');
        Http http = new Http();
        HttpResponse res = http.send(request);
        return res.getBody();
    }
}
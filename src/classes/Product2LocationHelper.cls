/**
 * Created by dominikbarchanski on 04/08/2022.
 */

public with sharing class Product2LocationHelper {
//    @Future(Callout=true)
//    public static void insertProductLocation(List<Product2> listOfContentVersion) {
//        List<Product2> content = new List<Product2>();
//        for (Product2 item : listOfContentVersion) {
//            Http http = new Http();
//            HttpRequest request = new HttpRequest();
//            String apiAddress = item.Country__c + '+' + item.City__c + '+' + item.Street__c;
//            apiAddress = apiAddress.replace(' ', '+');
//            request.setEndpoint('https://maps.googleapis.com/maps/api/geocode/json?address=' + apiAddress + '&key=AIzaSyC6TeiRM56HgxvqR7ncLeZST7Sid6Pky2s');
//            request.setMethod('GET');
//            System.debug(request);
//            HttpResponse response = http.send(request);
//            if (response.getStatusCode() == 200) {
//                googleJSON2Apex items = googleJSON2Apex.parse(response.getBody());
//                String lat = String.valueOf(items.results[0].geometry.location.lat);
//                String lng = String.valueOf(items.results[0].geometry.location.lng);
//                item.Latitude__c = lat;
//                item.Longitude__c = lng;
//                content.add(item);
//            }
//
//        }
//        update content;
//    }
}
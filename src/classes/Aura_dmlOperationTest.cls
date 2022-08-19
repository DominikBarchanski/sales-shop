/**
 * Created by dominikbarchanski on 18/08/2022.
 */

@IsTest
private class Aura_dmlOperationTest implements HttpCalloutMock{
//    @TestSetup
//    private static void setupTestData() {

//        Pricebook2 pricebookins = new Pricebook2(
//                Name='a',
//                IsActive=true,
//                End_date__c=Date.today(),
//                Start_Date__c=Date.today()
//        );
//        insert pricebookins;
//        Product2 prod1 = new Product2(Name='a');
//        insert prod1;
//        PricebookEntry entry = new PricebookEntry(
//                UnitPrice=500,
//                Product2Id=prod1.Id,
//                Pricebook2Id=standartPricebook.Id,
//                IsActive=true
//        );
//        insert entry;
//    }
    @IsTest
    static void testBehavior_Delete() {
        Aura_dmlOperations.deleteAfterCancel(new List<String>{'a'});
    }
    @IsTest
    static void testBehavior_Deletedoc() {
        Aura_dmlOperations.deleteDocuments('a');
        Aura_dmlOperations.deleteDocuments('a 22t 2 t234 ');
    }
    @IsTest
    static void testInsertProduct() {


        Map<String,Object> mapjs = new Map<String, Object>();
        mapjs.put('name','name');
        mapjs.put('mainPhoto','name');
        mapjs.put('description','name');
        mapjs.put('price','1234');
        mapjs.put('type','name');
        mapjs.put('hp','123');
        mapjs.put('brand','name');
        mapjs.put('prodCountry','1');
        mapjs.put('prodCity','1');
        mapjs.put('prodStreet','1');
        mapjs.put('prodCityConsum','1');
        mapjs.put('prodAvgConsum','1');
        mapjs.put('prodDoors','1');
        mapjs.put('prodCapacity','1');
        mapjs.put('prodPlaces','1');
        mapjs.put('prodSpeed','1');
        mapjs.put('prodYear','2020-10-10');
        Object a='a';
        List<Object> obj = new List<Object>{a};
        mapjs.put('photoList',obj);

        Test.setMock(HttpCalloutMock.class, new Aura_dmlOperationTest());

        Aura_dmlOperations.insertProduct(mapjs);
        Aura_dmlOperations.insertProduct(null);
    }
    @IsTest
    static void testInsertProductbrand() {
        Aura_dmlOperations.getBrands();
    }
    public HttpResponse respond(HttpRequest param1) {
        HttpResponse response = new HttpResponse();
        response.setHeader('Content-Type', 'application/json');
        response.setBody('{"results":[{"address_components":[{"long_name":"Katowice","short_name":"Katowice","types":["locality","political"]},{"long_name":"Katowice","short_name":"Katowice","types":["administrative_area_level_2","political"]},{"long_name":"Śląskie","short_name":"Śląskie","types":["administrative_area_level_1","political"]},{"long_name":"Polska","short_name":"PL","types":["country","political"]},{"long_name":"40","short_name":"40","types":["postal_code","postal_code_prefix"]}],"formatted_address":"Katowice, Polska","geometry":{"bounds":{"northeast":{"lat":50.2973176,"lng":19.122919},"southwest":{"lat":50.1300272,"lng":18.8914664}},"location":{"lat":50.26489189999999,"lng":19.0237815},"location_type":"APPROXIMATE","viewport":{"northeast":{"lat":50.2973176,"lng":19.122919},"southwest":{"lat":50.1300272,"lng":18.8914664}}},"place_id":"ChIJ0cyhNiPOFkcRu_pZBTUqr7k","types":["locality","political"]}],"status":"OK"}');
        response.setStatusCode(200);
        return response;
    }

}
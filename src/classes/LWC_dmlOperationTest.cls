/**
 * Created by dominikbarchanski on 19/08/2022.
 */

@IsTest
private class LWC_dmlOperationTest implements HttpCalloutMock {
    @TestSetup
    private static void setupTestData() {
        Pricebook2 standartPricebook = new Pricebook2(
                Id = Test.getStandardPricebookId(),
                IsActive = true);
        update standartPricebook;
        Pricebook2 pricebookins = new Pricebook2(
                Name = 'a',
                IsActive = true,
                End_date__c = Date.today(),
                Start_Date__c = Date.today()
        );
        insert pricebookins;
        Product2 prod1 = new Product2(Name = 'a',Fuel_Consumption_In_The_City__c=1,
                Average_Fuel_Consumption__c=1,
                Number_of_Doors__c=1,
                Cylinder_Capacity__c=1,
                Number_of_Places__c=1,
                Top_Speed__c=1
                );
        Product2 prod2 = new Product2(Name = 'a',Fuel_Consumption_In_The_City__c=1,
                Average_Fuel_Consumption__c=1,
                Number_of_Doors__c=1,
                Cylinder_Capacity__c=1,
                Number_of_Places__c=1,
                Top_Speed__c=1);
        insert prod1;
        insert prod2;
        Shopping_Cart__c itemcCart1 = new Shopping_Cart__c(
                Product_Id__c = prod1.Id,
                User_Id__c = 'a');
        insert itemcCart1;
        PricebookEntry entry = new PricebookEntry(
                UnitPrice = 500,
                Product2Id = prod1.Id,
                Pricebook2Id = standartPricebook.Id,
                IsActive = true
        );
        insert entry;
        Strategy__c start = new Strategy__c(
                Standard_Price__c = 100,
                Product2id__c = prod1.Id
        );
        Strategy__c start2 = new Strategy__c(
                Standard_Price__c = 100,
                Product2id__c = prod2.Id
        );
        Shopping_Cart__c itemcCart = new Shopping_Cart__c(Product_Id__c = 'a', User_Id__c = 'a');
        insert itemcCart;
        insert start;
        insert start2;
        ContentVersion content = new ContentVersion();
        ContentVersion content1 = new ContentVersion();
        content.Title = 'Title_Picture';
        content.FirstPublishLocationId = prod1.Id;
        content.PathOnClient = '/' + content.Title + '.jpg';
        Blob bodyBlob = Blob.valueOf('Test ContentVersion Body');
        content.VersionData = bodyBlob;
        insert content;
        content1.Title = 'Title_Picture';
        content1.FirstPublishLocationId = prod1.Id;
        content1.PathOnClient = '/' + content.Title + '.jpg';
        content1.VersionData = bodyBlob;
        insert content1;
        ContentDistribution itemCD = new ContentDistribution(
                ContentVersionId = content.Id,
                Name = content.Id
        );
        ContentDistribution itemCD1 = new ContentDistribution(
                ContentVersionId = content1.Id,
                Name = content1.Id
        );
        insert itemCD1;
        insert itemCD;
    }
    @IsTest
    static void allPricebookTest() {
        Test.startTest();
        LWC_dmlOperation.getAllPricebookItems();
        Test.stopTest();
    }
    @IsTest
    static void getCVTest() {
        Test.startTest();
        LWC_dmlOperation.getAllContentVersion();
        Test.stopTest();
    }
    @IsTest
    static void getCDTest() {
        Test.startTest();
        LWC_dmlOperation.getAllContentDistribution();
        Test.stopTest();
    }
    @IsTest
    static void getAllProdTest() {
        Test.startTest();
        LWC_dmlOperation.getAllProducts('a');
        Test.stopTest();
    }
    @IsTest
    static void searchProdProdTest() {
        Test.startTest();
        LWC_dmlOperation.searchProduct('a');
        Test.stopTest();
    }
    @IsTest
    static void getSingleProdTest() {
        LWC_dmlOperation.getSingleProduct([SELECT Id FROM Product2 LIMIT 1].Id, 'a');
    }
    @IsTest
    static void addComment() {
        LWC_dmlOperation.AddCommentAndRate('', 'a', [SELECT Id FROM Product2 LIMIT 1].Id, 1, 'a', 'a', 1, 1, 1);
    }
    @IsTest
    static void removeComment() {
        LWC_dmlOperation.removeAddedComment('', [SELECT Id FROM Product2 LIMIT 1].Id);
    }
    @IsTest
    static void addtoCart() {
        Map<String, Object> cart = new Map<String, Object>();
        cart.put('userId', 'a');
        cart.put('prodId', 'a');
        LWC_dmlOperation.addProductToCart(cart);
    }
    @IsTest
    static void allprodFromcart() {
        Map<String, Object> cart = new Map<String, Object>();
        cart.put('userId', 'a');
        cart.put('prodId', 'a');
        LWC_dmlOperation.addProductToCart(cart);
        LWC_dmlOperation.allProductsFormCart('a');
    }
    @IsTest
    static void displayCart() {
        LWC_dmlOperation.displayProductToBuy([SELECT Id FROM Product2 LIMIT 1].Id);
    }
    @IsTest
    static void deleteCart() {
        LWC_dmlOperation.displayProductToBuy([SELECT Id FROM Shopping_Cart__c LIMIT 1].Id);
    }
    public HttpResponse respond(HttpRequest param1) {
        HttpResponse response = new HttpResponse();
        response.setHeader('Content-Type', 'application/json');
        response.setBody('{"results":[{"address_components":[{"long_name":"Katowice","short_name":"Katowice","types":["locality","political"]},{"long_name":"Katowice","short_name":"Katowice","types":["administrative_area_level_2","political"]},{"long_name":"Śląskie","short_name":"Śląskie","types":["administrative_area_level_1","political"]},{"long_name":"Polska","short_name":"PL","types":["country","political"]},{"long_name":"40","short_name":"40","types":["postal_code","postal_code_prefix"]}],"formatted_address":"Katowice, Polska","geometry":{"bounds":{"northeast":{"lat":50.2973176,"lng":19.122919},"southwest":{"lat":50.1300272,"lng":18.8914664}},"location":{"lat":50.26489189999999,"lng":19.0237815},"location_type":"APPROXIMATE","viewport":{"northeast":{"lat":50.2973176,"lng":19.122919},"southwest":{"lat":50.1300272,"lng":18.8914664}}},"place_id":"ChIJ0cyhNiPOFkcRu_pZBTUqr7k","types":["locality","political"]}],"status":"OK"}');
        response.setStatusCode(200);
        return response;
    }
    @IsTest
    static void apiCart() {
        Product2 item = [
                SELECT
                        Average_Fuel_Consumption__c,
                        Brands__c,
                        City__c,
                        Country__c,
                        CreatedById,
                        CreatedDate,
                        Cylinder_Capacity__c,
                        Description,
                        DisplayUrl,
                        ExternalDataSourceId,
                        ExternalId,
                        Family,
                        Fuel_Consumption_In_The_City__c,
                        Horsepower__c,
                        Id,
                        IsActive,
                        IsArchived,
                        IsDeleted,
                        LastModifiedById,
                        LastModifiedDate,
                        LastReferencedDate,
                        LastViewedDate,
                        Latitude__c,
                        Longitude__c,
                        Main_Photo__c,
                        Name,
                        Number_of_Doors__c,
                        Number_of_Places__c,
                        ProductCode,
                        Production_Year__c,
                        QuantityUnitOfMeasure,
                        StockKeepingUnit,
                        Street__c,
                        SystemModstamp,
                        Top_Speed__c
                FROM Product2
                LIMIT 1
        ];
        LWC_dmlOperation.apiCall(item);
        LWC_dmlOperation.apiCall(null);
    }


}
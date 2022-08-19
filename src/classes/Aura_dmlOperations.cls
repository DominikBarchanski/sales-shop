/**
 * Created by dominikbarchanski on 04/07/2022.
 */

public without sharing class Aura_dmlOperations {
    @AuraEnabled
    public static void deleteAfterCancel(List<String> photoList) {
        delete [SELECT Id FROM ContentDocument WHERE Id IN :photoList];
    }

    @AuraEnabled
    public static String deleteDocuments(String docId) {
        try {
            delete [SELECT Id FROM ContentDocument WHERE Id = :docId];
            return 'SUCCESS';
        } catch (Exception ex) {
            throw new AuraHandledException(ex.getMessage());
        }
    }

    class jsDataWrapper {
        @AuraEnabled public String name;
        @AuraEnabled public String description;
        @AuraEnabled public Decimal price;
        @AuraEnabled public String mainPhoto;
        @AuraEnabled public List<String> photos;
        @AuraEnabled public String type;
        @AuraEnabled public Integer hp;
        @AuraEnabled public String brand;
        @AuraEnabled public String country;
        @AuraEnabled public String city;
        @AuraEnabled public String street;
        @AuraEnabled public Date prodYear;
        @AuraEnabled public Decimal cityConsumption;
        @AuraEnabled public Decimal avgConsumption;
        @AuraEnabled public Decimal doors;
        @AuraEnabled public Decimal capacity;
        @AuraEnabled public Decimal places;
        @AuraEnabled public Decimal speed;


        jsDataWrapper(Map<String, Object> jsObj) {
            this.name = (String) jsObj.get('name');
            this.mainPhoto = (String) jsObj.get('mainPhoto');
            this.description = (String) jsObj.get('description');
            this.price = Decimal.valueOf((String) jsObj.get('price'));
            this.type = (String) jsObj.get('type');
            this.hp = Integer.valueOf(jsObj.get('hp'));
            this.brand = (String) jsObj.get('brand');
            this.country = (String) jsObj.get('prodCountry');
            this.city = (String) jsObj.get('prodCity');
            this.street = (String) jsObj.get('prodStreet');
            this.cityConsumption = Decimal.valueOf((String) jsObj.get('prodCityConsum'));
            this.avgConsumption = Decimal.valueOf((String) jsObj.get('prodAvgConsum'));
            this.doors = Decimal.valueOf((String) jsObj.get('prodDoors'));
            this.capacity = Decimal.valueOf((String) jsObj.get('prodCapacity'));
            this.places = Decimal.valueOf((String) jsObj.get('prodPlaces'));
            this.speed = Decimal.valueOf((String) jsObj.get('prodSpeed'));
            System.debug(((String) jsObj.get('prodYear')).replace('-', '/'));
            this.prodYear = date.valueOf((String) jsObj.get('prodYear'));
            List<Object> photoList = (List<Object>) JSON.deserializeUntyped(
                    JSON.serialize(jsObj.get('photoList'))
            );
            List<String> newPhotoList = new List<String>();
            for (Object i : photoList) {
                newPhotoList.add(String.valueOf(i));
            }
            this.photos = newPhotoList;
        }

    }
    @AuraEnabled
    public static String insertProduct(Map<String, Object> jsObject) {

        jsDataWrapper recFromJs = new jsDataWrapper(jsObject);

        try {
            Product2 toAdd = new Product2();
            toAdd.Name = recFromJs.name;
            toAdd.Family = recFromJs.type;
            toAdd.Horsepower__c = recFromJs.hp;
            toAdd.Description = recFromJs.description;
            toAdd.Brands__c = recFromJs.brand;
            toAdd.Country__c = recFromJs.country;
            toAdd.City__c = recFromJs.city;
            toAdd.Street__c = recFromJs.street;
            toAdd.Main_Photo__c = recFromJs.mainPhoto != null ? recFromJs.mainPhoto : null;
            toAdd.Production_Year__c = recFromJs.prodYear != null ? recFromJs.prodYear : null;
            toAdd.IsActive = true;
            toAdd.Fuel_Consumption_In_The_City__c = recFromJs.cityConsumption;
            toAdd.Average_Fuel_Consumption__c = recFromJs.avgConsumption;
            toAdd.Number_of_Doors__c = recFromJs.doors;
            toAdd.Cylinder_Capacity__c = recFromJs.capacity;
            toAdd.Number_of_Places__c = recFromJs.places;
            toAdd.Top_Speed__c = recFromJs.speed;
            Http http = new Http();
            HttpRequest request = new HttpRequest();
            String apiAddress = recFromJs.country + '+' + recFromJs.city + '+' + recFromJs.street;
            apiAddress = apiAddress.replace(' ', '+');
            request.setEndpoint('https://maps.googleapis.com/maps/api/geocode/json?address=' + apiAddress + '&key=AIzaSyC6TeiRM56HgxvqR7ncLeZST7Sid6Pky2s');
            request.setMethod('GET');

            HttpResponse response = http.send(request);
            if (response.getStatusCode() == 200) {
                googleJSON2Apex items = googleJSON2Apex.parse(response.getBody());
                System.debug(items);
                String lat = String.valueOf(items.results[0].geometry.location.lat);
                String lng = String.valueOf(items.results[0].geometry.location.lng);
                toAdd.Latitude__c = lat;
                toAdd.Longitude__c = lng;

            }
            insert toAdd;
            System.debug(toAdd.Id);
            if (recFromJs.photos != null) {
                if (recFromJs.photos.size() > 0) {
                    List<ContentVersion> photoRelatedToProduct = [SELECT Id, FirstPublishLocationId, Product__c FROM ContentVersion WHERE ContentDocumentId IN :recFromJs.photos];
                    for (ContentVersion item : photoRelatedToProduct) {
                        item.Product__c = toAdd.Id;
                    }
                    update photoRelatedToProduct;
                }
            }
            Pricebook2 pricebookId = [SELECT Id FROM Pricebook2 WHERE IsStandard = TRUE LIMIT 1];
            PricebookEntry newProd = new PricebookEntry();
            newProd.Pricebook2Id = pricebookId.Id;
            newProd.Product2Id = toAdd.Id;
            newProd.IsActive = true;
            newProd.UnitPrice = recFromJs.price;
            insert newProd;
            Strategy__c newItemInStrategy = new Strategy__c();
            newItemInStrategy.Product2id__c = toAdd.Id;
            newItemInStrategy.Standard_Price__c = recFromJs.price;
            newItemInStrategy.Strategy_price__c = recFromJs.price;
            newItemInStrategy.Strategy_Name__c = 'standard';
            insert newItemInStrategy;


            return null;
        } catch (Exception e) {
            System.debug(e);
            return 'ERROR';
        }
    }
    @AuraEnabled
    public static List<String> getBrands() {
        List<String> options = new List<String>();
        Schema.DescribeFieldResult fieldResult = Product2.Brands__c.getDescribe();
        List<Schema.PicklistEntry> pList = fieldResult.getPicklistValues();
        for (Schema.PicklistEntry p : pList) {
            options.add(p.getLabel());
        }
        return options;
    }

}
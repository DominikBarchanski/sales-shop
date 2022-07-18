/**
 * Created by dominikbarchanski on 04/07/2022.
 */

public with sharing class Aura_dmlOperations {
    @AuraEnabled
    public static void deleteAfterCancel (List<String> photoList ){
        delete [SELECT Id FROM ContentDocument WHERE Id IN :photoList ];
    }
//    @AuraEnabled
//    public static List<Object> getProducts(String name){
//        List<Id,Currency> priceList= new List<Id,Currency>( [SELECT Product2Id, UnitPrice FROM PricebookEntry]);
//        String soqlValue= '%'+ name +'%';
//        List<Product2> productList = [SELECT Id,Name,Family,Horsepower__c,Brands__c FROM Product2];
//        List<Object> retList = new List<Object>();
//        for (Product2 item: productList){
//
//        }
//    }
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
        @AuraEnabled
        public String name;
        @AuraEnabled
        public String description;
        @AuraEnabled
        public Decimal price;
        @AuraEnabled
        public String mainPhoto;
        @AuraEnabled
        public List<String> photos;
        @AuraEnabled
        public String type;
        @AuraEnabled
        public Integer hp;
        @AuraEnabled
        public String brand;

        jsDataWrapper(Map<String, Object> jsObj) {
            this.name = (String) jsObj.get('name');
            this.mainPhoto = (String) jsObj.get('mainPhoto');
            this.description = (String) jsObj.get('description');
            this.price = Decimal.valueOf((String) jsObj.get('price'));
            this.type = (String) jsObj.get('type');
            this.hp = Integer.valueOf(jsObj.get('hp'));
            this.brand = (String) jsObj.get('brand');
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
            toAdd.Main_Photo__c = recFromJs.mainPhoto != null ? recFromJs.mainPhoto : null;
            toAdd.IsActive = true;

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
/**
 * Created by dominikbarchanski on 06/07/2022.
 */

public with sharing class AURA_dmlPriceBookController {
    public class PricebookWrapper {
        @AuraEnabled
        public Id id;
        @AuraEnabled
        public String name;
        @AuraEnabled
        public Boolean isActive;
        @AuraEnabled
        public Boolean isStandard;
        @AuraEnabled
        public Date startDate;
        @AuraEnabled
        public Date endDate;
        public PricebookWrapper(Pricebook2 pricebook) {
            this.id = pricebook.Id;
            this.name = pricebook.Name;
            this.isActive = pricebook.IsActive;
            this.isStandard = pricebook.IsStandard;
            this.startDate = pricebook.Start_Date__c;
            this.endDate = pricebook.End_date__c;
        }
    }
    public class ProductWrapper {
        @AuraEnabled
        public String name;
        @AuraEnabled
        public String type;
        @AuraEnabled
        public Decimal hp;
        @AuraEnabled
        public String brand;
        @AuraEnabled
        public Decimal price;
        @AuraEnabled
        public Id id;
        @AuraEnabled
        public Id pricebookEntryID;
        @AuraEnabled
        public Decimal strategyPrice;
        @AuraEnabled
        public String strategyName;
        public ProductWrapper(Product2 product, PricebookEntry productPrice, Strategy__c strategy) {
            this.name = product.Name;
            this.id = product.Id;
            this.type = product.Family;
            this.hp = product.Horsepower__c;
            this.brand = product.Brands__c;
            this.price = productPrice.UnitPrice;
            this.pricebookEntryID = productPrice.Id;
            this.strategyPrice = strategy.Strategy_price__c;
            this.strategyName = strategy.Strategy_Name__c;
        }

    }
    @AuraEnabled
    public static List<PricebookWrapper> getAllPricebook(String pricebookName) {
        String pricebookSoql = '%' + pricebookName + '%';
        List<Pricebook2> allPricebook = [SELECT Id, Name, IsActive, IsStandard, End_date__c, Start_Date__c FROM Pricebook2 WHERE Name LIKE :pricebookSoql];
        List<PricebookWrapper> pricebookWrapped = new List<PricebookWrapper>();
        for (Pricebook2 item : allPricebook) {

            PricebookWrapper newItem = new PricebookWrapper(item);
            pricebookWrapped.add(newItem);
        }

        return pricebookWrapped;
    }
    public class SinglePricebookWrapper {
        @AuraEnabled
        public String Id;
        @AuraEnabled
        public String Name;
        @AuraEnabled
        public String Description;
        @AuraEnabled
        public Boolean isActive;
        @AuraEnabled
        public List<PricebookEntry> listOfProducts;
        public SinglePricebookWrapper(Pricebook2 priceBook, List<PricebookEntry> productList) {
            this.Id = priceBook.Id;
            this.Name = priceBook.Name;
            this.Description = priceBook.Description;
            this.isActive = priceBook.IsActive;
            this.listOfProducts = productList;
        }

    }
    @AuraEnabled
    public static SinglePricebookWrapper getSpecificPricebook(String pricebookId) {

        Pricebook2 pricebook = [
                SELECT
                        Id, Name, Description, IsActive, End_date__c, Start_Date__c
                FROM Pricebook2
                WHERE Id = :pricebookId
                LIMIT 1
        ];
        List<PricebookEntry> productPricebook = [
                SELECT
                        Id,
                        IsActive,
                        Name,
                        Pricebook2Id,
                        Product2Id,
                        UnitPrice,
                        UseStandardPrice
                FROM PricebookEntry
                WHERE Pricebook2Id = :pricebook.Id
        ];
        SinglePricebookWrapper toJsWrapper = new SinglePricebookWrapper(pricebook, productPricebook);
        System.debug(toJsWrapper);

        return toJsWrapper;

    }
    @AuraEnabled
    public static List<ProductWrapper> getAllStandardProduct(String productName) {
        String productSoql = '%' + productName + '%';
        List<ProductWrapper> allProduct = new List<ProductWrapper>();
        Pricebook2 standardId = [SELECT Id FROM Pricebook2 WHERE IsStandard = TRUE];
        List<PricebookEntry> listToMap = [SELECT Product2Id, Pricebook2Id, UnitPrice, Id FROM PricebookEntry WHERE Pricebook2Id = :standardId.Id];
        Map<String, PricebookEntry> testval = new Map<String, PricebookEntry>();
        for (PricebookEntry item : listToMap) {
            testval.put(item.Product2Id, item);
        }
        List<Strategy__c> strategyPrices = [
                SELECT
                        CreatedById,
                        CreatedDate,
                        Id,
                        IsDeleted,
                        LastModifiedById,
                        LastModifiedDate,
                        Name,
                        OwnerId,
                        Product2id__c,
                        Standard_Price__c,
                        Strategy_price__c,
                        Strategy_Name__c,
                        SystemModstamp
                FROM Strategy__c
        ];
        Map<String,Strategy__c> strategyMap = new Map<String, Strategy__c>();
        for (Strategy__c item : strategyPrices) {
            System.debug(item);
            strategyMap.put(item.Product2id__c, item);
        }

        List<Product2> allProductsSobj = [SELECT Id, Name, Family, Horsepower__c, Brands__c FROM Product2 WHERE Name LIKE :productSoql];
        for (Product2 item : allProductsSobj) {
            ProductWrapper productToList = new ProductWrapper(item, testval.get(item.Id),strategyMap.get(item.Id));
            allProduct.add(productToList);
        }
        return allProduct;
    }
    public class NewPricebookWrapper {
        @AuraEnabled
        public String pricebookName;
        @AuraEnabled
        public String pricebookDescription;
        @AuraEnabled
        public String itemId;
        @AuraEnabled
        public List<Object> productList;
        @AuraEnabled
        public String startDate;
        @AuraEnabled
        public String endDate;

        @AuraEnabled
        public Boolean isActive;
        public NewPricebookWrapper(Map<String, Object> objectFromJS) {
            System.debug(objectFromJS);
            this.pricebookName = (String) objectFromJS.get('pricebookName');
            this.pricebookDescription = (String) objectFromJS.get('pricebookDescription');
            System.debug(objectFromJS.get('Id'));
            this.itemId = (String) objectFromJS.get('Id') != null ? (String) objectFromJS.get('Id') : '';
//            this.isActive = objectFromJS.get('pricebookIsActive') == 'true'?true:false;
            this.isActive = (Boolean) objectFromJS.get('pricebookIsActive') ;
            this.startDate = (String) objectFromJS.get('startDate') ;
            this.endDate = (String) objectFromJS.get('endDate');
            this.productList = (List<Object>) JSON.deserializeUntyped(JSON.serialize(objectFromJS.get('productList')));
        } public NewPricebookWrapper(Map<String, Object> objectFromJS, Boolean toUpdate) {
            this.pricebookName = (String) objectFromJS.get('Name');
            this.pricebookDescription = (String) objectFromJS.get('Description');
            System.debug(objectFromJS.get('Id'));
            this.itemId = (String) objectFromJS.get('Id') != null ? (String) objectFromJS.get('Id') : '';
//            this.isActive = objectFromJS.get('pricebookIsActive') == 'true'?true:false;
            System.debug(objectFromJS);
            System.debug(objectFromJS.get('isActive'));
            this.isActive = (Boolean) objectFromJS.get('isActive') ;
            this.productList = (List<Object>) JSON.deserializeUntyped(JSON.serialize(objectFromJS.get('listOfProducts')));
        }
    }
    @AuraEnabled
    public static String createNewPricebook(Map<String, Object> dataFromJS) {
        NewPricebookWrapper wrappedJS = new NewPricebookWrapper(dataFromJS);
        try {
            Pricebook2 newPricebook = new Pricebook2();
            newPricebook.Name = wrappedJS.pricebookName;
            newPricebook.IsActive = wrappedJS.isActive;
            newPricebook.Description = wrappedJS.pricebookDescription;
            newPricebook.Start_Date__c = Date.valueOf(wrappedJS.startDate);
            newPricebook.End_date__c = Date.valueOf(wrappedJS.endDate);

            insert newPricebook;
            List<PricebookEntry> listToPush = new List<PricebookEntry>();
            for (Object item : wrappedJS.productList) {
                PricebookEntry entryItem = new PricebookEntry();
                Map<String, Object> elem = (Map<String, Object>) item;
                entryItem.Pricebook2Id = newPricebook.Id;
                entryItem.Product2Id = (Id) elem.get('id');
                entryItem.IsActive = true ;
                entryItem.UnitPrice = elem.get('newPrice') != null ? (Decimal) elem.get('newPrice') : (Decimal) elem.get('price') ;
                listToPush.add(entryItem);
            }
            insert listToPush;
            return 'SUCCESS';
        } catch (Exception e) {
            System.debug(e);
            return 'ERROR';
        }


    }
    @AuraEnabled
    public static String updatePricebook(Map<String, Object> dataFromJS) {
        NewPricebookWrapper wrappedJS = new NewPricebookWrapper(dataFromJS, true);
        Pricebook2 pricebook2ToUpdate = [SELECT Id, Name, Description FROM Pricebook2 WHERE Id = :wrappedJS.itemId];
        pricebook2ToUpdate.Name = wrappedJS.pricebookName;
        pricebook2ToUpdate.Description = wrappedJS.pricebookDescription;
        pricebook2ToUpdate.IsActive = wrappedJS.isActive;
        System.debug(pricebook2ToUpdate);
        update pricebook2ToUpdate;
        try {
            List<PricebookEntry> listToPush = new List<PricebookEntry>();
            for (Object item : wrappedJS.productList) {
                Map<String, Object> elem = (Map<String, Object>) item;
                if (elem.get('toInsert') == true) {
                    System.debug(elem);

                    PricebookEntry entryItem = new PricebookEntry();
                    entryItem.Pricebook2Id = pricebook2ToUpdate.Id;
                    entryItem.Product2Id = (Id) elem.get('Product2Id');
                    entryItem.IsActive = true ;
                    entryItem.UnitPrice = elem.get('newPrice') != null ? (Decimal) elem.get('newPrice') : (Decimal) elem.get('UnitPrice') ;
                    listToPush.add(entryItem);
                } else {

                    PricebookEntry entryItem = new PricebookEntry(Id = (Id) elem.get('Id'));
                    entryItem.UnitPrice = Decimal.valueOf(String.valueOf(elem.get('UnitPrice'))) ;
                    listToPush.add(entryItem);
                    System.debug(entryItem);
                    System.debug(item);
                }
                System.debug(listToPush);
            }

            System.debug(listToPush);

            upsert listToPush;
            return 'SUCCESS';
        } catch (Exception e) {
            System.debug(e);
            return 'ERROR';
        }
    }
    @AuraEnabled
    public static void deletePricebookEntryItems(List<Object> listOfItems) {
        List<String> idList = new List<String>() ;
        for (Object item : listOfItems) {
            idList.add((String) item);
        }
        List<PricebookEntry> toDeleteList = [SELECT Id FROM PricebookEntry WHERE Id IN :idList];
        delete toDeleteList;
//        System.debug(toDeleteList);
    }
    @AuraEnabled
    public static void deletePricebook(String pricebookId) {
        Pricebook2 toDelete = [SELECT Id, IsStandard FROM Pricebook2 WHERE Id = :pricebookId LIMIT 1];
        if (!toDelete.IsStandard) {
            delete toDelete;
        }
    }
}
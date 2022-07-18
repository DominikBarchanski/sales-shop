/**
 * Created by dominikbarchanski on 13/07/2022.
 */

public without sharing class LWC_dmlOperation {
    @AuraEnabled(Cacheable=true) public static List<Product2> getAllProducts(String findBy) {
        String forSoql = '%' + findBy + '%';
        return [
                SELECT Brands__c, CreatedById, CreatedDate, Description, DisplayUrl, ExternalDataSourceId, ExternalId, Family, Horsepower__c, Id, IsActive, IsArchived, IsDeleted, LastModifiedById, LastModifiedDate, LastReferencedDate, LastViewedDate, Main_Photo__c, Name, ProductCode, QuantityUnitOfMeasure, StockKeepingUnit, SystemModstamp
                FROM Product2
                WHERE Name LIKE :forSoql OR Description LIKE :forSoql OR Brands__c LIKE :forSoql OR Family LIKE :forSoql
        ];
    }
    @AuraEnabled(Cacheable=true) public static List<PricebookEntry> getAllPricebookItems() {
        return [
                SELECT CreatedById, CreatedDate, Id, IsActive, IsArchived, IsDeleted, LastModifiedById, LastModifiedDate, Name, Pricebook2Id, Product2Id, ProductCode, SystemModstamp, UnitPrice, UseStandardPrice
                FROM PricebookEntry
        ];
    }
    @AuraEnabled(Cacheable=true) public static List<ContentDistribution> getAllContentDistribution() {
        return [
                SELECT
                        ContentDocumentId,
                        ContentDownloadUrl,
                        ContentVersionId,
                        CreatedById,
                        CreatedDate,
                        DistributionPublicUrl,
                        ExpiryDate,
                        FirstViewDate,
                        Id,
                        IsDeleted,
                        LastModifiedById,
                        LastModifiedDate,
                        LastViewDate,
                        Name,
                        OwnerId,
                        Password,
                        PdfDownloadUrl,
                        PreferencesAllowOriginalDownload,
                        PreferencesAllowPDFDownload,
                        PreferencesAllowViewInBrowser,
                        PreferencesExpires,
                        PreferencesLinkLatestVersion,
                        PreferencesNotifyOnVisit,
                        PreferencesNotifyRndtnComplete,
                        PreferencesPasswordRequired,
                        RelatedRecordId,
                        SystemModstamp,
                        ViewCount
                FROM ContentDistribution
        ];
    }
    public class SearchProductWrapper {
        @AuraEnabled public String id;
        @AuraEnabled public String name;
        @AuraEnabled public String description;
        @AuraEnabled public String brand;
        @AuraEnabled public String type;
        @AuraEnabled public String photoUrl;
        @AuraEnabled public Decimal price;
        @AuraEnabled public Decimal priceWithDiscount;
//        @AuraEnabled public String url = 'https://britenet7-dev-ed--c.documentforce.com/sfc/dist/version/download/?oid=00D7Q000004Qv7A&ids=0687Q00000357uZ&d=%2Fa%2F7Q000000TP5r%2FaE5dsVi0EWBYWF_ZFYE_VCQlp_0s.DYJzUsekfPN92k&asPdf=false';

        public SearchProductWrapper(Product2 product, Strategy__c strategy, ContentDistribution content) {
            this.id = String.valueOf(Product2.Id);
            this.name = product.Name;
            this.type = product.Family;
            this.brand = product.Brands__c;
            this.description = product.Description;
            this.price = strategy.Standard_Price__c;
            this.priceWithDiscount = strategy.Strategy_price__c;
            this.photoUrl = content.ContentDownloadUrl != null ? content.ContentDownloadUrl : PageReference.forResource('display_on_error').getUrl();

        }
    }

    @AuraEnabled(Cacheable=true) public static List<SearchProductWrapper> searchProduct(String findBy) {
        List<Product2> findedProduct = getAllProducts(findBy);
        List<PricebookEntry> findedPricebookEntries = getAllPricebookItems();
        List<ContentDistribution> allContentDistribution = getAllContentDistribution();
        List<Strategy__c> allStrategyPrice = [
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
                        Strategy_Name__c,
                        Strategy_price__c,
                        SystemModstamp
                FROM Strategy__c];
        Map<String,Strategy__c> mapOfStrategy = new Map<String, Strategy__c>();
        for (Strategy__c item :allStrategyPrice){
            mapOfStrategy.put(item.Product2id__c,item);
        }
        Map<String, PricebookEntry> mapOfPrice = new Map<String, PricebookEntry>();
        for (PricebookEntry item : findedPricebookEntries) {
            mapOfPrice.put(item.Product2Id, item);
        }
        Map<String, ContentDistribution> mapOfContent = new Map<String, ContentDistribution>();
        for (ContentDistribution item : allContentDistribution) {
            mapOfContent.put(item.ContentDocumentId, item);
        }

        List<SearchProductWrapper> listOfFindedProducts = new List<LWC_dmlOperation.SearchProductWrapper>();
        for (Product2 item : findedProduct) {
            SearchProductWrapper itemToAdd = new SearchProductWrapper(item, mapOfStrategy.get(item.Id), (mapOfContent.containsKey(item.Main_Photo__c) ? mapOfContent.get(item.Main_Photo__c) : new ContentDistribution()));
            listOfFindedProducts.add(itemToAdd);
        }
        return listOfFindedProducts;
    }
}
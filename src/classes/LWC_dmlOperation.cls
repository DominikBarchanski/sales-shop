/**
 * Created by dominikbarchanski on 13/07/2022.
 */

public without sharing class LWC_dmlOperation {
    @AuraEnabled(Cacheable=true) public static List<Product2> getAllProducts(String findBy) {
        String forSoql = '%' + findBy + '%';
        return [
                SELECT Brands__c, Production_Year__c, CreatedById, CreatedDate, Description, DisplayUrl, ExternalDataSourceId, ExternalId, Family, Horsepower__c, Id, IsActive, IsArchived, IsDeleted, LastModifiedById, LastModifiedDate, LastReferencedDate, LastViewedDate, Main_Photo__c, Name, ProductCode, QuantityUnitOfMeasure, StockKeepingUnit, SystemModstamp
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
    @AuraEnabled(Cacheable=true) public static List<ContentVersion> getAllContentVersion() {
        return [
                SELECT
                        Checksum,
                        ContentBodyId,
                        ContentDocumentId,
                        ContentLocation,
                        ContentModifiedById,
                        ContentModifiedDate,
                        ContentSize,
                        ContentUrl,
                        CreatedById,
                        CreatedDate,
                        Description,
                        ExternalDataSourceId,
                        ExternalDocumentInfo1,
                        ExternalDocumentInfo2,
                        FeaturedContentBoost,
                        FeaturedContentDate,
                        FileExtension,
                        FileType,
                        FirstPublishLocationId,
                        Id,
                        IsAssetEnabled,
                        IsDeleted,
                        IsLatest,
                        IsMajorVersion,
                        LastModifiedById,
                        LastModifiedDate,
                        NegativeRatingCount,
                        NetworkId,
                        Origin,
                        OwnerId,
                        PathOnClient,
                        PositiveRatingCount,
                        Product__c,
                        PublishStatus,
                        RatingCount,
                        ReasonForChange,
                        SharingOption,
                        SharingPrivacy,
                        SystemModstamp,
                        TagCsv,
                        TextPreview,
                        Title,
                        VersionData,
                        VersionNumber
                FROM ContentVersion
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
        @AuraEnabled public String country;
        @AuraEnabled public String city;
        @AuraEnabled public String street;
        @AuraEnabled public Decimal hp;
        @AuraEnabled public Decimal price;
        @AuraEnabled public Decimal priceWithDiscount;
        @AuraEnabled public Decimal prodYear;
        @AuraEnabled public List<String> photoList;
        @AuraEnabled public List<Product_Rating__c> prodRatings;

//        @AuraEnabled public String url = 'https://britenet7-dev-ed--c.documentforce.com/sfc/dist/version/download/?oid=00D7Q000004Qv7A&ids=0687Q00000357uZ&d=%2Fa%2F7Q000000TP5r%2FaE5dsVi0EWBYWF_ZFYE_VCQlp_0s.DYJzUsekfPN92k&asPdf=false';

        public SearchProductWrapper(Product2 product, Strategy__c strategy, ContentDistribution content, List<String> photoList) {
            this.id = product.Id;
            this.name = product.Name;
            this.type = product.Family;
            this.brand = product.Brands__c;
            this.hp = product.Horsepower__c;
            this.prodYear = product .Production_Year__c != null ? product .Production_Year__c.year() : null;
            this.description = product.Description;
            this.price = strategy.Standard_Price__c.setScale(2);
            this.priceWithDiscount = strategy.Strategy_price__c.setScale(2);
            this.photoUrl = content.ContentDownloadUrl != null ? content.ContentDownloadUrl : PageReference.forResource('display_on_error').getUrl();
            this.photoList = photoList;
        } public SearchProductWrapper(Product2 product, Strategy__c strategy, ContentDistribution content, List<String> photoList, List<Product_Rating__c> rating) {
            this.id = product.Id;
            this.name = product.Name;
            this.type = product.Family;
            this.brand = product.Brands__c;
            this.hp = product.Horsepower__c;
            this.country = product.Country__c;
            this.city = product.City__c;
            this.street = product.Street__c;
            this.prodYear = product .Production_Year__c != null ? product .Production_Year__c.year() : null;
            this.description = product.Description;
            this.price = strategy.Standard_Price__c.setScale(2);
            this.priceWithDiscount = strategy.Strategy_price__c.setScale(2);
            this.photoUrl = content.ContentDownloadUrl != null ? content.ContentDownloadUrl : PageReference.forResource('display_on_error').getUrl();
            this.photoList = photoList;
            this.prodRatings = rating;
        }
    }

    @AuraEnabled(Cacheable=true) public static List<SearchProductWrapper> searchProduct(String findBy) {
        List<Product2> findedProduct = getAllProducts(findBy);
//        List<PricebookEntry> findedPricebookEntries = getAllPricebookItems();
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
                FROM Strategy__c
        ];
        Map<String, Strategy__c> mapOfStrategy = new Map<String, Strategy__c>();
        for (Strategy__c item : allStrategyPrice) {
            mapOfStrategy.put(item.Product2id__c, item);
        }
//        Map<String, PricebookEntry> mapOfPrice = new Map<String, PricebookEntry>();
//        for (PricebookEntry item : findedPricebookEntries) {
//            mapOfPrice.put(item.Product2Id, item);
//        }
        Map<String, ContentDistribution> mapOfContent = new Map<String, ContentDistribution>();
        Map<String, List<String>> mapOfPhoto = new Map<String, List<String>>();

        for (ContentDistribution item : allContentDistribution) {
            mapOfContent.put(item.ContentDocumentId, item);
            if (mapOfPhoto.containsKey(item.Name)) {
                mapOfPhoto.get(item.Name).add(mapOfContent.get(item.ContentDocumentId).ContentDownloadUrl);

            } else {
                mapOfPhoto.put(item.Name, new List<String>{
                        mapOfContent.get(item.ContentDocumentId).ContentDownloadUrl
                });

            }

        }
        List<SearchProductWrapper> listOfFindedProducts = new List<LWC_dmlOperation.SearchProductWrapper>();
        for (Product2 item : findedProduct) {
            SearchProductWrapper itemToAdd = new SearchProductWrapper(item, mapOfStrategy.get(item.Id), (mapOfContent.containsKey(item.Main_Photo__c) ? mapOfContent.get(item.Main_Photo__c) : new ContentDistribution()), mapOfPhoto.get(item.Id));
            listOfFindedProducts.add(itemToAdd);
        }
        return listOfFindedProducts;
    }
    @AuraEnabled
    public static SearchProductWrapper getSingleProduct(String ProdId) {
        Product2 getProduct = [
                SELECT
                        Brands__c,
                        Description,
                        Family,
                        Horsepower__c,
                        Id,
                        IsActive,
                        IsArchived,
                        IsDeleted,
                        Main_Photo__c,
                        Name,
                        Production_Year__c,
                        Country__c,
                        City__c,
                        Street__c
                FROM Product2
                WHERE Id = :ProdId
        ];
        Strategy__c getStrategy = [
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
                FROM Strategy__c
                WHERE Product2id__c = :ProdId
        ];
        List<Product_Rating__c> rating = [
                SELECT
                        Comment__c,
                        CreatedById,
                        CreatedDate,
                        CreatedBy.Name,
                        Id,
                        IsDeleted,
                        LastModifiedById,
                        LastModifiedDate,
                        Name,
                        OwnerId,
                        Product_Id__c,
                        Rating__c,
                        SystemModstamp,
                        User_Id__c
                FROM Product_Rating__c
                WHERE Product_Id__c = :ProdId
        ];
        Map<String, ContentDistribution> mapOfContent = new Map<String, ContentDistribution>();
        Map<String, List<String>> mapOfPhoto = new Map<String, List<String>>();
        List<ContentDistribution> allContentDistribution = getAllContentDistribution();
        for (ContentDistribution item : allContentDistribution) {
            mapOfContent.put(item.ContentDocumentId, item);
            if (mapOfPhoto.containsKey(item.Name)) {
                mapOfPhoto.get(item.Name).add(mapOfContent.get(item.ContentDocumentId).ContentDownloadUrl);

            } else {
                mapOfPhoto.put(item.Name, new List<String>{
                        mapOfContent.get(item.ContentDocumentId).ContentDownloadUrl
                });

            }

        }

        SearchProductWrapper productToDisplay = new SearchProductWrapper(getProduct, getStrategy, (mapOfContent.containsKey(getProduct.Main_Photo__c) ? mapOfContent.get(getProduct.Main_Photo__c) : new ContentDistribution()), mapOfPhoto.get(ProdId), rating);
        return productToDisplay;
    }
    @AuraEnabled
    public static List<Product_Rating__c> AddCommentAndRate(String commentId, String userId, String productId, Decimal rate, String title, String body) {
        List<Product_Rating__c> checkIfRated = [SELECT Id FROM Product_Rating__c WHERE User_Id__c = :userId AND Product_Id__c = :productId];

        if (checkIfRated.size() > 0) {
            return [
                    SELECT
                            Comment__c,
                            CreatedById,
                            CreatedDate,
                            Id,
                            IsDeleted,
                            LastModifiedById,
                            LastModifiedDate,
                            CreatedBy.Name,
                            Name,
                            OwnerId,
                            Product_Id__c,
                            Rating__c,
                            SystemModstamp,
                            User_Id__c
                    FROM Product_Rating__c WHERE Product_Id__c = :productId ];
        } else {
            Product_Rating__c toAdd = commentId ==''? new Product_Rating__c() :new Product_Rating__c(Id = commentId);
            toAdd.Product_Id__c = productId;
            toAdd.User_Id__c = userId;

            toAdd.Rating__c = rate;
            toAdd.Name = title;
            toAdd.Comment__c = body;
            upsert toAdd;
            return [
                    SELECT
                            Comment__c,
                            CreatedById,
                            CreatedDate,
                            Id,
                            CreatedBy.Name,
                            IsDeleted,
                            LastModifiedById,
                            LastModifiedDate,
                            Name,
                            OwnerId,
                            Product_Id__c,
                            Rating__c,
                            SystemModstamp,
                            User_Id__c
                    FROM Product_Rating__c WHERE Product_Id__c = :productId ];
        }

    }
}
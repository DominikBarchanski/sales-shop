/**
 * Created by dominikbarchanski on 13/07/2022.
 */

public without sharing class LWC_dmlOperation {
    @AuraEnabled(Cacheable=true) public static List<Product2> getAllProducts(String findBy) {
        String forSoql = '%' + findBy + '%';
        return [
                SELECT
                        Average_Fuel_Consumption__c,
                        Brands__c,
                        Country__c,
                        City__c,
                        Street__c,
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
                        Main_Photo__c,
                        Name,
                        Number_of_Doors__c,
                        Number_of_Places__c,
                        ProductCode,
                        Production_Year__c,
                        QuantityUnitOfMeasure,
                        StockKeepingUnit,
                        SystemModstamp,
                        Top_Speed__c,
                        Latitude__c,
                        Longitude__c
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
        @AuraEnabled public List<Shopping_Cart__c> prodCart;
        @AuraEnabled public Decimal cityConsumption;
        @AuraEnabled public Decimal avgConsumption;
        @AuraEnabled public Decimal doors;
        @AuraEnabled public Decimal capacity;
        @AuraEnabled public Decimal places;
        @AuraEnabled public Decimal speed;
        @AuraEnabled public String lat;
        @AuraEnabled public String lng;


//        @AuraEnabled public String url = 'https://britenet7-dev-ed--c.documentforce.com/sfc/dist/version/download/?oid=00D7Q000004Qv7A&ids=0687Q00000357uZ&d=%2Fa%2F7Q000000TP5r%2FaE5dsVi0EWBYWF_ZFYE_VCQlp_0s.DYJzUsekfPN92k&asPdf=false';

        public SearchProductWrapper(Product2 product, Strategy__c strategy, ContentDistribution content, List<String> photoList) {
            this.id = product.Id;
            this.name = product.Name;
            this.type = product.Family;
            this.brand = product.Brands__c;
            this.hp = product.Horsepower__c;
            this.country = product.Country__c;
            this.city = product.City__c;
            this.street = product.Street__c;
            this.lat = product.Latitude__c;
            this.lng = product.Longitude__c;
            this.prodYear = product .Production_Year__c != null ? product .Production_Year__c.year() : null;
            this.description = product.Description;
            this.price = strategy.Standard_Price__c.setScale(2);
            this.priceWithDiscount = strategy.Strategy_price__c.setScale(2);
            this.photoUrl = content.ContentDownloadUrl != null ? content.ContentDownloadUrl : PageReference.forResource('display_on_error').getUrl();
            this.photoList = photoList;
        } public SearchProductWrapper(Product2 product, Strategy__c strategy, ContentDistribution content, List<String> photoList, List<Product_Rating__c> rating, List<Shopping_Cart__c> cart) {
            this.id = product.Id;
            this.name = product.Name;
            this.type = product.Family;
            this.brand = product.Brands__c;
            this.hp = product.Horsepower__c;
            this.country = product.Country__c;
            this.city = product.City__c;
            this.street = product.Street__c;
            this.cityConsumption = product.Fuel_Consumption_In_The_City__c;
            this.avgConsumption = product.Average_Fuel_Consumption__c;
            this.doors = product.Number_of_Doors__c;
            this.capacity = product.Cylinder_Capacity__c;
            this.places = product.Number_of_Places__c;
            this.speed = product.Top_Speed__c;
            this.prodYear = product .Production_Year__c != null ? product .Production_Year__c.year() : null;
            this.description = product.Description;
            this.price = strategy.Standard_Price__c.setScale(2);
            this.priceWithDiscount = strategy.Strategy_price__c.setScale(2);
            this.photoUrl = content.ContentDownloadUrl != null ? content.ContentDownloadUrl : PageReference.forResource('display_on_error').getUrl();
            this.photoList = photoList;
            this.prodRatings = rating;
            this.prodCart = cart;
        }
    }

    @AuraEnabled(Cacheable=true) public static List<SearchProductWrapper> searchProduct(String findBy) {
        List<Product2> findedProduct = getAllProducts(findBy);
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
    public static SearchProductWrapper getSingleProduct(String ProdId, String UserId) {
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
                        Street__c,
                        Average_Fuel_Consumption__c,
                        Cylinder_Capacity__c,
                        Fuel_Consumption_In_The_City__c,
                        Top_Speed__c,
                        Number_of_Doors__c,
                        Number_of_Places__c
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
                        Rate_Price__c,
                        Rate_Design__c,
                        Rate_Safety__c,
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
                        User_Id__c,
                        Approval__c
                FROM Product_Rating__c
                WHERE Product_Id__c = :ProdId
        ];
        List<Shopping_Cart__c> prodInCart = [
                SELECT
                        CreatedById,
                        CreatedDate,
                        Id,
                        IsDeleted,
                        LastModifiedById,
                        LastModifiedDate,
                        Name,
                        OwnerId,
                        Product_Id__c,
                        Quantity__c,
                        SystemModstamp,
                        User_Id__c
                FROM Shopping_Cart__c
                WHERE CreatedById = :UserId
        ];
        System.debug(ProdId);
        System.debug(UserId);
        System.debug(prodInCart);
        Map<String, ContentDistribution> mapOfContent = new Map<String, ContentDistribution>();
        List<ContentDistribution> allContentDistribution = getAllContentDistribution();
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

        SearchProductWrapper productToDisplay = new SearchProductWrapper(getProduct, getStrategy, (mapOfContent.containsKey(getProduct.Main_Photo__c) ? mapOfContent.get(getProduct.Main_Photo__c) : new ContentDistribution()), mapOfPhoto.get(ProdId), rating, prodInCart);
        return productToDisplay;
    }
    @AuraEnabled
    public static List<Product_Rating__c> AddCommentAndRate(String commentId, String userId, String productId, Decimal rate, String title, String body, Decimal rateSafe, Decimal ratePrice, Decimal rateDesign) {
        List<Product_Rating__c> checkIfRated = [SELECT Id FROM Product_Rating__c WHERE User_Id__c = :userId AND Product_Id__c = :productId];

        if (checkIfRated.size() > 0 && commentId == '') {
            return [
                    SELECT
                            Comment__c,
                            Rate_Price__c,
                            Rate_Design__c,
                            Rate_Safety__c,
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
                    FROM Product_Rating__c
                    WHERE Product_Id__c = :productId
            ];
        } else {
            Product_Rating__c toAdd = commentId == '' ? new Product_Rating__c() : new Product_Rating__c(Id = commentId);
            toAdd.Product_Id__c = productId;
            toAdd.User_Id__c = userId;
            toAdd.Rate_Price__c = ratePrice;
            toAdd.Rate_Design__c = rateDesign;
            toAdd.Rate_Safety__c = rateSafe;
            toAdd.Rating__c = rate;
            toAdd.Approval__c = 'new';
            toAdd.Name = title;
            toAdd.Comment__c = body;
            upsert toAdd;
            return [
                    SELECT
                            Comment__c,
                            CreatedById,
                            CreatedDate,
                            Id,
                            Rate_Price__c,
                            Rate_Design__c,
                            Rate_Safety__c,
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
                    FROM Product_Rating__c
                    WHERE Product_Id__c = :productId
            ];
        }

    }
    @AuraEnabled
    public static List<Product_Rating__c> removeAddedComment(String commentId, String currentProduct) {
        delete [SELECT Id FROM Product_Rating__c WHERE Id = :commentId LIMIT 1];
        System.debug(currentProduct);
        return [
                SELECT
                        Comment__c,
                        CreatedById,
                        CreatedDate,
                        Rate_Price__c,
                        Rate_Design__c,
                        Rate_Safety__c,
                        Id,
                        IsDeleted,
                        CreatedBy.Name,
                        LastModifiedById,
                        LastModifiedDate,
                        Name,
                        OwnerId,
                        Product_Id__c,
                        Rating__c,
                        SystemModstamp,
                        User_Id__c
                FROM Product_Rating__c
                WHERE Product_Id__c = :currentProduct
        ];
    }
    @AuraEnabled
    public static List<Shopping_Cart__c> addProductToCart(Map<String, Object> productWrapper) {
        String userid = (String) productWrapper.get('userId');
        String prodId = (String) productWrapper.get('prodId');
        System.debug(userid + ' ' + prodId);
        List<Shopping_Cart__c> alreadyIn = [SELECT Id, User_Id__c, Product_Id__c FROM Shopping_Cart__c WHERE User_Id__c = :userid AND Product_Id__c = :prodId];
        System.debug(alreadyIn);
        if (!(alreadyIn.size() > 0)) {
            Shopping_Cart__c newProdInCart = new Shopping_Cart__c();
            newProdInCart.User_Id__c = (String) productWrapper.get('userId');
            newProdInCart.Product_Id__c = (String) productWrapper.get('prodId');
            insert newProdInCart;
        }
        return [
                SELECT
                        CreatedById,
                        CreatedDate,
                        Id,
                        IsDeleted,
                        LastModifiedById,
                        LastModifiedDate,
                        Name,
                        OwnerId,
                        Product_Id__c,
                        Quantity__c,
                        SystemModstamp,
                        User_Id__c
                FROM Shopping_Cart__c
        ];
    }
    public class ShoppingCartWrapper {
        @AuraEnabled public String id;
        @AuraEnabled public String prodId;
        @AuraEnabled public String name;
        @AuraEnabled public Decimal price;
        @AuraEnabled public String fullAddress;
        @AuraEnabled public Decimal cityConsumption;
        @AuraEnabled public Decimal avgConsumption;
        @AuraEnabled public Decimal doors;
        @AuraEnabled public Decimal capacity;
        @AuraEnabled public Decimal places;
        @AuraEnabled public Decimal speed;
        @AuraEnabled public String photoUrl;
        @AuraEnabled public String country;
        @AuraEnabled public String city;
        @AuraEnabled public String street;


        public ShoppingCartWrapper(Product2 prodInfo, Shopping_Cart__c cart, Strategy__c price, ContentDistribution mainPhoto) {
            this.id = cart.Id;
            this.country = prodInfo.Country__c;
            this.city = prodInfo.City__c;
            this.street = prodInfo.Street__c;
            this.fullAddress = prodInfo.Country__c + ' ' + prodInfo.City__c + ' ' + prodInfo.Street__c;
            this.prodId = prodInfo.Id;
            this.name = prodInfo.Brands__c + ' ' + prodInfo.Name;
            this.price = price.Strategy_price__c .setScale(2);
            this.cityConsumption = prodInfo.Fuel_Consumption_In_The_City__c;
            this.avgConsumption = prodInfo.Average_Fuel_Consumption__c;
            this.doors = prodInfo.Number_of_Doors__c;
            this.capacity = prodInfo.Cylinder_Capacity__c;
            this.places = prodInfo.Number_of_Places__c;
            this.speed = prodInfo.Top_Speed__c;
            this.photoUrl = mainPhoto.ContentDownloadUrl != null ? mainPhoto.ContentDownloadUrl : PageReference.forResource('display_on_error').getUrl();
        }
        public ShoppingCartWrapper(Product2 prodInfo, Strategy__c price, ContentDistribution mainPhoto) {
            this.fullAddress = prodInfo.Country__c + ' ' + prodInfo.City__c + ' ' + prodInfo.Street__c;
            this.country = prodInfo.Country__c;
            this.city = prodInfo.City__c;
            this.street = prodInfo.Street__c;
            this.prodId = prodInfo.Id;
            this.name = prodInfo.Brands__c + ' ' + prodInfo.Name;
            this.price = price.Strategy_price__c .setScale(2);
            this.cityConsumption = prodInfo.Fuel_Consumption_In_The_City__c;
            this.avgConsumption = prodInfo.Average_Fuel_Consumption__c;
            this.doors = prodInfo.Number_of_Doors__c;
            this.capacity = prodInfo.Cylinder_Capacity__c;
            this.places = prodInfo.Number_of_Places__c;
            this.speed = prodInfo.Top_Speed__c;
            this.photoUrl = mainPhoto.ContentDownloadUrl != null ? mainPhoto.ContentDownloadUrl : PageReference.forResource('display_on_error').getUrl();
        }
    }
    @AuraEnabled
    public static List<ShoppingCartWrapper> allProductsFormCart(String userId) {
        List<Shopping_Cart__c> allProdInCart = [
                SELECT CreatedById, CreatedDate, Id, IsDeleted, LastModifiedById, LastModifiedDate, Name, OwnerId, Product_Id__c, Quantity__c, SystemModstamp, User_Id__c
                FROM Shopping_Cart__c
                WHERE User_Id__c = :userId
        ];
        List<String> listOfProduct = new List<String>();
        for (Shopping_Cart__c item : allProdInCart) {
            listOfProduct.add(item.Product_Id__c);
        }
        List<Strategy__c> allStrategyPrice = [
                SELECT CreatedById, CreatedDate, Id, IsDeleted, LastModifiedById, LastModifiedDate, Name, OwnerId, Product2id__c, Standard_Price__c, Strategy_Name__c, Strategy_price__c, SystemModstamp
                FROM Strategy__c
        ];
        Map<String, Strategy__c> mapOfStrategy = new Map<String, Strategy__c>();
        for (Strategy__c item : allStrategyPrice) {
            mapOfStrategy.put(item.Product2id__c, item);
        }
        List<Product2> allProductInCartsProduct2 = [
                SELECT Average_Fuel_Consumption__c, Brands__c, City__c, Country__c, CreatedById, CreatedDate, Cylinder_Capacity__c, Description, DisplayUrl, ExternalDataSourceId, ExternalId, Family, Fuel_Consumption_In_The_City__c, Horsepower__c, Id, Top_Speed__c, IsActive, IsArchived, IsDeleted, LastModifiedById, LastModifiedDate, LastReferencedDate, LastViewedDate, Main_Photo__c, Name, Number_of_Doors__c, Number_of_Places__c, ProductCode, Production_Year__c, QuantityUnitOfMeasure, StockKeepingUnit, Street__c, SystemModstamp
                FROM Product2
                WHERE Id IN :listOfProduct
        ];
        Map<String, Product2> mapOfProduct = new Map<String, Product2>();
        for (Product2 item : allProductInCartsProduct2) {
            mapOfProduct.put(item.Id, item);
        }
        Map<String, ContentDistribution> mapOfContent = new Map<String, ContentDistribution>();
        List<ContentDistribution> allContentDistribution = getAllContentDistribution();
        for (ContentDistribution item : allContentDistribution) {
            mapOfContent.put(item.ContentDocumentId, item);
        }
        List<ShoppingCartWrapper> listToFrontCart = new List<LWC_dmlOperation.ShoppingCartWrapper>();
        for (Shopping_Cart__c item : allProdInCart) {
            ShoppingCartWrapper itemToAdd = new ShoppingCartWrapper(mapOfProduct.get(item.Product_Id__c), item, mapOfStrategy.get(item.Product_Id__c), mapOfContent.get(mapOfProduct.get(item.Product_Id__c).Main_Photo__c));
            listToFrontCart.add(itemToAdd);
        }
        return listToFrontCart;
    }
    @AuraEnabled
    public static ShoppingCartWrapper displayProductToBuy(String productId) {
        Strategy__c allStrategyPrice = [
                SELECT CreatedById, CreatedDate, Id, IsDeleted, LastModifiedById, LastModifiedDate, Name, OwnerId, Product2id__c, Standard_Price__c, Strategy_Name__c, Strategy_price__c, SystemModstamp
                FROM Strategy__c
                WHERE Product2id__c = :productId
        ];

        Product2 allProductInCartsProduct2 = [
                SELECT Average_Fuel_Consumption__c, Brands__c, City__c, Country__c, CreatedById, CreatedDate, Cylinder_Capacity__c, Description, DisplayUrl, ExternalDataSourceId, ExternalId, Family, Fuel_Consumption_In_The_City__c, Horsepower__c, Id, Top_Speed__c, IsActive, IsArchived, IsDeleted, LastModifiedById, LastModifiedDate, LastReferencedDate, LastViewedDate, Main_Photo__c, Name, Number_of_Doors__c, Number_of_Places__c, ProductCode, Production_Year__c, QuantityUnitOfMeasure, StockKeepingUnit, Street__c, SystemModstamp
                FROM Product2
                WHERE Id = :productId
        ];

        Map<String, ContentDistribution> mapOfContent = new Map<String, ContentDistribution>();
        List<ContentDistribution> allContentDistribution = getAllContentDistribution();
        for (ContentDistribution item : allContentDistribution) {
            mapOfContent.put(item.ContentDocumentId, item);
        }
        ShoppingCartWrapper itemToAdd = new ShoppingCartWrapper(allProductInCartsProduct2, allStrategyPrice, mapOfContent.get(allProductInCartsProduct2.Main_Photo__c));
        return itemToAdd;
    }
    @AuraEnabled
    public static List<Shopping_Cart__c> deleteFromCart(String cartId) {
        delete [SELECT Id FROM Shopping_Cart__c WHERE Id = :cartId];
        return [
                SELECT
                        CreatedById,
                        CreatedDate,
                        Id,
                        IsDeleted,
                        LastModifiedById,
                        LastModifiedDate,
                        Name,
                        OwnerId,
                        Product_Id__c,
                        Quantity__c,
                        SystemModstamp,
                        User_Id__c
                FROM Shopping_Cart__c
        ];
    }

    @AuraEnabled
    public static Product2 apiCall(Product2 item) {
        Http http = new Http();
        HttpRequest request = new HttpRequest();
        String apiAddress = item.Country__c +'+'+item.City__c+'+'+item.Street__c;
        apiAddress = apiAddress.replace(' ','+');
        request.setEndpoint('https://maps.googleapis.com/maps/api/geocode/json?address='+apiAddress+'&key=AIzaSyC6TeiRM56HgxvqR7ncLeZST7Sid6Pky2s');
        request.setMethod('GET');
        System.debug(request);
        HttpResponse response = http.send(request);
        if (response.getStatusCode() == 200) {
            googleJSON2Apex items = googleJSON2Apex.parse(response.getBody());
            String lat= String.valueOf(items.results[0].geometry.location.lat);
            String lng=String.valueOf( items.results[0].geometry.location.lng);
            item.Latitude__c = lat;
            item.Longitude__c = lng;
            return item;
        }
        return new Product2();
    }

}
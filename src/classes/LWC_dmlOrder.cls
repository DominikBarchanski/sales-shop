/**
 * Created by dominikbarchanski on 28/07/2022.
 */

public with sharing class LWC_dmlOrder {

    public class ItemOrderWrapper {
        @AuraEnabled public String prodId;
        @AuraEnabled public Decimal unitPrice;
        @AuraEnabled public String pricebookEntryId;
        @AuraEnabled public String shipping;
        @AuraEnabled public String payment;
        @AuraEnabled public String userId;
        ItemOrderWrapper(Map<String, Object> itemDetails, PricebookEntry entryId) {
            this.prodId = (String) itemDetails.get('prodId');
            this.unitPrice = (Decimal) itemDetails.get('unitPrice');
            this.pricebookEntryId = entryId.Id;
            this.shipping= (String) itemDetails.get('shipping');
            this.payment= (String) itemDetails.get('payment');
            this.userId = (String) itemDetails.get('userId');
        }
    }

    @AuraEnabled
    public static Order createOrder(Map<String, Object> orderItem) {
        Account acc = [SELECT Id FROM Account WHERE Id = '0017Q00000OARrAQAX'];
        Pricebook2 standardPricebook2 = [SELECT Id FROM Pricebook2 WHERE IsStandard = TRUE];
        System.debug(orderItem);
        PricebookEntry itemPricebookEntry = [SELECT Id FROM PricebookEntry WHERE Pricebook2Id = :standardPricebook2.Id AND Product2Id = :(String) orderItem.get('prodId')];
        ItemOrderWrapper wrappedItem = new ItemOrderWrapper(orderItem, itemPricebookEntry);
        Order newOrder = new Order(
                Order_Address__c = wrappedItem.shipping,
                Description = wrappedItem.payment,
                AccountId = acc.Id,
                Status = 'Draft',
                EffectiveDate = Date.today(),
                Pricebook2Id = standardPricebook2.Id
        );
        try {
            insert newOrder;
            List<Shopping_Cart__c> items= [SELECT Id FROM Shopping_Cart__c WHERE CreatedById =: wrappedItem.userId];
            delete items;
        } catch (DmlException e) {
            System.debug(e);
        } finally {
            addOrderItem(newOrder.Id, wrappedItem);
        }
        return newOrder;
    }
    @AuraEnabled
    public static void addOrderItem(String orderID, ItemOrderWrapper itemToOrder) {
        OrderItem orderedItem = new OrderItem();
        orderedItem.Product2Id = itemToOrder.prodId;
        orderedItem.OrderId = orderID;
        orderedItem.Quantity = 1 ;
        orderedItem.UnitPrice = itemToOrder.unitPrice;
        orderedItem.PricebookEntryId = itemToOrder.pricebookEntryId;
        insert orderedItem;
//        orderedItem.ServiceDate = Date.today();
//        orderedItem.EndDate = Date.today()+2;


    }
    public class OrderHistoryWrapper {
        @AuraEnabled public  String Id;
        @AuraEnabled public Datetime createDate;
        @AuraEnabled public String orderNumber;
        @AuraEnabled public Decimal price;
        @AuraEnabled public List<OrderItem> orderItem;
        @AuraEnabled public String photos;
        @AuraEnabled public String shipping;
        @AuraEnabled public String payment;
        @AuraEnabled public String productName;


        OrderHistoryWrapper(Order order, List<OrderItem> orderItems,ContentDistribution photos) {
            this.Id = order.Id;
            this.createDate = order.CreatedDate;
            this.orderNumber = order.OrderNumber;
            this.productName = orderItems[0].Product2.Brands__c+' '+ orderItems[0].Product2.Name;
            this.photos = photos.ContentDownloadUrl;
            this.shipping = order.Order_Address__c;
            this.payment = order.Description;
            Decimal unitPrice = 0;
            for (OrderItem item : orderItems) {
                unitPrice += item.UnitPrice;
            }
            this.price = unitPrice;
            this.orderItem = orderItems;

        }

    }
    @AuraEnabled
    public static List<OrderHistoryWrapper> userOrderHistory(String userID) {
        List<OrderHistory> userOrder = [
                SELECT
                        CreatedById,
                        CreatedDate,
                        DataType,
                        Field,
                        Id,
                        IsDeleted,
                        OrderId
                FROM OrderHistory
                WHERE CreatedById = :userID
        ];
        List<String> userOrderId = new List<String>();
        for (OrderHistory item : userOrder) {
            userOrderId.add(item.OrderId);
        }
        Map<Id, Order> orderList = new Map<Id, Order>([
                SELECT
                        AccountId,
                        ActivatedById,
                        Order_Address__c,
                        ActivatedDate,
                        BillingAddress,
                        BillingCity,
                        BillingCountry,
                        BillingGeocodeAccuracy,
                        BillingLatitude,
                        BillingLongitude,
                        BillingPostalCode,
                        BillingState,
                        BillingStreet,
                        BillToContactId,
                        CompanyAuthorizedById,
                        CompanyAuthorizedDate,
                        ContractId,
                        CreatedById,
                        CreatedDate,
                        CustomerAuthorizedById,
                        CustomerAuthorizedDate,
                        Description,
                        EffectiveDate,
                        EndDate,
                        Id,
                        IsDeleted,
                        IsReductionOrder,
                        LastModifiedById,
                        LastModifiedDate,
                        LastReferencedDate,
                        LastViewedDate,
                        Name,
                        OpportunityId,
                        OrderNumber,
                        OrderReferenceNumber,
                        OriginalOrderId,
                        OwnerId,
                        PoDate,
                        PoNumber,
                        Pricebook2Id,
                        QuoteId,
                        ShippingAddress,
                        ShippingCity,
                        ShippingCountry,
                        ShippingGeocodeAccuracy,
                        ShippingLatitude,
                        ShippingLongitude,
                        ShippingPostalCode,
                        ShippingState,
                        ShippingStreet,
                        ShipToContactId,
                        Status,
                        StatusCode,
                        SystemModstamp,
                        TotalAmount,
                        Type
                FROM Order
                WHERE Id IN :userOrderId
        ]);

        List<OrderHistoryWrapper> returnList = new List<OrderHistoryWrapper>();
        List<ContentDistribution> photoList = [
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
        Map<String, ContentDistribution> mapOfPhoto = new Map<String, ContentDistribution>();
        for (ContentDistribution item : photoList) {
            mapOfPhoto.put(item.ContentDocumentId,item);
        }

        for (OrderHistory item : userOrder) {
            List<OrderItem> orderItemsList = getOrderItemsList(item.OrderId);
            System.debug(orderItemsList[0].Product2.Main_Photo__c);
            System.debug(mapOfPhoto.get(orderItemsList[0].Product2.Main_Photo__c));
            OrderHistoryWrapper itemToList = new OrderHistoryWrapper(orderList.get(item.OrderId), orderItemsList,mapOfPhoto.get(orderItemsList[0].Product2.Main_Photo__c));
            returnList.add(itemToList);
        }
        System.debug(returnList);
        return returnList;
    }
    @AuraEnabled
    public static List<OrderItem> getOrderItemsList(String orderID) {
        return [
                SELECT
                        AvailableQuantity,
                        CreatedById,
                        CreatedDate,
                        Description,
                        EndDate,
                        Id,
                        IsDeleted,
                        LastModifiedById,
                        LastModifiedDate,
                        ListPrice,
                        OrderId,
                        OrderItemNumber,
                        OriginalOrderItemId,
                        PricebookEntryId,
                        Product2Id,
                        Product2.Name,
                        Product2.Brands__c,
                        Product2.Main_Photo__c,
                        Quantity,
                        QuoteLineItemId,
                        ServiceDate,
                        SystemModstamp,
                        TotalPrice,
                        UnitPrice
                FROM OrderItem
                WHERE OrderId = :orderID
        ];
    }


}
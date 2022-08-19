/**
 * Created by dominikbarchanski on 19/08/2022.
 */

@IsTest
private class dmlOrderTest {
    @TestSetup
    private static void setupTestData() {
        Pricebook2 standartPricebook = new Pricebook2(
                Id = Test.getStandardPricebookId(),
                IsActive = true);
        update standartPricebook;
        Account acc = new Account(
                Id = '0017Q00000OARrAQAX'
        );
        update acc;
        Pricebook2 pricebookins = new Pricebook2(
                Name = 'a',
                IsActive = true,
                End_date__c = Date.today(),
                Start_Date__c = Date.today()
        );
        insert pricebookins;
        Product2 prod1 = new Product2(Name = 'a', Fuel_Consumption_In_The_City__c = 1,
                Average_Fuel_Consumption__c = 1,
                Number_of_Doors__c = 1,
                Cylinder_Capacity__c = 1,
                Number_of_Places__c = 1,
                Top_Speed__c = 1
        );
        Product2 prod2 = new Product2(Name = 'a', Fuel_Consumption_In_The_City__c = 1,
                Average_Fuel_Consumption__c = 1,
                Number_of_Doors__c = 1,
                Cylinder_Capacity__c = 1,
                Number_of_Places__c = 1,
                Top_Speed__c = 1);
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
        Shopping_Cart__c itemcCart = new Shopping_Cart__c(
                Product_Id__c = 'a', User_Id__c = 'a');
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
        Order neworder = new Order(
                Order_Address__c = 'wrappedItem.shipping',
                Description = 'wrappedItem.payment',
                AccountId = acc.Id,
                Status = 'Paid',
                EffectiveDate = Date.today(),
                Pricebook2Id = standartPricebook.Id
        );
        insert neworder;
        OrderHistory orderHistory = new OrderHistory(
                OrderId = neworder.Id,
                Field = 'created'
        );
        insert orderHistory;

        Case caseTest = new Case();
        caseTest.AccountId = acc.Id;
        caseTest.Comments = 'comm';
        insert caseTest;
    }
    @IsTest
    static void createOrder() {
        Map<String, Object> itemMap = new Map<String, Object>();

        itemMap.put('prodId', [SELECT Id FROM Product2 LIMIT 1].Id);
        itemMap.put('unitPrice', 1);
        itemMap.put('shipping', 'a');
        itemMap.put('payment', 'a');
        itemMap.put('userId', [SELECT Id, CreatedById FROM OrderHistory LIMIT 1].CreatedById);
        LWC_dmlOrder.createOrder(itemMap);
        LWC_dmlOrder.userOrderHistory([SELECT Id, CreatedById FROM OrderHistory LIMIT 1].CreatedById);
    }
    @IsTest
    static void wrapperTest() {
        Order ord = new Order();
        OrderItem orderItem = new OrderItem();
        List<OrderItem> lo = new List<OrderItem>{
                orderItem
        };
        Case cs = new Case();
        ContentDistribution cd = new ContentDistribution();
        LWC_dmlOrder.OrderHistoryWrapper test = new LWC_dmlOrder.OrderHistoryWrapper(ord,lo,cd);
    }
    @IsTest
    static void wrapperTest2() {
        Order ord = new Order();
        OrderItem orderItem = new OrderItem();
        List<OrderItem> lo = new List<OrderItem>{
                orderItem
        };
        Case cs = new Case();
        ContentDistribution cd = new ContentDistribution();

        LWC_dmlOrder.OrderHistoryWrapper test1 = new LWC_dmlOrder.OrderHistoryWrapper(ord,lo,cd,cs);
    }
}
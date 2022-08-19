/**
 * Created by dominikbarchanski on 19/08/2022.
 */

@IsTest
private class testBatch {
    @TestSetup
    static void testStetum(){
        Pricebook2 standartPricebook = new Pricebook2(
                Id=Test.getStandardPricebookId(),
                IsActive=true);
        update  standartPricebook;
    }
    @IsTest
    static void testBehavior() {
        SCS_PricebookBatch scs = new SCS_PricebookBatch();
        Database.executeBatch(scs);
    }
    @IsTest
    static void testtrigger(){
        Product2 prod1 = new Product2(Name = 'a',Fuel_Consumption_In_The_City__c=1,
                Average_Fuel_Consumption__c=1,
                Number_of_Doors__c=1,
                Cylinder_Capacity__c=1,
                Number_of_Places__c=1,
                Top_Speed__c=1);
        insert prod1;
        ContentVersion content = new ContentVersion();

        content.Title = 'Title_Picture';
        content.FirstPublishLocationId = prod1.Id;
        content.PathOnClient = '/' + content.Title + '.jpg';
        Blob bodyBlob = Blob.valueOf('Test ContentVersion Body');
        content.VersionData = bodyBlob;
        insert content;
    }
    @IsTest
    static void exequtetest(){
        Test.startTest();
        String jobId = System.schedule('testBasicScheduledApex', '0 0 0 3 9 ? 2022', new schedulePromotions());
        Test.stopTest();
    }
}
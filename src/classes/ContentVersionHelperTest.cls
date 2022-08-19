/**
 * Created by dominikbarchanski on 18/08/2022.
 */

@IsTest
private class ContentVersionHelperTest {
    @TestSetup
    private static void setupTestData() {
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
        ContentVersion content = new ContentVersion();
        content.Title = 'Title_Picture';
        content.FirstPublishLocationId = prod1.Id;
        content.PathOnClient = '/' + content.Title + '.jpg';
        Blob bodyBlob = Blob.valueOf('Test ContentVersion Body');
        content.VersionData = bodyBlob;
        insert content;
    }
    @IsTest
    static void testBehavior() {
        ContentVersionHelper.insertContentDistribution(new List<ContentVersion>{new ContentVersion()});
    }
    @IsTest
    static void testBehaviorOvverriade() {
        ContentVersion item = [
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
                FROM ContentVersion LIMIT 1];
        item.Title ='test';
        update item;

    }
}
/**
 * Created by dominikbarchanski on 14/07/2022.
 */

public with sharing class ContentVersionHelper {
    public static void insertContentDistribution (List<ContentVersion> listOfContentVersion){
        List<ContentDistribution> content = new List<ContentDistribution>();
        for (ContentVersion item : listOfContentVersion) {
            ContentDistribution newitem = new ContentDistribution();
            newitem.ContentVersionId=item.Id;
            newitem.Name = item.Product__c;
            content.add(newitem);
        }
        insert content;
    }
}
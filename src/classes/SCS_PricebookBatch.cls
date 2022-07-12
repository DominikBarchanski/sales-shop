/**
 * Created by dominikbarchanski on 12/07/2022.
 */

public with sharing class SCS_PricebookBatch implements Database.Batchable<SObject>, Database.Stateful{
    public Iterable<SObject> start(Database.BatchableContext param1) {
        return [SELECT Id,IsActive,Start_Date__c,End_Date__c FROM Pricebook2];
    }
    public void execute(Database.BatchableContext param1, List<Pricebook2> scope) {
        List<Pricebook2> pricebookForUpdate = new List<Pricebook2>();
        for (Pricebook2 pricebook:scope){
            if((Date.today() >= pricebook.Start_Date__c) && (Date.today() <= pricebook.End_Date__c)){
                pricebook.IsActive = true;
                pricebookForUpdate.add(pricebook);
            } else{
                pricebook.IsActive = false;
                pricebookForUpdate.add(pricebook);
            }
        }
        update pricebookForUpdate;
    }

    public void finish(Database.BatchableContext param1) {
    }


}
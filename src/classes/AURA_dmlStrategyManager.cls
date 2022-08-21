/**
 * Created by dominikbarchanski on 15/07/2022.
 */

public with sharing class AURA_dmlStrategyManager {
//    public class ProductWithStrategy

    @AuraEnabled
    public static List<Pricebook2> showAllActivePricebook() {
        List<Pricebook2> allActive = [
                SELECT
                        CreatedById,
                        CreatedDate,
                        Description,
                        End_date__c,
                        Id,
                        IsActive,
                        IsArchived,
                        IsDeleted,
                        IsStandard,
                        LastModifiedById,
                        LastModifiedDate,
                        LastReferencedDate,
                        LastViewedDate,
                        Name,
                        Start_Date__c,
                        SystemModstamp
                FROM Pricebook2
                WHERE IsActive = TRUE
        ];
        return allActive;
    }
    @AuraEnabled
    public static void setSaleStrategy(String selectedStrategy) {
        List<Pricebook2> allActive = showAllActivePricebook();
        List<String> allPricebookId = new List<String>();
        for (Pricebook2 item : allActive) {
            allPricebookId.add(item.Id);
        }
        List<PricebookEntry> allPricebookEntries = [
                SELECT
                        CreatedById,
                        CreatedDate,
                        Id,
                        IsActive,
                        IsArchived,
                        IsDeleted,
                        LastModifiedById,
                        LastModifiedDate,
                        Name,
                        Pricebook2Id,
                        Product2Id,
                        ProductCode,
                        SystemModstamp,
                        UnitPrice,
                        UseStandardPrice
                FROM PricebookEntry
                WHERE Pricebook2Id IN :allPricebookId
        ];
        System.debug(allPricebookEntries);
        Map<String, List<PricebookEntry>> productList = new Map<String, List<PricebookEntry>>();
        for (PricebookEntry item : allPricebookEntries) {
            if (productList.containsKey(item.Product2Id)) {
                productList.get(item.Product2Id).add(item);
            } else {
                productList.put(item.Product2Id, new List<PricebookEntry>{
                        item
                });
            }
        }
        System.debug(productList);

        List<Strategy__c> allStrategy = [
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
        List<Strategy__c> listForUpdateStrategy = new List<Strategy__c>();
        switch on selectedStrategy {
            when 'standard' {
                listForUpdateStrategy = setStandard(allStrategy);
            }
            when 'lowest' {
                listForUpdateStrategy = setLowest(allStrategy, productList);
            }
            when 'highest' {
                listForUpdateStrategy = setHighest(allStrategy, productList);
            }
            when 'avg' {
                listForUpdateStrategy = setAvg(allStrategy, productList);
            }
        }
        update listForUpdateStrategy ;
//        System.debug(listForUpdateStrategy);
    }
    public static List<Strategy__c> setStandard(List<Strategy__c> allStrategy) {
        for (Strategy__c item : allStrategy) {
            item.Strategy_price__c = item.Standard_Price__c;
            item.Strategy_Name__c = 'standard';
        }
        return allStrategy;
    }
    public static List<Strategy__c> setLowest(List<Strategy__c> allStrategy, Map<String, List<PricebookEntry>> allPrice) {
        for (Strategy__c item : allStrategy) {
            if (allPrice.containsKey(item.Product2id__c)) {
                Decimal lowestPrice = allPrice.get(item.Product2id__c)[0].UnitPrice;
                for (PricebookEntry element : allPrice.get(item.Product2id__c)) {
                    if (element.UnitPrice < lowestPrice) {
                        lowestPrice = element.UnitPrice;
                    }

                }
                item.Strategy_price__c = lowestPrice;
            }else{
                item.Strategy_price__c= item.Standard_Price__c;
            }
            item.Strategy_Name__c = 'lowest';
        }
        return allStrategy;
    }
    public static List<Strategy__c> setHighest(List<Strategy__c> allStrategy, Map<String, List<PricebookEntry>> allPrice) {
        for (Strategy__c item : allStrategy) {
            if (allPrice.containsKey(item.Product2id__c)) {
                Decimal lowestPrice = allPrice.get(item.Product2id__c)[0].UnitPrice;
                for (PricebookEntry element : allPrice.get(item.Product2id__c)) {
                    if (element.UnitPrice > lowestPrice) {
                        lowestPrice = element.UnitPrice;
                    }

                }
                item.Strategy_price__c = lowestPrice;
            }else{
                item.Strategy_price__c= item.Standard_Price__c;
            }
            item.Strategy_Name__c = 'highest';
        }
        return allStrategy;

    }
    public static List<Strategy__c> setAvg(List<Strategy__c> allStrategy, Map<String, List<PricebookEntry>> allPrice) {
        for (Strategy__c item : allStrategy) {
            if (allPrice.containsKey(item.Product2id__c)) {
                Decimal sumPrice= 0 ;
                for (PricebookEntry element : allPrice.get(item.Product2id__c)) {
                    sumPrice += element.UnitPrice;
                }
                item.Strategy_price__c = sumPrice / allPrice.get(item.Product2id__c).size();
            }else{
                item.Strategy_price__c= item.Standard_Price__c;
            }
            item.Strategy_Name__c = 'avg';
        }
        return allStrategy;
    }

}
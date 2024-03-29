/* Generated by TestGen on Wed Aug 17 2022 at 1:26 PM (GMT) */
@isTest
private class AURA_dmlStrategyManager_TGN_TEST {
    @TestSetup
    private static void setupTestData() {
        Pricebook2 standartPricebook = new Pricebook2(
                Id=Test.getStandardPricebookId(),
                IsActive=true);
        update  standartPricebook;
        Product2 prod1 = new Product2(Name='a');
        insert prod1;
    }
    @isTest
    private static void showAllActivePricebook_TGN_TEST() {
        Test.startTest();
        AURA_dmlStrategyManager.showAllActivePricebook();
        Test.stopTest();
    }
    @isTest
    private static void setSaleStrategy_TGN_TEST() {
        Test.startTest();
        AURA_dmlStrategyManager.setSaleStrategy('standard');
        AURA_dmlStrategyManager.setSaleStrategy('lowest');
        AURA_dmlStrategyManager.setSaleStrategy('highest');
        AURA_dmlStrategyManager.setSaleStrategy('avg');
        Test.stopTest();
    }
    @isTest
    private static void setStandard_TGN_TEST() {
        Test.startTest();
        AURA_dmlStrategyManager.setStandard(new List<Strategy__c>{
                new Strategy__c()
        });
        AURA_dmlStrategyManager.setStandard(null);
        Test.stopTest();
    }
    @isTest
    private static void setLowest_TGN_TEST() {
        Test.startTest();

        Strategy__c strategyTest = new Strategy__c(
//                Product2id__c = '1',
                Product2id__c = [SELECT Id FROM Product2 WHERE Name='a' LIMIT 1].Id,
                Strategy_price__c=100,
                Strategy_Name__c='standard'


        );
        List<Strategy__c> listStrategies = new List<Strategy__c>();
        listStrategies.add(strategyTest);

        Map<String, List<PricebookEntry>> mapOfPirce = new Map<String, List<PricebookEntry>>();
        PricebookEntry toList = new PricebookEntry(
                UnitPrice = 90,
                Product2Id =[SELECT Id FROM Product2 WHERE Name='a' LIMIT 1].Id
//                Product2Id = '1'
        );
        mapOfPirce.put([SELECT Id FROM Product2 WHERE Name='a' LIMIT 1].Id, new List<PricebookEntry>{
                toList
        });
        System.debug(mapOfPirce);
        AURA_dmlStrategyManager.setLowest(listStrategies, mapOfPirce);
//        AURA_dmlStrategyManager.setLowest(null, null);
        Test.stopTest();
    }
    @isTest
    private static void setHighest_TGN_TEST() {
        Test.startTest();
        Strategy__c strategyTest = new Strategy__c(
                Product2id__c = [SELECT Id FROM Product2 WHERE Name='a' LIMIT 1].Id,
                Strategy_price__c=100,
                Strategy_Name__c='standard'


        );
        List<Strategy__c> listStrategies = new List<Strategy__c>();
        listStrategies.add(strategyTest);

        Map<String, List<PricebookEntry>> mapOfPirce = new Map<String, List<PricebookEntry>>();
        PricebookEntry toList = new PricebookEntry(
                UnitPrice = 90,
                Product2Id = [SELECT Id FROM Product2 WHERE Name='a' LIMIT 1].Id
        );
        mapOfPirce.put([SELECT Id FROM Product2 WHERE Name='a' LIMIT 1].Id, new List<PricebookEntry>{
                toList
        });
        System.debug(mapOfPirce);
        AURA_dmlStrategyManager.setHighest(listStrategies, mapOfPirce);

        Test.stopTest();
    }
    @isTest
    private static void setAvg_TGN_TEST() {
        Test.startTest();
        Strategy__c strategyTest = new Strategy__c(
                Product2id__c = [SELECT Id FROM Product2 WHERE Name='a' LIMIT 1].Id,
                Strategy_price__c=100,
                Strategy_Name__c='standard'


        );
        List<Strategy__c> listStrategies = new List<Strategy__c>();
        listStrategies.add(strategyTest);

        Map<String, List<PricebookEntry>> mapOfPirce = new Map<String, List<PricebookEntry>>();
        PricebookEntry toList = new PricebookEntry(
                UnitPrice = 90,
                Product2Id = [SELECT Id FROM Product2 WHERE Name='a' LIMIT 1].Id
        );
        mapOfPirce.put([SELECT Id FROM Product2 WHERE Name='a' LIMIT 1].Id, new List<PricebookEntry>{
                toList
        });
        System.debug(mapOfPirce);
        AURA_dmlStrategyManager.setAvg(listStrategies, mapOfPirce);
        Test.stopTest();
    }
    @isTest
    private static void AURA_dmlStrategyManager_TGN_TEST() {
        AURA_dmlStrategyManager obj = new AURA_dmlStrategyManager();
    }
}
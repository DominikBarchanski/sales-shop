/**
 * Created by dominikbarchanski on 11/05/2022.
 */

public with sharing class RandomDoctorController {

    public List<Doctor__c> randomDoctorList {get;set;}
    public List<Doctor__c> doc {get;set;}
    public List<Integer> randomList{get;set;}
    private Integer sizeList {get;set;}
    private Integer itemCounter {get;set;}

    public RandomDoctorController(){
        searchRandomDoc();
    }

    public void searchRandomDoc(){
        itemCounter =5;
        Integer randNumber  ;
        randomList = new List<Integer>();
        randomDoctorList = new List<Doctor__c>();
//        List<String> fields = new List<String>(Schema.getGlobalDescribe().get('Doctor__c').getDescribe().fields.getMap().keySet());
//        try{
        doc = Database.query('SELECT First_Name__c,Name,Country__c FROM Doctor__c  ');
        sizeList = doc.size()-2;
        randomList.add(Math.round(Math.random() * sizeList));
        do{
            randNumber = Math.round(Math.random() * sizeList);
            if(!randomList.contains(randNumber)){
                randomList.add(randNumber);
            }

        }while(randomList.size() < 5 );

        for (Integer item : randomList){
            randomDoctorList.add(doc[item]);
        }
//        }catch (Exception e){
//            System.debug(e);
//        }

    }

}
/**
 * Created by dominikbarchanski on 01/05/2022.
 */

public with sharing class ContractOverlapHelper {
    public static void handlerAfterInsert(List<Contract__c> createdContract) {
        NewContractId searchId = idsToQuery(createdContract);
        List<Contract__c> existContract = [
                SELECT Id, Hospital_Names__c, Hospital_Names__r.Name, Doctors__c, Doctors__r.Name, Start_Date__c, End_date__c
                FROM Contract__c
                WHERE
                        Doctors__c IN :searchId.doctorId AND
                        Hospital_Names__c IN :searchId.hospitalId
        ];


        Map<String, List<Contract__c>> existContractMap = new Map<String, List<Contract__c> >();

        for (Contract__c item : existContract) {
            if (existContractMap.containsKey((String) item.Doctors__c + (String) item.Hospital_Names__c)) {
                existContractMap.get((String) item.Doctors__c + (String) item.Hospital_Names__c).add(item);

            } else {
                existContractMap.put((String) item.Doctors__c + (String) item.Hospital_Names__c, new List<Contract__c>{
                        item
                }
                );
            }
        }

        try {
            for (Contract__c newContract : createdContract) {
                if (existContractMap.containsKey((String) newContract.Doctors__c + (String) newContract.Hospital_Names__c)) {
                    for (Contract__c item : existContractMap.get((String) newContract.Doctors__c + (String) newContract.Hospital_Names__c)) {

                        if ((newContract.Start_Date__c >= item.Start_Date__c && newContract.Start_Date__c <= item.End_date__c) ||
                                (newContract.End_date__c >= item.Start_Date__c && newContract.End_date__c <= item.End_date__c) ||
                                (newContract.Start_Date__c >= item.Start_Date__c && newContract.End_date__c <= item.End_date__c) ||
                                (newContract.Start_Date__c <= item.Start_Date__c && newContract.End_date__c >= item.End_date__c)) {
                            newContract.addError('You can\'t create contract from: ' + newContract.Start_Date__c + ' to: ' + newContract.End_date__c + ' because you have contract in this time. Please select different date.');
                        } else if ((newContract.Start_Date__c >= item.Start_Date__c && item.End_date__c == null) || (
                                newContract.End_date__c >= item.Start_Date__c && item.End_date__c == null)) {
                            newContract.addError('You have have permanent Contract from: ' + item.Start_Date__c + ' in this Hospital');
                        }
//                        else {
//                            existContractMap.get((String) newContract.Doctors__c + (String) newContract.Hospital_Names__c).add(newContract);
//                        }
                    }
                    existContractMap.get((String) newContract.Doctors__c + (String) newContract.Hospital_Names__c).add(newContract);
                } else {
                    existContractMap.put((String) newContract.Doctors__c + (String) newContract.Hospital_Names__c, new List<Contract__c>{
                            newContract
                    });
                }
            }


        } catch (Exception e) {
            ApexPages.addMessages(e);
        }


    }
    public static NewContractId idsToQuery(List<Contract__c> createdContract) {
        NewContractId dataId = new NewContractId() ;

        for (Contract__c getParameters : createdContract) {
            dataId.hospitalId.add(getParameters.Hospital_Names__c);
            dataId.doctorId.add(getParameters.Doctors__c);
        }
        return dataId;
    }

    public class NewContractId {
        public List<String> hospitalId { get; set; }
        public List<String> doctorId { get; set; }

        public NewContractId() {
            this.hospitalId = new List<String>();
            this.doctorId = new List<String>();
        }
    }

}
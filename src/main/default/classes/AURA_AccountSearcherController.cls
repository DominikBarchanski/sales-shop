/**
 * Created by dominikbarchanski on 03/06/2022.
 */

public with sharing class AURA_AccountSearcherController {
    @AuraEnabled
    public static List<Account> getAccounts (String name, String city, String phone){
        List<Account> acc ;
//        system.debug(acc);
        String soql;
        if (String.isNotBlank(name)) {
            soql = 'SELECT Id, Name, AccountNumber,BillingCity,BillingStreet,BillingCountry,Phone FROM Account WHERE Name LIKE \'%'+name+'%\' ';
            if (String.isNotBlank(city)) {
                soql += ' AND Name LIKE \'%'+city+'%\' ';

            }
            if (String.isNotBlank(phone)) {
                soql += ' AND Name LIKE \'%'+phone+'%\' ';
            }

        }
        if (String.isNotBlank(soql)) {
            acc = Database.query(soql);
        }
        return  acc;
    }
    @AuraEnabled
    public static Account deleteAccount(Account account) {
        delete account;
        return account;
    }

}
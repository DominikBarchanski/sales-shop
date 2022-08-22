public with sharing class ContactController {
    // Constructor by default
    public ContactController() { }
    @AuraEnabled(cacheable=true)
    public static List<Contact> getContacts() {
    List<Contact> lstCon = new List<Contact>();
    try {
    lstCon = [SELECT FirstName, LastName, Email FROM Contact WITH SECURITY_ENFORCED ORDER BY FirstName];
    } catch (Exception e) {
    throw new AuraHandledException('An error ocurred: ', e);
    } finally {
    // Don't send errors
    // throw new AuraHandledException('Forced error ...');
    }
    return lstCon;
    }
    //Handler Exception Class
    public class AuraHandledException extends Exception { }
    }
/**
 * Created by dominik.barchanski on 26.04.2022.
 */

public with sharing class SearchDoctorController {
    public List<Doctor__c> doctorList { get; set; }
    public String soql { get; set; }
    public String selectedDoctorId { get; set; }
    public Doctor__c doc { get; set; }
    public Boolean toggleVisibleTable { get; set; }
    public List<Doctor__c> exportList { get; set; }
    public Integer searchLimit { get; set; }
    private String searchListView ;
    private Integer counter = 0;
    private Integer listSize = 5 ;
    private Integer wasSearched ;
    public Integer pageCount ;
    public String fileId { get; set; }

    public Integer soqlCounter ;

    public SearchDoctorController() {
        doc = new Doctor__c();
        toggleVisibleTable = false;
//        exportList = new List<Doctor__c>();

    }
    public List<SelectOption> getSizeOption() {
        List<SelectOption> countryOptions = new List<SelectOption>();
        countryOptions.add(new SelectOption('5', '5'));
        countryOptions.add(new SelectOption('10', '10'));
        countryOptions.add(new SelectOption('15', '15'));

        return countryOptions;
    }
    public PageReference search() {

        if (searchLimit != null) {
            //searchListView = searchLimit;
            listSize = searchLimit ;//Integer.valueOf(searchListView);
        }
        System.debug(searchLimit);
        soql = 'SELECT First_Name__c,Name,Country__c FROM Doctor__c WHERE Name LIKE \'' + String.escapeSingleQuotes(doc.Name) + '%\' ';

        if (!(doc.First_Name__c == null)) {
            soql += ' and First_Name__c LIKE \'' + String.escapeSingleQuotes(doc.First_Name__c) + '%\' ';

        }
        if (!(doc.Country__c == null)) {
            soql += ' and Country__c LIKE \'' + String.escapeSingleQuotes(doc.Country__c) + '\' ';

        }
        exportList = Database.query(soql);
        soqlCounter = exportList.size();
        pageCount = soqlCounter / listSize;
        if (wasSearched != soqlCounter) {
            counter = 0;
        }
        wasSearched = soqlCounter;

        soql += 'LIMIT ' + listSize + ' offset ' + counter + ' ' ;
        if (soqlCounter > 0) {
            toggleVisibleTable = true ;

        } else {
            toggleVisibleTable = false;
        }

        runQuery();
        return null;

    }
    public void runQuery() {
        try {
            doctorList = Database.query(soql);

        } catch (Exception e) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Something wrong!'));
        }
    }

    public void DeleteDoctor() {
        Doctor__c removeDoctor = [SELECT Id FROM Doctor__c WHERE Id = :selectedDoctorId LIMIT 1];
        if (removeDoctor != null) {
            try {
                delete removeDoctor;
            } catch (DmlException e) {
                ApexPages.addMessages(e);
            }

        }
        runQuery();

    }

    public PageReference clear() {
        toggleVisibleTable = false;
        doc.clear();
        soqlCounter = 0;
        counter = 0;
        return null;

    }

    public Integer getPageNumber() {
        return counter / listSize + 1;
    }

    public Integer getTotalPages() {
        if (math.mod(soqlCounter, listSize) > 0) {
            return soqlCounter / listSize + 1;
        } else {
            return (soqlCounter / listSize);
        }
    }
    public PageReference Beg() {
        counter = 0;
        search();
        return null;
    }

    public PageReference Prev() {
        counter -= listSize;
        search();
        return null;
    }

    public PageReference Next() {
        counter += listSize;
        search();
        return null;
    }

    public PageReference Last() {
        counter = soqlCounter - Math.mod(soqlCounter, listSize);
        search();
        return null;
    }
    public Boolean getDisablePrevious() {
        return !(counter > 0);
    }

    public Boolean getDisableNext() {
        return !(counter + listSize < soqlCounter);
    }
    public void ChangeLimit() {
        counter = 0;

        search();
    }
    public Boolean getExportDisabled() {
        return !(soqlCounter > 0);
    }
    public String exportCSV() {
        String csv = 'First_Name,Last_Name,Country\n';
        for (Doctor__c item : exportList) {
            csv += (item.First_Name__c == null ?'': '"'+item.First_Name__c+'"' ) + ',' + (item.Name== null?'': '"'+item.Name+'"') + ',' + (item.Country__c == null ? '': '"'+item.Country__c+'"') + '\n';
        }
        ContentVersion file = new ContentVersion(
                Title = 'searchExport_' + System.today().format() + '.csv',
                VersionData = Blob.valueOf(csv),
                PathOnClient = '/searchExport_' + System.today().format() + '.csv'
        );

        insert file;

        fileId = file.Id;

        return '/sfc/servlet.shepherd/version/download/' + fileId + '?asPdf=false&operationContext=CHATTER ';

    }

    public String exportXLS() {
        String xls = 'First_Name\tLast_Name\tCountry\n';
        for (Doctor__c item : exportList) {
            xls += (item.First_Name__c == null ?'': '"'+ item.First_Name__c+'"' ) + '\t' + (item.Name== null?'':'"'+item.Name+'"') + '\t' + (item.Country__c == null ? '':'"'+item.Country__c+'"') + '\n';
        }




        ContentVersion file = new ContentVersion(
                Title = 'searchExport_' + System.today().format() + '.xls',

                VersionData = Blob.valueOf(xls),
                PathOnClient = '/searchExport_' + System.today().format() + '.xls'
        );

        insert file;
//        Continuation cont = new Continuation(10);
//        cont.continuationMethod = 'processResponse';
        fileId = file.Id;
        return '/sfc/servlet.shepherd/version/download/' + fileId + '?asPdf=false&operationContext=CHATTER ';

    }
}
/**
 * Created by dominikbarchanski on 23/06/2022.
 */

public with sharing class Web2LeadController {

    public static String form {get; set;}
    public static String info {get; set;}

    public Web2LeadController() {
        form = 'formDisplay';
        info = 'hidden';
        submitAction();
    }

    public static void submitAction(){
        System.debug(System.currentPageReference().getParameters().get('success'));
        if(Apexpages.currentPage().getParameters().get('success') == 'true'){
            form = 'hidden';
            info = 'displayInfo';
        }
    }
}
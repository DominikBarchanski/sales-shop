/**
 * Created by dominikbarchanski on 12/07/2022.
 */

global with sharing class schedulePromotions implements Schedulable{

    global void execute(SchedulableContext param1) {
        SCS_PricebookBatch scs = new SCS_PricebookBatch();
        Database.executeBatch(scs);
    }
}
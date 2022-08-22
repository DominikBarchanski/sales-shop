/**
 * Created by dominikbarchanski on 28/05/2022.
 */

global with sharing class scheduleClass  implements Schedulable{

    global void execute(SchedulableContext param1) {
        HospitalScheduleBatch b = new HospitalScheduleBatch();
        database.executeBatch(b);
    }
}
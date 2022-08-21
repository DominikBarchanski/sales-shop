/**
 * Created by dominikbarchanski on 14/07/2022.
 */

trigger ContentVersionTrigger on ContentVersion (before insert, before update, before delete, after insert, after update, after delete,after undelete ) {
    new ContentVersionTriggerHandler().run();
}
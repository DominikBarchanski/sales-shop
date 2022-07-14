/**
 * Created by dominikbarchanski on 14/07/2022.
 */

public with sharing class ContentVersionTriggerHandler extends TriggerHandler{
     public override void  afterInsert (){
        ContentVersionHelper.insertContentDistribution(Trigger.new);
    }
}
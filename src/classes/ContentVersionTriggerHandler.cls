/**
 * Created by dominikbarchanski on 14/07/2022.
 */

public with sharing class ContentVersionTriggerHandler extends TriggerHandler{
     public override void  afterUpdate (){
        ContentVersionHelper.insertContentDistribution(Trigger.new);
    }
}
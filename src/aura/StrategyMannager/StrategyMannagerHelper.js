/**
 * Created by dominikbarchanski on 15/07/2022.
 */

({
    doInit:function (cmp,event,helper) {
        let searchValue = cmp.get('v.productName')
        let action = cmp.get('c.getAllStandardProduct');
        action.setParams({productName:searchValue})
        action.setCallback(this, $A.getCallback(function (resp){
            cmp.set('v.listOfProducts',resp.getReturnValue())
        }));
        $A.enqueueAction(action);
    }});
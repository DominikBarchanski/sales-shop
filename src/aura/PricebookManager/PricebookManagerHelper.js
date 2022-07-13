/**
 * Created by dominikbarchanski on 06/07/2022.
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
    },
    handleSearch:function (cmp,event,helper) {
        var productName = cmp.find('product-name-search').get('v.value');
        let action = cmp.get('c.getAllStandardProduct');
        action.setParams({productName:productName})
        action.setCallback(this, $A.getCallback(function (resp){
            cmp.set('v.listOfProducts',resp.getReturnValue())
        }));
        $A.enqueueAction(action);
    }
});
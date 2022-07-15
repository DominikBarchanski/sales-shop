/**
 * Created by dominikbarchanski on 13/07/2022.
 */

({
    handleDoInit:function (cmp,event,helper) {
        let addedItems = cmp.get('v.currentPricebookDetails')
        var action = cmp.get('c.getAllStandardProduct');
        action.setParams({productName: ''});
        action.setCallback(this, $A.getCallback(function (resp) {
            let listToAdd = [];
            let retList = resp.getReturnValue();
            addedItems.forEach(item => {
                listToAdd.push(retList.find(itemList => itemList.id === item.Product2Id))
            })

            retList = retList.filter(val => !listToAdd.includes(val));

            cmp.set('v.PricebookDetails', retList)
        }));
        $A.enqueueAction(action);
    }
});
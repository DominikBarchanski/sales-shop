/**
 * Created by dominikbarchanski on 13/07/2022.
 */

({
    handleDoInit:function (cmp, event, helper) {
        var pricebookId = cmp.get('v.pricebookId');
        var action = cmp.get('c.getSpecificPricebook');
        action.setParams({pricebookId: pricebookId});
        action.setCallback(this, $A.getCallback(function (resp) {
            var records = resp.getReturnValue();
            var mergList = records.listOfProducts
            var retList = cmp.get('v.listOfStandardPrice');
            mergList.forEach(item => {
                var obj = retList.find(itemList => itemList.id === item.Product2Id)
                console.log(obj)
                item.standard = obj.price;
                // records.standard = (retList.find(itemList => itemList.id ===item.id))
            })

            for (var i = 0; i < records.listOfProducts.length; i++) {
                console.log(records[i]);
                if (records.listOfProducts[i].IsActive === true) {
                    records.listOfProducts[i].displayIconName = 'utility:check';

                } else if (records.listOfProducts[i].IsActive === false) {
                    records.listOfProducts[i].displayIconName = 'utility:close';
                } else {
                    records.listOfProducts[i].displayIconName = 'utility:warning';
                }

            }
            cmp.set('v.PricebookDetails', resp.getReturnValue())
        }));
        $A.enqueueAction(action);
    },handledDeleteProduct : function (cmp,event,helper,listOfIdToDelete) {
        var action = cmp.get('c.deletePricebookEntryItems')
        action.setParams({listOfItems: listOfIdToDelete})
        action.setCallback(this, $A.getCallback(function (resp) {
            $A.enqueueAction(cmp.get('c.init'))
        }));
        $A.enqueueAction(action);

    }
});
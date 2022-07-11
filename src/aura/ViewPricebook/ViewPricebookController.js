/**
 * Created by dominikbarchanski on 08/07/2022.
 */

({
    init: function (cmp, event) {
        cmp.set('v.columns', [
            // { label: 'Id', fieldName: 'id', type: 'text' },
            {label: 'Name', fieldName: 'Name', type: 'text'},
            {label: 'Standard Price', fieldName: 'standard', type: 'currency'},
            {label: 'New Price', fieldName: 'UnitPrice', type: 'currency'},
            {
                label: 'is Active', fieldName: '', cellAttributes: {
                    class: {fieldName: 'IsActive'},
                    iconName: {
                        fieldName: 'displayIconName',
                    }
                }
            }

        ]);

        var pricebookId = cmp.get('v.pricebookId');
        var action = cmp.get('c.getSpecificPricebook');
        action.setParams({pricebookId: pricebookId});
        console.log(pricebookId);
        action.setCallback(this, $A.getCallback(function (resp) {
            var records = resp.getReturnValue();
            var mergList = records.listOfProducts
            var retList = cmp.get('v.listOfStandardPrice');
            mergList.forEach(item=>{
                var obj = retList.find(itemList => itemList.id ===item.Product2Id)
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
            console.log(cmp.get('v.PricebookDetails'));
        }));
        $A.enqueueAction(action);



    },
    handleBackToMain: function (cmp, event) {
        console.log('działa');
        var parent = cmp.get("v.parent");
        parent.typeOfAction('back', '');
    }, handleEditPage: function (cmp, event) {
        console.log('działa');
        var parent = cmp.get("v.parent");
        var pricebookId = cmp.get('v.pricebookId');
        parent.typeOfAction('edit', pricebookId);
    }
});
/**
 * Created by dominikbarchanski on 10/07/2022.
 */

({init: function (cmp, event) {
        cmp.set('v.columns', [
            // { label: 'Id', fieldName: 'id', type: 'text' },
            {label: 'Name', fieldName: 'name', type: 'text'},
            {label: 'Standard Price', fieldName: 'price', type: 'currency'},
            {label: 'New Price', fieldName: 'newPrice', type: 'currency'},


        ]);
        let addedItems = cmp.get('v.currentPricebookDetails')
        var action = cmp.get('c.getAllStandardProduct');
        action.setParams({productName:''});
        action.setCallback(this, $A.getCallback(function (resp) {
            let listToAdd = [];
            let retList = resp.getReturnValue();
            addedItems.forEach(item=>{
                listToAdd.push(retList.find(itemList => itemList.id ===item.Product2Id))
            })

            retList = retList.filter(val => !listToAdd.includes(val));

            cmp.set('v.PricebookDetails', retList)
        }));
        $A.enqueueAction(action);
        console.log(cmp.get('v.PricebookDetails'));
    },handleRowAction:function (cmp,event){
        var selectedRows = event.getParam('selectedRows')
        var toDiscountMap = new Map();
        for (const selectedRow of selectedRows) {
            toDiscountMap.set(selectedRow.id, selectedRow)
        }
        for (const allItemSelectedElement of selectedRows) {
            allItemSelectedElement.setDiscount = toDiscountMap.has(allItemSelectedElement.id);
        }
        cmp.set('v.listOfProductsSelected',selectedRows);

    },handleAdd:function (cmp,event){

        var pushToParent = cmp.get("v.parent");
        var selectedRows = cmp.get('v.listOfProductsSelected');
        console.log(selectedRows)
        pushToParent.addProducts(selectedRows);
        pushToParent.closeModalAllPricebook();
    }, handleClose: function (cmp, event) {
        var pushToParent = cmp.get("v.parent");
        pushToParent.closeModalAllPricebook();
    },setNewPrice: function (cmp, event) {
        function evaluate(param1, param2, operator) {
            return eval(param1 + operator + param2)
        }
        var newPriceList = cmp.get('v.listOfProductsSelected');
        var discountType = cmp.find('discount-type').get('v.value');
        var discountValue = parseFloat(cmp.find('discount-value').get('v.value'));
        var discountIncrease = cmp.get('v.discount');
        for (const newPriceListElement of newPriceList) {
            if (discountType === 'percent' && newPriceListElement.setDiscount) {
                newPriceListElement.newPrice = discountIncrease ? evaluate(newPriceListElement.price, (1 - discountValue / 100).toString(), "*") : evaluate(newPriceListElement.price, (1 + discountValue / 100).toString(), "*");
            } else if (discountType === 'currency' && newPriceListElement.setDiscount) {
                newPriceListElement.newPrice = discountIncrease ? evaluate(newPriceListElement.price, discountValue, "-") : evaluate(newPriceListElement.price, discountValue, "+");
            }
        }
        console.log(newPriceList);
        cmp.set('v.PricebookDetails', newPriceList)
        console.log(cmp.get('v.listOfProduct'));
    },checkDiscountValue: function (cmp, event) {
        var currentValue = cmp.find('discount-value').get('v.value')
        var type = cmp.find('discount-type').get('v.value')
        if (type === 'percent') {
            if (parseInt(currentValue) > 100) {
                cmp.find('discount-value').set('v.value', 100)
            }
        }
    }

});
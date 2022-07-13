/**
 * Created by dominikbarchanski on 07/07/2022.
 */

({
    init: function (cmp, event, helper) {
        cmp.set('v.discount', true);
        var tableActions = [
            {label: 'Show details', name: 'show_details'},
            {label: 'Edit', name: 'edit'},
            {label: 'Delete', name: 'delete'}
        ];

        cmp.set('v.columns', [
            {label: 'Name', fieldName: 'name', type: 'text'},
            {label: 'Current price', fieldName: 'price', type: 'currency'},
            {label: 'New price', fieldName: 'newPrice', type: 'currency'},
            {type: 'action', typeAttributes: {rowActions: tableActions}}
        ]);

    }, handleRowAction: function (cmp, event) {
        var allItemSelected = cmp.get('v.listOfProduct');
        var selectedRows = event.getParam('selectedRows')
        var toDiscountMap = new Map();
        for (const selectedRow of selectedRows) {
            toDiscountMap.set(selectedRow.id, selectedRow)
        }
        for (const allItemSelectedElement of allItemSelected) {
            allItemSelectedElement.setDiscount = toDiscountMap.has(allItemSelectedElement.id);
        }
        cmp.set('v.listOfProduct', allItemSelected);

    },
    handleCloseModal: function (cmp, event) {
        var cmpClose = false;
        var pushToParent = cmp.get("v.parent");
        pushToParent.closeModalAddPricebook(cmpClose);
    }, setNewPrice: function (cmp, event) {
        function evaluate(param1, param2, operator) {
            return eval(param1 + operator + param2)
        }

        console.log(evaluate("2", "3", "/"))
        var newPriceList = cmp.get('v.listOfProduct');
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
        cmp.set('v.listOfProduct', newPriceList)
    }, handleCreatePricebook: function (cmp, event,helper) {
        var objectToSend = {
            pricebookName: cmp.find('pricebook-name').get('v.value'),
            pricebookDescription: cmp.find('pricebook-description').get('v.value'),
            pricebookIsActive: cmp.find('pricebook-active').get('v.value'),
            productList: cmp.get('v.listOfProduct'),
            startDate: cmp.find('start-date').get('v.value'),
            endDate: cmp.find('end-date').get('v.value')
        }

        helper.handleCreatePricebook(cmp,event,helper,objectToSend);
    }, checkDiscountValue: function (cmp, event) {
        var currentValue = cmp.find('discount-value').get('v.value')
        var type = cmp.find('discount-type').get('v.value')
        if (type === 'percent') {
            if (parseInt(currentValue) > 100) {
                cmp.find('discount-value').set('v.value', 100)
            }
        }
    }
});
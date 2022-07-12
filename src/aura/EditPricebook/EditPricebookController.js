/**
 * Created by dominikbarchanski on 10/07/2022.
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
        console.log('co tu jest' + pricebookId);
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
        console.log(cmp.get('v.PricebookDetails'));
    },
    handleBackToMain: function (cmp, event) {
        console.log('działa');
        var parent = cmp.get("v.parent");
        parent.typeOfAction('back', '');
    }, handleViewPage: function (cmp, event) {
        console.log('działa');
        var pricebookId = cmp.get('v.pricebookId');
        var parent = cmp.get("v.parent");
        parent.typeOfAction('view', pricebookId);
    }, addProductToPricebook: function (cmp, event) {
        cmp.set('v.displayAdd', true);
    }, handleAddProduct: function (cmp, event) {
        var listWithAllItems = cmp.get('v.PricebookDetails');
        var params = event.getParam('arguments');
        console.log(listWithAllItems)
        if (params) {
            for (const addedProductElement of params.AddedProduct) {
                var obj = {
                    Id: '',
                    IsActive: '',
                    Name: addedProductElement.name,
                    Pricebook2Id: "",
                    Product2Id: addedProductElement.id,
                    UnitPrice: addedProductElement.newPrice,
                    newPrice: addedProductElement.newPrice,
                    UseStandardPrice: '',
                    displayIconName: '',
                    toInsert: true
                }
                listWithAllItems.listOfProducts.push(obj)
            }

        }
        cmp.set('v.PricebookDetails', listWithAllItems)
        console.log(listWithAllItems);
    }, saveAfterEdit: function (cmp, event) {

        var action = cmp.get('c.updatePricebook');
        console.log('działa przed desc?')
        var updateObject = cmp.get('v.PricebookDetails');
        if (updateObject.Description === null) {
            updateObject.Description = ''
        }
        console.log('działa ?')
        action.setParams({dataFromJS: updateObject});
        action.setCallback(this, $A.getCallback(function (resp) {
            var status = resp.getReturnValue();
            console.log(status)
            console.log('działą ?')
            if (status == 'SUCCESS') {
                console.log('działą  w succes?')
                $A.enqueueAction(cmp.get('c.init'))

            }
        }));
        $A.enqueueAction(action);
    }, handleRowSelect: function (cmp, event) {
        var selectedRows = event.getParam('selectedRows')
        var toDiscountMap = new Map();
        for (const selectedRow of selectedRows) {
            toDiscountMap.set(selectedRow.id, selectedRow)
        }
        for (const allItemSelectedElement of selectedRows) {
            allItemSelectedElement.setDiscount = toDiscountMap.has(allItemSelectedElement.id);
        }
        cmp.set('v.rowsToDelete', selectedRows);
    }, deleteProductFromPricebook: function (cmp, event) {
        var result = confirm('Wan\'t delete this records?')
        if (result) {
            var listOfIdToDelete = [];
            for (const item of cmp.get('v.rowsToDelete')) {
                listOfIdToDelete.push(item.Id)
            }
            var action = cmp.get('c.deletePricebookEntryItems')
            action.setParams({listOfItems: listOfIdToDelete})
            action.setCallback(this, $A.getCallback(function (resp) {
                $A.enqueueAction(cmp.get('c.init'))
            }));
            $A.enqueueAction(action);
            console.log(listOfIdToDelete);
        }
    }, displayEditPrice: function (cmp, event) {
        cmp.set('v.isEditPrice', true);
    }, setNewPrice: function (cmp, event) {
        var newPriceList = cmp.get('v.rowsToDelete');
        if (newPriceList.length > 0) {


            function evaluate(param1, param2, operator) {
                return eval(param1 + operator + param2)
            }

            var discountType = cmp.find('discount-type').get('v.value');
            var discountValue = parseFloat(cmp.find('discount-value').get('v.value'));
            var discountIncrease = cmp.get('v.discount');
            for (const newPriceListElement of newPriceList) {
                if (discountType === 'percent' && newPriceListElement.setDiscount) {
                    newPriceListElement.UnitPrice = discountIncrease ? evaluate(newPriceListElement.standard, (1 - discountValue / 100).toString(), "*") : evaluate(newPriceListElement.standard, (1 + discountValue / 100).toString(), "*");
                } else if (discountType === 'currency' && newPriceListElement.setDiscount) {
                    newPriceListElement.UnitPrice = discountIncrease ? evaluate(newPriceListElement.standard, discountValue, "-") : evaluate(newPriceListElement.standard, discountValue, "+");
                }
            }
            var listToUpdate = cmp.get('v.PricebookDetails.listOfProducts');
            listToUpdate.forEach(item => {
                    var object = newPriceList.find(updatedItem => updatedItem.Id === item.Id);
                    if (object !== undefined) {
                        item.UnitPrice = object.UnitPrice
                    }
                }
            )
            console.log(listToUpdate)
            cmp.set('v.PricebookDetails.listOfProducts', listToUpdate)
        }
    }
    , handleClose: function (cmp, event) {
        cmp.set('v.displayAdd', false);
    }
});
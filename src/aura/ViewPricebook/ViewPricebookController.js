/**
 * Created by dominikbarchanski on 08/07/2022.
 */

({
    init: function (cmp, event,helper) {
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
        console.log(cmp.get('v.PricebookDetails'));
        cmp.set('v.isActive', (cmp.get('v.PricebookDetails.isActive') ==='true'))
       helper.handledDoInit(cmp,event,helper);




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
/**
 * Created by dominikbarchanski on 06/07/2022.
 */

({
    init: function (cmp, event, helper) {
        var tableActions = [
            {label: 'Show details', name: 'show_details'},
            {label: 'Edit', name: 'edit'},
            {label: 'Delete', name: 'delete'}
        ];

        cmp.set('v.columns', [
            {label: 'Brand', fieldName: 'brand', type: 'text'},
            {label: 'Name', fieldName: 'name', type: 'text'},
            {label: 'Standard Price', fieldName: 'price', type: 'currency'},
            {label: 'Price After Strategy', fieldName: 'strategyPrice', type: 'currency'},
            {label: 'Type', fieldName: 'type', type: 'text'},
            {label: 'Horce power', fieldName: 'hp', type: 'number'},
            // { type: 'action', typeAttributes: { rowActions: tableActions } }
        ]);

        helper.doInit(cmp, event, helper)
    }, handleSearch: function (cmp, event, helper) {
        var isEnterKey = evt.keyCode === 13;
        if (isEnterKey) {
            helper.handleSearch(cmp, event, helper)
        }
    },
    handleRowAction: function (cmp, event) {
        var selectedRows = event.getParam('selectedRows')
        cmp.set('v.listOfProductsSelected', selectedRows);
    },
    handleCloseNodalAllPricebook: function (cmp, event) {
        var params = event.getParam('arguments');
        if (params) {
            cmp.set("v.isPricebookList", params.childCloseModal)
        }
    }, handleCloseNodalAddPricebook: function (cmp, event) {
        var params = event.getParam('arguments');
        if (params) {
            cmp.set("v.isNewPricebook", params.childCloseModalAdd)
        }
    },handleCloseModalStrategy: function (cmp, event) {
        var params = event.getParam('arguments');
        if (params) {
            cmp.set("v.isDisplayStrategy", params.childCloseModalStrategy)
            $A.enqueueAction(cmp.get('c.init'))
        }
    },
    showPricebookModal: function (cmp, event) {
        cmp.set("v.isPricebookList", true);
    },showStrategyModal:function (cmp,event) {
        cmp.set('v.isDisplayStrategy',true);
    },
    showModalNewPricebook: function (cmp, event) {
        var selectedSize = cmp.get('v.listOfProductsSelected')
        var confirmCreate = selectedSize.length === 0 ? confirm('No products have been selected. Do you want to continue?') : true;
        if (confirmCreate) {
            cmp.set('v.isNewPricebook', true)
        }
    }, handleTypeOfAction: function (cmp, event) {
        var params = event.getParam('arguments');
        if (params) {
            if (params.actionType === 'view') {
                cmp.set('v.pricebookToChild', params.pricebookId);
                cmp.set("v.isDisplayStandardProduct", false);
                cmp.set("v.isDisplayViewPricebook", true);
                cmp.set("v.isDisplayEditPricebook", false);


            } else if (params.actionType === 'edit') {
                cmp.set('v.pricebookToChild', params.pricebookId)
                cmp.set("v.isDisplayStandardProduct", false);
                cmp.set("v.isDisplayViewPricebook", false);
                cmp.set("v.isDisplayEditPricebook", true);

            } else if (params.actionType === 'back') {
                cmp.set("v.isDisplayStandardProduct", true);
                cmp.set("v.isDisplayViewPricebook", false);
                cmp.set("v.isDisplayEditPricebook", false);
            }
        }
    }

});
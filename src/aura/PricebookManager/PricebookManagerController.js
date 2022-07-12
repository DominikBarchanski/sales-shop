/**
 * Created by dominikbarchanski on 06/07/2022.
 */

({
    init: function (cmp,event,helper){
        var tableActions = [
            { label: 'Show details', name: 'show_details' },
            { label: 'Edit', name: 'edit' },
            { label: 'Delete', name: 'delete' }
        ];

        cmp.set('v.columns', [
            { label: 'Brand', fieldName: 'brand', type: 'text' },
            { label: 'Name', fieldName: 'name', type: 'text' },
            { label: 'Standard Price', fieldName: 'price', type: 'currency' },
            { label: 'Type', fieldName: 'type', type: 'text' },
            { label: 'Horce power', fieldName: 'hp', type: 'number' },
            // { type: 'action', typeAttributes: { rowActions: tableActions } }
        ]);
        let searchValue = cmp.get('v.productName')
        console.log(searchValue)
        let action = cmp.get('c.getAllStandardProduct');
        action.setParams({productName:searchValue})
        action.setCallback(this, $A.getCallback(function (resp){
            cmp.set('v.listOfProducts',resp.getReturnValue())
        }));
        $A.enqueueAction(action);
    },handleSearch :function (cmp,evt,helper){
        var isEnterKey = evt.keyCode === 13;
        if (isEnterKey) {
            var productName = cmp.find('product-name-search').get('v.value');
            let action = cmp.get('c.getAllStandardProduct');
            action.setParams({productName:productName})
            action.setCallback(this, $A.getCallback(function (resp){
                cmp.set('v.listOfProducts',resp.getReturnValue())
            }));
            $A.enqueueAction(action);
        }
    },
    handleRowAction:function (cmp,event){
        var selectedRows = event.getParam('selectedRows')
        console.log(selectedRows);
        cmp.set('v.listOfProductsSelected',selectedRows);

    },
    handleCloseNodalAllPricebook : function (cmp,event){
        var params =event.getParam('arguments');
        if(params){
            cmp.set("v.isPricebookList",params.childCloseModal)
        }
    },handleCloseNodalAddPricebook : function (cmp,event){
        var params =event.getParam('arguments');
        if(params){
            cmp.set("v.isNewPricebook",params.childCloseModalAdd)
        }
    },
    showPricebookModal:function (cmp,event){
       cmp.set("v.isPricebookList", true);
    },
    showModalNewPricebook :function (cmp,event){
        cmp.set('v.isNewPricebook',true)
    },handleTypeOfAction:function (cmp,event){
        var params =event.getParam('arguments');
        if (params){
            console.log(params.actionType)
            if(params.actionType ==='view'){
                console.log(params.pricebookId)
                cmp.set('v.pricebookToChild',params.pricebookId);
                cmp.set( "v.isDisplayStandardProduct" , false);
                cmp.set( "v.isDisplayViewPricebook" , true);
                cmp.set("v.isDisplayEditPricebook" ,false);


            }else if(params.actionType ==='edit'){
                cmp.set('v.pricebookToChild',params.pricebookId)
                cmp.set( "v.isDisplayStandardProduct" , false);
                cmp.set( "v.isDisplayViewPricebook" , false);
                cmp.set("v.isDisplayEditPricebook" ,true);

            }else if(params.actionType ==='back'){
                cmp.set( "v.isDisplayStandardProduct" , true);
                cmp.set( "v.isDisplayViewPricebook" , false);
                cmp.set("v.isDisplayEditPricebook" ,false);
            }
        }
    }

});
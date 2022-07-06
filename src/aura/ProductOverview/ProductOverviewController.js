/**
 * Created by dominikbarchanski on 04/07/2022.
 */

({
    doInit: function (component, event, helper) {
        var action = component.get("c.getBrands");
        var inputIndustry = component.find("InputAccountIndustry");
        var opts = [];
        action.setCallback(this, function (a) {
            opts.push({
                class: "optionClass",
                label: "--- None ---",
                value: ""
            });
            for (var i = 0; i < a.getReturnValue().length; i++) {
                opts.push({"class": "optionClass", label: a.getReturnValue()[i], value: a.getReturnValue()[i]});
            }
            inputIndustry.set("v.options", opts);

        });
        $A.enqueueAction(action);
    },
    onPicklistChange: function (component, event, helper) {
        var selectedIndustry = component.find("InputAccountIndustry");
        var brandSwap =  component.get('v.product');
        brandSwap.brand = selectedIndustry.get("v.value");
        component.set('v.product', brandSwap );

    },
    handleClick: function (cmp, event) {
        var action = cmp.get("c.insertProduct");
        var productValue = cmp.get("v.product");
        action.setParams({jsObject: productValue})
        action.setCallback(this, $A.getCallback(function (response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "title": "Success!",
                    "type": 'success',
                    "message": "The record has been inserted successfully."
                });

                toastEvent.fire();
                var parentComponent = cmp.get("v.parent");
                parentComponent.closeAdd();
            } else if (state === "ERROR") {
                var errors = response.getError();
                console.error(errors);
            }
        }));

        $A.enqueueAction(action);

    },
    handleClickDelete: function (cmp, event) {
        var itemToDeleteId = event.target.dataset.value;
        var clickedIndex = event.target.dataset.index;
        var actionDelete = cmp.get('c.deleteDocuments')
        actionDelete.setParams({docId: itemToDeleteId})
        actionDelete.setCallback(this, $A.getCallback(function (response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var tmp = cmp.get("v.product")
                tmp.photoList.splice(clickedIndex, 1);
                cmp.set("v.product", tmp);
            } else if (state === "ERROR") {
                var errors = response.getError();
                console.error(errors);
            }
        }));
        $A.enqueueAction(actionDelete);
    }, handleClose : function (component,event){
        var objProd = component.get('v.product')
        var listOfPhoto = JSON.stringify(objProd.photoList);

        var action = component.get('c.deleteAfterCancel');
        action.setParams({photoList:listOfPhoto});
        action.setCallback(this, $A.getCallback(function (response){
            cmp.set("v.allAddedFile", [])
        }));
        $A.enqueueAction(action);
        var parentComponent = component.get("v.parent");
        parentComponent.closeAdd();
    },handleSaveAndNew :function (cmp,event){
        var action = cmp.get("c.insertProduct");
        var productValue = cmp.get("v.product");
        action.setParams({jsObject: productValue})
        action.setCallback(this, $A.getCallback(function (response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "title": "Success!",
                    "type": 'success',
                    "message": "The record has been inserted successfully."
                });
                toastEvent.fire();
                window.location.reload()
            } else if (state === "ERROR") {
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "title": "Error!",
                    "type": 'error',
                    "message": "Something went wrong!"
                });
            }
        }));

        $A.enqueueAction(action);
    }
});
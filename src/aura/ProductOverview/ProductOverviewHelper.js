/**
 * Created by dominikbarchanski on 12/07/2022.
 */

({
    handleDoInit : function (component,event,helper){
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
    },handleSave:function (cmp,event,helper){
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

    },handleSaveAndNew:function (cmp,event,helper){
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
    }, handleMainPhoto:function (cmp,event,helper){
        var itemToDeleteId = event.target.closest("[data-value]").dataset.value;
        var clickedIndex = event.target.closest("[data-index]").dataset.index;
        var objectDetails = cmp.get('v.product');

        objectDetails.mainPhoto = itemToDeleteId;
        console.log(itemToDeleteId)
        cmp.set('v.product',objectDetails);

    }
    ,
    handleDelete:function (cmp,event,helper){
        var itemToDeleteId = event.target.closest("[data-value]").dataset.value;
        var clickedIndex = event.target.closest("[data-index]").dataset.index;
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
    },handleClose:function (component,event,helper){
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
    }
});
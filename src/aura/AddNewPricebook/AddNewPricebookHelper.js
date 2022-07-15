/**
 * Created by dominikbarchanski on 13/07/2022.
 */

({
    handleCreatePricebook : function (cmp, event, helper,objectToSend) {
        var action = cmp.get('c.createNewPricebook');
        action.setParams({dataFromJS: objectToSend});
        action.setCallback(this, $A.getCallback(function (resp) {
            var respValue = resp.getReturnValue();
            var toastEvent = $A.get("e.force:showToast");
            var cmpClose = false;
            var pushToParent = cmp.get("v.parent");
            if (respValue === 'SUCCESS') {
                toastEvent.setParams({
                    "title": "Success!",
                    "type": "success",
                    "message": "The record has been updated successfully."
                });
                toastEvent.fire();

                pushToParent.closeModalAddPricebook(cmpClose);
            } else {
                toastEvent.setParams({
                    "title": "Error!",
                    "type": "error",
                    "message": "Something goes wrong."
                });
                toastEvent.fire();
                pushToParent.closeModalAddPricebook(cmpClose);
            }
        }));
        $A.enqueueAction(action);
    }
});
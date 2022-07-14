/**
 * Created by dominikbarchanski on 12/07/2022.
 */

({
    handleClose: function (component, event, helper) {

        var listOfPhoto = JSON.stringify(component.get('v.allAddedFile'));
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
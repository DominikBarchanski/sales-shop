/**
 * Created by dominikbarchanski on 04/07/2022.
 */

({
    doInit: function (component, event, helper) {
        helper.handleCreateList(component, event, helper);
    },
    onPicklistChange: function (component, event, helper) {
        //get the value of select option
        var selectedIndustry = component.find("InputAccountIndustry");
        component.set('v.carBrand', selectedIndustry.get("v.value"))
    }, callParentMethod: function (component, event, helper) {
        helper.handleSendDataToParent(component, event, helper)
    }, handleClose: function (component, event, helper) {
        helper.handleClose(component, event, helper)
    }
});
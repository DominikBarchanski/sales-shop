/**
 * Created by dominikbarchanski on 04/07/2022.
 */

({
    doInit: function (component, event, helper) {
       helper.handleDoInit(component,event,helper);

    },
    onPicklistChange: function (component, event, helper) {
        var selectedIndustry = component.find("InputAccountIndustry");
        var brandSwap =  component.get('v.product');
        brandSwap.brand = selectedIndustry.get("v.value");
        component.set('v.product', brandSwap );

    },
    handleClick: function (cmp, event,helper) {
        helper.handleSave(cmp,event,helper)
    },handleSetMainPhoto:function (cmp,event,helper){
        helper.handleMainPhoto(cmp,event,helper);
    },
    handleClickDelete: function (cmp, event,helper) {
        helper.handleDelete(cmp,event)
    }, handleClose : function (component,event,helper){
        helper.handleClose(component,event,helper)
    },handleSaveAndNew :function (cmp,event,helper){
       helper.handleSaveAndNew(cmp,event,helper)
    }
});
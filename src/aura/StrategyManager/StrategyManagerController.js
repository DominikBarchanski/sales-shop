/**
 * Created by dominikbarchanski on 17/07/2022.
 */

({
    init: function (cmp, event, helper) {

        const action = cmp.get('c.showAllActivePricebook');
        action.setCallback(this, $A.getCallback(function (resp) {
            cmp.set('v.activePricebook', resp.getReturnValue())
            console.log(resp.getReturnValue());
        }));
        $A.enqueueAction(action);

        cmp.set('v.columns', [
            {label: 'Name', fieldName: 'Name', type: 'text'},
            {label: 'Start Date', fieldName: 'Start_Date__c', type: 'text'},
            {label: 'End Date', fieldName: 'End_date__c', type: 'text'}

        ]);
        var strategyType = cmp.get('v.products')[0].strategyType;

        cmp.set('v.strategyType', strategyType);

        helper.handleStrategyChange(cmp, event, helper);
    }, handleSelectStrategy: function (cmp, event, helper) {
        helper.handleStrategyChange(cmp, event, helper)
    },handleSaveStrategy:function (cmp, event, helper) {
        helper.handleSaveStrategy(cmp,event,helper)
    }, handleCloseModal: function (cmp, event) {

        var cmpClose = false;
        var pushToParent = cmp.get("v.parent");
        pushToParent.closeModalStrategy(cmpClose);
    }
});
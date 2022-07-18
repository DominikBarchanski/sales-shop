/**
 * Created by dominikbarchanski on 18/07/2022.
 */

({
    handleStrategyChange:function (cmp,event,helper) {
        const strategyType = cmp.get('v.strategyType');
        switch (strategyType) {
            case 'standard':
                cmp.set('v.isStandard',true)
                cmp.set('v.isLowest',false)
                cmp.set('v.isHighest',false)
                cmp.set('v.isAvg',false)
                break
            case 'lowest':
                cmp.set('v.isStandard',false)
                cmp.set('v.isLowest',true)
                cmp.set('v.isHighest',false)
                cmp.set('v.isAvg',false)
                break
            case 'highest':
                cmp.set('v.isStandard',false)
                cmp.set('v.isLowest',false)
                cmp.set('v.isHighest',true)
                cmp.set('v.isAvg',false)
                break
            case 'avg':
                cmp.set('v.isStandard',false)
                cmp.set('v.isLowest',false)
                cmp.set('v.isHighest',false)
                cmp.set('v.isAvg',true)
                break
        }
    },handleSaveStrategy:function (cmp,event,helper) {
        var strategySelected = cmp.find('selected-strategy').get('v.value');
        const action = cmp.get('c.setSaleStrategy');

        if(strategySelected !== '') {
            action.setParams({selectedStrategy: strategySelected})
            action.setCallback(this, $A.getCallback(function (resp) {
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "title": "Success!",
                    "type": 'success',
                    "message": "The strategy has been successfully updated."
                });
                toastEvent.fire();

            }));
            $A.enqueueAction(action);
        }else{
            alert('Set strategy before save')
        }
    }
});
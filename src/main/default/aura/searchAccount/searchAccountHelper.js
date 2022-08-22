/**
 * Created by dominikbarchanski on 03/06/2022.
 */


({
    getData : function(cmp) {
        var action = cmp.get('c.getAccounts');
        action.setCallback(this, $A.getCallback(function (response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                cmp.set('v.account', response.getReturnValue());
            } else if (state === "ERROR") {
                var errors = response.getError();
                console.error(errors);
            }
        }));
        $A.enqueueAction(action);
    },
    searchHelper : function (cmp,event,helper){
        var action = cmp.get("c.getAccounts");

        action.setParams({
            name: cmp.find('enter-account-name').get('v.value'),
            city: cmp.find('enter-city-name').get('v.value'),
            phone: cmp.find('enter-phone-number').get('v.value')
        });
        action.setCallback(this, function (a) {
            // var arr_from_json = JSON.parse( a.getReturnValue() );
            cmp.set("v.account",a.getReturnValue());
            // console.log(arr_from_json.results);
        })
        console.log(action);
        $A.enqueueAction(action);

    }

})
/**
 * Created by dominikbarchanski on 07/06/2022.
 */

({deleteRow: function(cmp, row) {
        console.log('działaaaa')
        var action = cmp.get("c.deleteAccount");
        action.setParams({
            "account":row
        });
        console.log('działa');
        console.log(action);
        action.setCallback(this, function(response) {
            var state = response.getState();
            console.log(response);
            if (state === "SUCCESS") {

                cmp.set('v.rowObject', []);

            }
            else if (state === "ERROR") {
                // handle error
            }

        });
        $A.enqueueAction(action);
    }});
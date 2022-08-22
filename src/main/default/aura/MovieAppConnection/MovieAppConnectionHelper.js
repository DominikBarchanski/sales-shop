/**
 * Created by dominikbarchanski on 31/05/2022.
 */

({
    callServer: function (cmp, helper) {
        var action = cmp.get("c.getRecords");

        action.setParams({
            movieName: cmp.find('enter-search-film-name').get('v.value')
        });
        action.setCallback(this, function (a) {

            var arr_from_json = JSON.parse( a.getReturnValue() );
            cmp.set("v.myAttribute",arr_from_json.results);
            console.log(arr_from_json.results);
        })
        cmp.set("v.myAttribute",'Demo');
        console.log(action);
        $A.enqueueAction(action);
        console.log('działa');
    }
});
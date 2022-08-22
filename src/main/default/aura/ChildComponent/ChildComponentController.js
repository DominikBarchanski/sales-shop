/**
 * Created by dominikbarchanski on 31/05/2022.
 */

({
    getMessage : function(component, event) {
        //get method paramaters
        let params = event.getParam('arguments');
        if (params) {
            let param1 = params.childGreetingParam;
            let param2 = params.childPersonNameParam;
            alert(param1 + " " + param2);
        }
    }
})
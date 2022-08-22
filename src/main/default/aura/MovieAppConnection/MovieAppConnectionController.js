/**
 * Created by dominikbarchanski on 31/05/2022.
 */

({
    handleKeyDown: function (cmp, evt, helper) {
        let isEnterKey = evt.keyCode === 13;

        if (isEnterKey) {
            console.log('tychuju');
            helper.callServer(cmp,true);
            // let test = ;
            console.log(test);
        }
    }
});
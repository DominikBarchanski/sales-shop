/**
 * Created by dominikbarchanski on 11/07/2022.
 */

({
    deleteRecord : function (cmp,row){
        var actionDelete = cmp.get('c.deletePricebook');
        console.log(row.id);
        actionDelete.setParams({pricebookId:row.id});
        actionDelete.setCallback(this, $A.getCallback(function (resp) {
            $A.enqueueAction(cmp.get('c.init'));
        }))
        $A.enqueueAction(actionDelete);
    }
});
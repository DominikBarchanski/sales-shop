/**
 * Created by dominikbarchanski on 06/06/2022.
 */

({
    handleEdit : function (cmp){
           cmp.find('toEdit').set('v.formMode', 'edit');

    },itemsChange: function(cmp, evt) {
        cmp.set('v.isSingleRowSelected', cmp.get('v.rowObject').length <2 &&cmp.get('v.rowObject').length >0)
        console.log("numItems has changed");
    },handleDelete:function (cmp,event,helper){
        let row = cmp.get('v.rowObject')[0];
        console.log(row);
        helper.deleteRow(cmp,row)
    }

});
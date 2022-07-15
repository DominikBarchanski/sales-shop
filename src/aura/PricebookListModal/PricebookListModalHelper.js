/**
 * Created by dominikbarchanski on 11/07/2022.
 */

({
   handleDoInit:function (cmp,event,helper) {
       let searchValue = cmp.get('v.pricebookName')
       let action = cmp.get('c.getAllPricebook');
       action.setParams({pricebookName: searchValue})
       action.setCallback(this, $A.getCallback(function (resp) {

           var records =  resp.getReturnValue();
           for ( var i = 0; i < records.length; i++ ) {

               if ( records[i].isActive===true )  {
                   records[i].displayIconName='utility:check';

               }   else if( records[i].isActive===false){
                   records[i].displayIconName='utility:close';
               }
               else
               {
                   records[i].displayIconName='utility:warning';
               }

           }

           cmp.set('v.listOfPriceBook',records)
           // cmp.set('v.listOfPriceBook', resp.getReturnValue())
       }));
       $A.enqueueAction(action);
   },handleSearch:function (cmp,event,helper) {
        var pricebookName = cmp.find('pricebook-name-search').get('v.value');
        let action = cmp.get('c.getAllPricebook');
        action.setParams({pricebookName: pricebookName})
        action.setCallback(this, $A.getCallback(function (resp) {

            var records =  resp.getReturnValue();
            for ( var i = 0; i < records.length; i++ ) {
                if ( records[i].isActive===true )  {
                    records[i].displayIconName='utility:check';
                }   else if( records[i].isActive===false){
                    records[i].displayIconName='utility:close';
                }
                else
                {
                    records[i].displayIconName='utility:warning';
                }

            }

            cmp.set('v.listOfPriceBook',records)
        }));
        $A.enqueueAction(action);

    }
    ,
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
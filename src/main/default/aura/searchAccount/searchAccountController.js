/**
 * Created by dominikbarchanski on 03/06/2022.
 */


({
    init: function (cmp, event, helper) {
        var actions = [
            { label: 'Select', name: 'selectRecord' },
        ];
        cmp.set('v.accList', [
            { label: 'Name', fieldName: 'Name', type: 'text'},
            { label: 'Account Number', fieldName: 'AccountNumber', type: 'string'},
            { label: 'Phone', fieldName: 'Phone', type: 'string'},
            { label: 'City', fieldName: 'BillingCity', type: 'string'},
            { label: 'Street', fieldName: 'BillingStreet', type: 'string'},
            { label: 'Country', fieldName: 'BillingCountry', type: 'string'},
            {type: 'action', typeAttributes: {rowActions: actions,}}

        ]);

        helper.getData(cmp);

    },
    handleSearch:function (cmp,event,helper){
        helper.searchHelper(cmp)
    },
    handleNew:function (cmp,event,helper){
        var workspaceAPI = cmp.find("workspace");
        workspaceAPI.isConsoleNavigation().then(function(response) {
            if(response){
                var focusedTabId = response.tabId;
                workspaceAPI.closeTab({tabId: focusedTabId});
            }
        });
        var createRecordEvent = $A.get("e.force:createRecord");
        createRecordEvent.setParams({
            "entityApiName": "Account",
            "recordTypeId": cmp.get("v.TypeOfRecord")
        });
        createRecordEvent.fire();
    },
    handleClear:function (cmp,event,helper){
        cmp.set('v.selectedRows' , []);
        cmp.set('v.account', null)
        cmp.find('enter-account-name').set('v.value','')
        cmp.find('enter-city-name').set('v.value','')
        cmp.find('enter-phone-number').set('v.value','')
        helper.clearHelper()
    }, selectedRow:function (cmp,event,helper){
        var selectedRow = event.getParam('selectedRows');
        console.log(selectedRow);
        var setRows = [];
        for ( var i = 0; i < selectedRow.length; i++ ) {
            setRows.push(selectedRow[i]);
        }
        cmp.set("v.selectedRows", setRows);

    },afterDelete : function (cmp,event,helper){
        var params = event.getParam('arguments');
        if (params) {

            var param1 = params.selectedRows;
            cmp.set("v.selectedRows", param1);
        }

    },showRow:function(cmp,event,helper){
        let test =event.target;
        let indexVal = test.dataset.recordId;
        console.log( "indexVal is " +  indexVal  );
        var clickedRow = event.currentTarget.dataset.myid;
        console.log("it's work ", JSON.stringify(clickedRow) );
        console.log(parseInt(clickedRow)  );
        let tempAccList = cmp.get( "v.account" );
        let currentRec = tempAccList[ clickedRow ];
        console.log( "Current Value is " +  currentRec  );
        var selectedRow = cmp.get('v.selectedRows');
        var setRows = selectedRow;

        if(!setRows.includes(currentRec)) {
            // $A.util.addClass(indexVal,'slds-is-selected');
            // cmp.find(clickedRow).addClass(tr,'slds-is-selected');
            let itemtest = test.closest('tr')
            itemtest.classList.add('slds-is-selected')
            setRows.push(currentRec);
            cmp.set("v.selectedRows", setRows);
        }else{
            let itemtest = test.closest('tr')
            itemtest.classList.remove('slds-is-selected')
            let index = setRows.indexOf(currentRec);
            setRows.splice(index,1);
            cmp.set("v.selectedRows", setRows);
        }


    }

})
/**
 * Created by dominikbarchanski on 07/07/2022.
 */

({
    init: function (cmp, event, helper) {
        var tableActions = [
            {label: 'Show details', name: 'show_details'},
            {label: 'Edit', name: 'edit'},
            {label: 'Delete', name: 'delete'}
        ];

        cmp.set('v.columns', [
            // { label: 'Id', fieldName: 'id', type: 'text' },
            {label: 'Name', fieldName: 'name', type: 'text'},
            {label: 'Start Date', fieldName: 'startDate', type: 'text'},
            {label: 'End Date', fieldName: 'endDate', type: 'text'},
            {
                label: 'is Active', fieldName: '', cellAttributes: {
                    class: {fieldName: 'isActive'},
                    iconName: {
                        fieldName: 'displayIconName',
                    }
                }
            },
            {type: 'action', typeAttributes: {rowActions: tableActions}}
        ]);
        helper.handleDoInit(cmp,event,helper);
    }, handleSearch: function (cmp, event, helper) {
        var isEnterKey = event.keyCode === 13;
        console.log("działa to ")
        if (isEnterKey) {
            helper.handleSearch(cmp,event,helper)
        }

    },
    handleRowAction: function (cmp, event, helper) {
        var action = event.getParam('action');
        var row = event.getParam('row');
        var parentAction = cmp.get('v.parent')
        switch (action.name) {
            case 'show_details':
                console.log(row.id)
                parentAction.typeOfAction('view',row.id);
                break;
            case 'edit':
                parentAction.typeOfAction('edit',row.id);
                break
            case 'delete':
                helper.deleteRecord(cmp,row);
                console.log(row.id);
                break;
        }
    },
    handleCloseModal: function (cmp, event) {
        var cmpClose = false;
        var pushToParent = cmp.get("v.parent");
        pushToParent.closeModalAllPricebook(cmpClose);
    }
});
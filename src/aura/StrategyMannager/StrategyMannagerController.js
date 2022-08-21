/**
 * Created by dominikbarchanski on 15/07/2022.
 */

({init: function (cmp, event, helper) {
        var tableActions = [
            {label: 'Show details', name: 'show_details'},
            {label: 'Edit', name: 'edit'},
            {label: 'Delete', name: 'delete'}
        ];

        cmp.set('v.columns', [
            {label: 'Brand', fieldName: 'brand', type: 'text'},
            {label: 'Name', fieldName: 'name', type: 'text'},
            {label: 'Standard Price', fieldName: 'price', type: 'currency'},
            {label: 'Type', fieldName: 'type', type: 'text'},
            {label: 'Horce power', fieldName: 'hp', type: 'number'},
            // { type: 'action', typeAttributes: { rowActions: tableActions } }
        ]);

        helper.doInit(cmp, event, helper)
    }});
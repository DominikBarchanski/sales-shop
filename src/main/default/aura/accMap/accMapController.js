/**
 * Created by dominikbarchanski on 06/06/2022.
 */

({
    itemsChange: function(cmp, evt) {
        var listOfAcc = cmp.get('v.accList');
        var markerlist = []
        var mapTag ;
        for (let i = 0; i < listOfAcc.length; i++) {
            var itemStreet = listOfAcc[i].BillingStreet;
            var itemCity = listOfAcc[i].BillingCity;
            mapTag={
                location: {
                    Street: itemStreet,
                        City:  itemCity
                },
                icon: 'custom:custom96',
                title: 'test'
            }
            markerlist.push(mapTag);
        }
        cmp.set('v.mapMarkers',markerlist);
        console.log("numItems has changed");
    }
});
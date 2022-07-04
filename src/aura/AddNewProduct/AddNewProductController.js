/**
 * Created by dominikbarchanski on 04/07/2022.
 */

({
    getDetails : function (component,event){
        var params = event.getParam('arguments');
        if (params){
            component.set('v.Product',{
                name:params.ProductName ,
                price:params.ProductPrice ,
                description:params.ProductDescription
            })
            var num = parseInt(component.get("v.Progress"));
            component.set("v.Progress", (num + 1).toString());
            component.set("v.isDetails", false);
            component.set("v.isPhoto", true);

            var prod = component.get("v.Product")
            console.log(prod.name);
            // $A.get('e.force:refreshView').fire();

        }
    },getPhotos : function (component,event){
        var params= event.getParam('arguments');
        console.log(params)
        if(params){
            console.log(params.PhotoList)
            console.log(component.get("v.Product"))
            component.set("v.Product",{

                photoList: params.PhotoList
            })
            var num = parseInt(component.get("v.Progress"));
            console.log(component.get("v.Product"))
            component.set("v.Progress", (num + 1).toString());
            component.set("v.isPhoto", false);
            component.set("v.isOverview", true);
        }
    }
});
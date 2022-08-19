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
                description:params.ProductDescription,
                type:params.ProductType,
                hp:params.ProductHorsepower,
                brand:params.ProductBrand,
                prodYear:params.ProductYear,
                prodCountry:params.ProductCountry,
                prodCity:params.ProductCity,
                prodStreet:params.ProductStreet,
                prodCityConsum:params.ProductCityConsum,
                prodAvgConsum:params.ProductAvgConsum,
                prodCapacity:params.ProductCapacity,
                prodDoors:params.ProductDoors,
                prodPlaces:params.ProductPlaces,
                prodSpeed:params.ProductSpeed
            })
            var num = parseInt(component.get("v.Progress"));
            component.set("v.Progress", (num + 1).toString());
            component.set("v.isDetails", false);
            component.set("v.isPhoto", true);
            component.set("v.isOverview", false);

            var prod = component.get("v.Product")



        }
    },getPhotos : function (component,event){
        var params= event.getParam('arguments');
        console.log(params)
        if(params){
            var addItem =component.get("v.Product");
            addItem.photoList = params.PhotoList;
            addItem.mainPhoto = params.MainPhoto;
            console.log(addItem);
            component.set("v.Product", addItem)

            console.log(component.get("v.Product"))
            let num = parseInt(component.get("v.Progress"));
            component.set("v.Progress", (num + 1).toString());
            component.set("v.isDetails", false);
            component.set("v.isPhoto", false);
            component.set("v.isOverview", true);

        }
    }
    ,handleClose : function (component,event) {
        console.log('test')
        component.set("v.Progress", "0");
        component.set('v.Product', {});
        component.set('v.isDetails', false)
        component.set('v.isPhoto', false)
        component.set('v.isOverview', false)
        console.log(component.get('v.isDisplayModal'));
        component.set("v.isDisplayModal", false);
        console.log(component.get('v.isDisplayModal'));
        window.location= "/lightning/o/Product2/list"
    }
});
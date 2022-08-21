/**
 * Created by dominikbarchanski on 12/07/2022.
 */

({
    handleCreateList: function (component, event, helper) {
        var action = component.get("c.getBrands");
        var inputIndustry = component.find("InputAccountIndustry");
        var opts = [];
        action.setCallback(this, function (a) {
            opts.push({
                class: "optionClass",
                label: "Chose Brand",
                value: ""
            });
            for (var i = 0; i < a.getReturnValue().length; i++) {
                opts.push({"class": "optionClass", label: a.getReturnValue()[i], value: a.getReturnValue()[i]});
            }
            inputIndustry.set("v.options", opts);

        });
        $A.enqueueAction(action);
    }, handleSendDataToParent: function (component, event, helper) {
        var nameVaild = component.find('enter-product-name').get('v.validity')
        var priceVaild = component.find('enter-product-price').get('v.validity')
        var descriptionVaild = component.find('enter-product-description').get('v.validity')
        var typeVaild = component.find('enter-product-description').get('v.validity')
        var horsepowerVaild = component.find('enter-product-description').get('v.validity')
        var carBrandVaild = component.find('enter-product-description').get('v.validity')
        var carBrandCity = component.find('enter-product-city').get('v.validity')
        var carBrandCountry = component.find('enter-product-country').get('v.validity')
        var carBrandStreet = component.find('enter-product-street').get('v.validity')
        var carProductionVaild = component.find('production-year').get('v.validity')
        var carCityConsVaild = component.find('enter-product-city-consumption').get('v.validity')
        var carAvgConsVaild = component.find('enter-product-avg-consumption').get('v.validity')
        var carCapacityVaild = component.find('enter-product-capacity').get('v.validity')
        var carDoorsVaild = component.find('enter-product-doors').get('v.validity')
        var carPlacesVaild = component.find('enter-product-places').get('v.validity')
        var carSpeedVaild = component.find('enter-product-speed').get('v.validity')
        if (carSpeedVaild.valid &&carCityConsVaild.valid &&carAvgConsVaild.valid &&carCapacityVaild.valid &&carDoorsVaild.valid &&carPlacesVaild.valid && nameVaild.valid && priceVaild.valid && descriptionVaild.valid && typeVaild.valid && horsepowerVaild.valid && carBrandVaild.valid && carProductionVaild.valid && carBrandCity.valid && carBrandCountry.valid &&carBrandStreet.valid) {
            var ProdName = component.find('enter-product-name').get('v.value');
            var ProdDesc = component.find('enter-product-price').get('v.value');
            var ProdPrice = component.find('enter-product-description').get('v.value');
            var ProdType = component.find('enter-product-type').get('v.value');
            var ProdHp = component.find('enter-product-horsepower').get('v.value');
            var ProdYear = component.find('production-year').get('v.value');
            var ProdCity = component.find('enter-product-city').get('v.value')
            var ProdCountry = component.find('enter-product-country').get('v.value')
            var ProdStreet = component.find('enter-product-street').get('v.value')
            var ProdBrand = component.get('v.carBrand');
            var ProdCityConsum = component.find('enter-product-city-consumption').get('v.value')
            var ProdAvgConsum = component.find('enter-product-avg-consumption').get('v.value')
            var ProdCapacity = component.find('enter-product-capacity').get('v.value')
            var ProdDoors = component.find('enter-product-doors').get('v.value')
            var ProdPlaces = component.find('enter-product-places').get('v.value')
            var ProdSpeed = component.find('enter-product-speed').get('v.value')
            //Call Parent aura method
            var parentComponent = component.get("v.parent");
            parentComponent.getProductDetails(ProdName, ProdPrice, ProdDesc, ProdType, ProdHp, ProdBrand, ProdYear,ProdCountry,ProdCity,ProdStreet,ProdCityConsum,ProdAvgConsum,ProdCapacity,ProdDoors,ProdPlaces,ProdSpeed);
        } else {
            alert('Please update the invalid form entries and try again.');
        }
    }, handleClose: function (component, event, helper) {
        var parentComponent = component.get("v.parent");
        parentComponent.closeAdd();
    }
});
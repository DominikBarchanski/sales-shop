/**
 * Created by dominikbarchanski on 12/07/2022.
 */

({
    handleCreateList:function (component,event,helper){
        var action = component.get("c.getBrands");
        var inputIndustry = component.find("InputAccountIndustry");
        var opts=[];
        action.setCallback(this, function(a) {
            opts.push({
                class: "optionClass",
                label: "Chose Brand",
                value: ""
            });
            for(var i=0;i< a.getReturnValue().length;i++){
                opts.push({"class": "optionClass", label: a.getReturnValue()[i], value: a.getReturnValue()[i]});
            }
            inputIndustry.set("v.options", opts);

        });
        $A.enqueueAction(action);
    },handleSendDataToParent:function (component,event,helper){
        var nameVaild= component.find('enter-product-name').get('v.validity')
        var priceVaild= component.find('enter-product-price').get('v.validity')
        var descriptionVaild= component.find('enter-product-description').get('v.validity')
        var typeVaild= component.find('enter-product-description').get('v.validity')
        var horsepowerVaild= component.find('enter-product-description').get('v.validity')
        var carBrandVaild= component.find('enter-product-description').get('v.validity')
        if( nameVaild.valid &&priceVaild.valid &&descriptionVaild.valid&&typeVaild.valid&&horsepowerVaild.valid&&carBrandVaild.valid) {
            var ProdName = component.find('enter-product-name').get('v.value');
            var ProdDesc = component.find('enter-product-price').get('v.value');
            var ProdPrice = component.find('enter-product-description').get('v.value');
            var ProdType = component.find('enter-product-type').get('v.value');
            var ProdHp = component.find('enter-product-horsepower').get('v.value');
            var ProdBrand = component.get('v.carBrand');
            //Call Parent aura method
            var parentComponent = component.get("v.parent");
            console.log(ProdName, ProdDesc, ProdPrice);
            parentComponent.getProductDetails(ProdName, ProdPrice, ProdDesc,ProdType,ProdHp,ProdBrand);
        }else{
            alert('Please update the invalid form entries and try again.');
        }
    },handleClose:function (component,event,helper){
        var parentComponent = component.get("v.parent");
        parentComponent.closeAdd();
    }
});
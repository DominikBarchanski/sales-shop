/**
 * Created by dominikbarchanski on 04/07/2022.
 */

({

    callParentMethod : function(component, event, helper) {

        var ProdName = component.find('enter-product-name').get('v.value');
        var ProdDesc = component.find('enter-product-price').get('v.value');
        var ProdPrice = component.find('enter-product-description').get('v.value');
        //Call Parent aura method
        var parentComponent = component.get("v.parent");
        console.log(ProdName,ProdDesc,ProdPrice);
        parentComponent.getProductDetails(ProdName,ProdDesc,ProdPrice);
    }});
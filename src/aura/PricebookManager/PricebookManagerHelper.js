/**
 * Created by dominikbarchanski on 06/07/2022.
 */

({
    doInit:function (cmp,event,helper) {
        let searchValue = cmp.get('v.productName')
        let action = cmp.get('c.getAllStandardProduct');
        var currentStrategy;
        action.setParams({productName:searchValue})
        action.setCallback(this, $A.getCallback(function (resp){
            var listOfProd = resp.getReturnValue();
            for (const listOfProdElement of listOfProd) {
                switch (listOfProdElement.strategyName) {
                    case 'standard':
                        currentStrategy ='Standard Price'
                        listOfProdElement.strategyName = currentStrategy
                        listOfProdElement.strategyType = 'standard'
                        break
                    case 'lowest':
                        currentStrategy ='Lowest Discount Price'
                        listOfProdElement.strategyName = currentStrategy
                        listOfProdElement.strategyType = 'lowest'
                        break
                    case 'highest':
                        currentStrategy ='Highest Discount Price'
                        listOfProdElement.strategyName = currentStrategy
                        listOfProdElement.strategyType = 'highest'
                        break
                    case 'avg':
                        currentStrategy ='Average Discount Price'
                        listOfProdElement.strategyName = currentStrategy
                        listOfProdElement.strategyType = 'avg'
                        break
                }
            }
            cmp.set('v.currentStrategy',currentStrategy)
            cmp.set('v.listOfProducts',resp.getReturnValue())
        }));
        $A.enqueueAction(action);
    },
    handleSearch:function (cmp,event,helper) {
        var productName = cmp.find('product-name-search').get('v.value');
        let action = cmp.get('c.getAllStandardProduct');
        action.setParams({productName:productName})
        action.setCallback(this, $A.getCallback(function (resp){
            cmp.set('v.listOfProducts',resp.getReturnValue())
        }));
        $A.enqueueAction(action);
    }
});
/**
 * Created by dominikbarchanski on 31/05/2022.
 */

({
    callAuraMethod : function(component, event, helper) {
        //Call Child aura method
        let childComponent = component.find("childCmp");
        let message = childComponent.childMessageMethod();
    }
})
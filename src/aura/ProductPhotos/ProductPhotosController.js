/**
 * Created by dominikbarchanski on 04/07/2022.
 */

({
    handleUploadFinished: function (cmp, event) {
        var uploadedFiles = event.getParam("files");
        cmp.set("v.isPhoto",true)
        var listOfFile =[];
        uploadedFiles.forEach(file => listOfFile.push( file.documentId));
        cmp.set("v.allAddedFile", listOfFile)

    },handleSelectMainPhoto :function (cmp,event,helper){
        var mainPhoto =cmp.get('v.MainPhoto');
        var itemMainPhoto = event.target.dataset.value;
        var cmpTarget = cmp.find('itemMainPhoto')
        if(mainPhoto === ""){
            $A.util.addClass(cmpTarget,'selectedItem')
        }else {
            $A.util.addClass(cmpTarget,'selectedItem')
        }

        var clickedIndex = event.target.dataset.index;
        cmp.set("v.MainPhoto",itemMainPhoto)

    },
    callParentMethod : function(cmp, event, helper) {
        var FileList = cmp.get('v.allAddedFile');
        var mainPhoto =cmp.get('v.MainPhoto');
        if (mainPhoto === ""){
            mainPhoto = FileList[0];
        }
        var parentComponent = cmp.get("v.parent");
        parentComponent.getPhotoDetails(FileList,mainPhoto);
    }, handleClose : function (component,event ,helper){
        helper.handleClose(component,event ,helper);
    }
});
/**
 * Created by dominikbarchanski on 04/07/2022.
 */

({
    handleUploadFinished: function (cmp, event) {
        // Get the list of uploaded files
        var uploadedFiles = event.getParam("files");
        // alert("Files uploaded : " + uploadedFiles.length);
        cmp.set("v.isPhoto",true)
        // Get the file name
        var listOfFile =[];
        console.log(event.getParam("files"))
        uploadedFiles.forEach(file => listOfFile.push({val: file.documentId}));
        console.log(listOfFile);
        cmp.set("v.allAddedFile", listOfFile)

        console.log(cmp.get('v.allAddedFile'))
    },
    callParentMethod : function(cmp, event, helper) {

        var FileList = cmp.get('v.allAddedFile');
        // console.log(FileList)
        //Call Parent aura method
        var parentComponent = cmp.get("v.parent");

        parentComponent.getPhotoDetails(FileList);
    }
});
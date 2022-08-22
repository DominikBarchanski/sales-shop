/**
 * Created by dominikbarchanski on 11/05/2022.
 */

global class DoctorSearchSOAPService {
    global class DoctorDTO {
        webService String doctorId;
        webService String lastName;
        webService String firstName;
        webService String specialty;
        webService String country;
        webService String phone;
        webService String emailAddress;

        global DoctorDTO(Doctor__c doctor) {
            this.doctorId = doctor.Id;
            this.lastName = doctor.Name;
            this.firstName = doctor.First_Name__c;
            this.specialty = doctor.Specialization__c;
            this.country = doctor.Country__c;
            this.phone = doctor.Phone__c;
            this.emailAddress = doctor.Email__c;
        }
    }
    global class ReturnClass {
        webService  List<DoctorDTO> listOfDoctor;
        webService String message;
        webService DoctorDTO doctor;

        public Returnclass(Boolean test, String mess) {
            message = test ? 'Done' : mess.length() > 0 ? mess : 'something goes wrong';
        }
        public Returnclass(Boolean test, String mess,DoctorDTO doc) {
            message = test ? 'Done' : mess.length() > 0 ? mess : 'something goes wrong';
        }
        public Returnclass(List<DoctorDTO> test,Boolean firstName) {
            listOfDoctor = test.size() > 0 ? test : null;
            message = test.size() > 0 ? null : firstName ? '0 record finded' :' type LastName';
        }
        public Returnclass(String test,String mes) {
            message = mes.length() > 0? mes : 'Doctor Delete' ;// + test ; //Po konsultacji z Rafałem :Jor doctor łos dilit
        }


    }

    webService static ReturnClass getAllDoctor() {

        List<Doctor__c> allDoc = [SELECT Name, First_Name__c, Specialization__c, Phone__c, Email__c, Date_of_birth__c, Country__c, City__c, Street__c FROM Doctor__c];

        List<DoctorDTO> dtoList = new List<DoctorDTO>();
        for(Doctor__c item : allDoc){
            DoctorDTO dtoItem =new DoctorDTO(item);
            dtoList.add(dtoItem);
        }

        return new ReturnClass(dtoList,true);
    }

    webService static ReturnClass searchDoctor(String LastName, String FirstName, String Country) {
        List<Doctor__c> resultDoc;
        String soql = '';
        Boolean firstSoql = false;
        if (String.isNotBlank(LastName)) {
            soql = 'SELECT Name, First_Name__c, Specialization__c, Phone__c, Email__c, Date_of_birth__c, Country__c, City__c, Street__c  FROM Doctor__c WHERE Name LIKE \'%' + LastName + '%\' ';
            firstSoql = true;
        }

        if (String.isNotBlank(FirstName) && firstSoql) {
            soql += ' and First_Name__c LIKE \'%' + FirstName + '%\' ';

        }
        if (String.isNotBlank(Country) && firstSoql) {
            soql += ' and Country__c LIKE \'%' + Country + '\' ';

        }
        if (soql.length() > 0 ) {
            resultDoc = Database.query(soql);
        } else {
            resultDoc = new List<Doctor__c>();
        }

        List<DoctorDTO> dtoList = new List<DoctorDTO>();
        for(Doctor__c item : resultDoc){
            DoctorDTO dtoItem =new DoctorDTO(item);
            dtoList.add(dtoItem);
        }
        return new ReturnClass(dtoList,firstSoql);
    }

    webService static Returnclass createDoctor(String FirstName, String LastName, String Specialization, String Phone, String Email, Date dateOfBirth, String city, String country, String street) {
        Doctor__c doctorToInsert = new Doctor__c();
        Boolean status = false;
        String message = '';
        doctorToInsert.First_Name__c = FirstName;
        doctorToInsert.Name = LastName;
        doctorToInsert.Specialization__c = Specialization;
        doctorToInsert.Phone__c = Phone;
        doctorToInsert.Email__c = Email;
        doctorToInsert.Date_of_birth__c = dateOfBirth;
        doctorToInsert.City__c = city;
        doctorToInsert.Country__c = country ;
        doctorToInsert.Street__c = street;
        Database.SaveResult item;
        Doctor__c newDoctor =new Doctor__c();

        try {
            item = Database.insert(doctorToInsert);
            status = item.isSuccess();
            newDoctor = [SELECT Name, First_Name__c, Specialization__c, Phone__c, Email__c, Date_of_birth__c, Country__c, City__c, Street__c FROM Doctor__c WHERE Id =: item.getId()];
        } catch (Exception e) {
            message = (String) e.getMessage();
        }
        DoctorDTO newDoctorDTO =new DoctorDTO(newDoctor);
        return new Returnclass(status, message,newDoctorDTO);

    }
    webService static Returnclass deleteDoctor(String doctorId) {
        Doctor__c doctorToDelete;
        String message = '';
        if (String.isNotBlank(doctorId)){
            try {
             doctorToDelete = [SELECT Id FROM Doctor__c WHERE Id = :doctorId LIMIT 1];
            }catch (Exception e ){
                message = 'wrong id ';
            }
        }
        try {
            delete doctorToDelete;
        }catch (Exception e ){
            message += 'cant delete doctor';
        }
        return new Returnclass(doctorId,message);
    }
    webService static Returnclass updateDoctor(String doctorId, String FirstName, String LastName, String Specialization, String Phone, String Email, Date dateOfBirth, String city, String country, String street) {
        Doctor__c doctorToUpdate = new Doctor__c();
        Boolean result;
        String message;
        try {
            doctorToUpdate = [SELECT Name, First_Name__c, Specialization__c, Phone__c, Email__c, Date_of_birth__c, Country__c, City__c, Street__c FROM Doctor__c WHERE Id = :doctorId LIMIT 1];
        }catch (Exception e){
            message = e.getMessage();
        }

        if (String.isNotBlank(FirstName)) {
            doctorToUpdate.First_Name__c = FirstName;
        }

            doctorToUpdate.Name = LastName;
            doctorToUpdate.Specialization__c = Specialization;
            doctorToUpdate.Phone__c = Phone;
            doctorToUpdate.Email__c = Email;
            doctorToUpdate.Date_of_birth__c = dateOfBirth;
            doctorToUpdate.City__c = city;
            doctorToUpdate.Country__c = country ;
            doctorToUpdate.Street__c = street;

        try {
            Database.SaveResult item = Database.update(doctorToUpdate);
            result=item.isSuccess();
        } catch (Exception e) {
            message += e.getMessage();
        }

        return new Returnclass(result,message);
    }

}
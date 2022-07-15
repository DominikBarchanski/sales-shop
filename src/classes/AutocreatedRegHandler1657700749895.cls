//TODO:This autogenerated class includes the basics for a Registration
//Handler class. You will need to customize it to ensure it meets your needs and
//the data provided by the third party.

global class AutocreatedRegHandler1657700749895 implements Auth.RegistrationHandler{
  private static final String ORG_SUFFIX = 'avenirhouse.org';
    public static final String DEFAULT_ACCOUNTNAME = 'Community Account';
    
/**
 * Let anyone register as long as the required fields are supplied
 * 
 * We require email, lastName, firstName
 * 
 * @data - the user's info from the Auth Provider
 **/ 
global boolean canCreateUser(Auth.UserData data) {
    System.debug(data);
    System.debug('canCreateUser was called for ' + (data != null ? data.email : 'null'));
    Boolean retVal = (data != null 
            && data.email != null
            && data.lastName != null
            && data.firstName != null);
    
    System.debug('data.username='+data.username);
    System.debug('data.email='+data.email);
    System.debug('data.lastName='+data.lastName);
    System.debug('data.firstName='+data.firstName);
    
    return retVal;
}

/**
 * Create the User - A required method to implement the Handler Interface
 * 
 * @param portalId  - Id of the Community
 * @param data - Auth Provider user data describing the User to create
 * 
 * @return User that has been initialized
**/ 
global User createUser(Id portalId, Auth.UserData data){
    if(!canCreateUser(data)) {
        // Returning null signals the auth framework we can't create the user
        return null;
    }
    
    // Is this a Community Context?
 
        System.debug('Registering Community user: ' + data.email);
        
        // To keep things modular, we're creating the PersonAccount in a separate method
        Id contactId = createPersonAccountContact(data);
        
        // You'd likely use other logic to assign the Profile
        Profile p = [SELECT Id FROM Profile WHERE Name='Customer Community User'];

        // Keeping it modular, we initialize the user in another method
        User u = createUser(data,p);
//        u.Username = data.fullName;
        u.contactId = contactId;
        return u;

}

/**
 * Update the user
 * @param portalId  - Id of the Community
 * @param data - Auth Provider user data describing the User to create
 **/     
global void updateUser(Id userId, Id portalId, Auth.UserData data){
    System.debug('Update User called for: ' + data.email);
    
    User u = new User(id=userId);
//    u.Username = data.firstName + ' ' + data.lastName;
//    u.Username = data.fullName;
    u.email = data.email;
    u.lastName = data.lastName;
    u.firstName = data.firstName;
    update(u);
}
    /**
     * Create a PersonAccount for the contact
     * 
     * @param data - Facebook provided context for this User
     **/ 
    private Id createPersonAccountContact(Auth.UserData data) {
     Account a = [SELECT Id FROM account WHERE name='Community Account'];
        Contact c = new Contact();
        c.accountId = a.Id;
        c.email = data.email;
        c.firstName = data.firstName;
        c.lastName = data.lastName;
        insert(c);
        
        return c.Id; 

    }
    
    /**
     * Create and initialize the User but don't save it yet
     * 
     * @param data - the provided User context from FaceBook
     * @param p - the Profile we are going to assign to this user
     * 
     * @return User that has been initialized but not Saved
     **/ 
    private User createUser(Auth.UserData data, Profile p) {
        User u = new User();
        u.username = data.email + ORG_SUFFIX;
        u.email = data.email;
        u.lastName = data.lastName;
        u.firstName = data.firstName;
        String alias = data.firstName + data.lastName;
        
        //Alias must be 8 characters or less
        if(alias.length() > 8) {
            alias = alias.substring(0, 8);
        }
        u.alias = alias;
        u.languagelocalekey = UserInfo.getLanguage();
        u.localesidkey = UserInfo.getLocale();
        u.emailEncodingKey = 'UTF-8';
        u.timeZoneSidKey = 'America/Los_Angeles';
        u.profileId = p.Id;
        return u;
    }
}
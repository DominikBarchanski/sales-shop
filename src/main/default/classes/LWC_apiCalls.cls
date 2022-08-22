/**
 * Created by dominikbarchanski on 07/06/2022.
 */

public with sharing class LWC_apiCalls {
//    private static final String endpoint;
    @AuraEnabled
    public static Music_Comments__c addRateAndComments(String itemId, String commentBody, Integer rate) {
        Music_Comments__c newComment = new Music_Comments__c();
        newComment.rate__c = rate;
        newComment.Item_Id__c = itemId;
        newComment.Comment__c = commentBody;
        insert newComment;
        return newComment;
    }
    @AuraEnabled(Cacheable=true)
    public static String searchSongTest(String name, String type, String limitItems, String offset) {

        String endpoint = 'callout:apiSpotyfi';
        Http h = new Http();
        HttpRequest req = new HttpRequest();

        req.setEndpoint(endpoint + '/v1/search?q=' + name.replace(' ','+') + '&type=track,artist&limit=' + limitItems + '&offset=' + offset);
        req.setHeader('Content-Type', 'application/json');
        req.setHeader('accept', 'application/json');
        req.setHeader('Authorization', 'Bearer ' + Userinfo.getSessionId());
        req.setMethod('GET');
        HttpResponse res = h.send(req);
//        WrapperArtist apiw = new WrapperArtist();
//        apiw = (WrapperArtist)JSON.deserialize(res.getBody(),WrapperArtist.class);
//        System.debug(apiw);
        return res.getBody();
    }

    @AuraEnabled(Cacheable=true)
    public static List<Music_Comments__c> getAllComments(String id) {
        List<Music_Comments__c> items = new List<Music_Comments__c>([SELECT Comment__c, rate__c, Item_Id__c, CreatedDate, CreatedById, Created_By_Name__c FROM Music_Comments__c where Item_Id__c = :id ORDER BY CreatedDate DESC]);
        Map<Id, User> userMap = new Map<Id, User>([SELECT Id, Name FROM User]);
        System.debug(userMap);
        System.debug(items);
        for (Music_Comments__c item : items) {
            item.Created_By_Name__c = userMap.get(item.CreatedById).Name;
        }
        return items;
    }
    @AuraEnabled(Cacheable=true)
    public static String getArtistAlbum(String artistId) {
        String endpoint = 'callout:apiSpotyfi';
        // Instantiate a new http object
        Http h = new Http();
        // Instantiate a new HTTP request, specify the method (GET) as well as the endpoint
        HttpRequest req = new HttpRequest();
        req.setEndpoint(endpoint + '/v1/albums/' + artistId);
        req.setHeader('Content-Type', 'application/json');
        req.setHeader('accept', 'application/json');
        req.setHeader('Authorization', 'Bearer ' + Userinfo.getSessionId());
        req.setMethod('GET');
        HttpResponse res = h.send(req);
//        System.debug(res.getBody());
        return res.getBody();
    }
    @AuraEnabled(Cacheable=true)
    public static String getAlbumTrack(String trackId) {
        System.debug('test');
        String endpoint = 'callout:apiSpotyfi';
        // Instantiate a new http object
        Http h = new Http();
        // Instantiate a new HTTP request, specify the method (GET) as well as the endpoint
        HttpRequest req = new HttpRequest();
        trackId = trackId.replace('"', '');
        System.debug(trackId);
        req.setEndpoint(endpoint + '/v1/tracks/' + trackId);
        req.setHeader('Content-Type', 'application/json');
        req.setHeader('accept', 'application/json');
        req.setHeader('Authorization', 'Bearer ' + Userinfo.getSessionId());
        req.setMethod('GET');
        HttpResponse res = h.send(req);
//        System.debug(res.getBody());
        return res.getBody();
    }
    @AuraEnabled(Cacheable=true)
    public static String getAllAlbumArtist(String artistId) {
        String endpoint = 'callout:apiSpotyfi';
        // Instantiate a new http object
        Http h = new Http();
        // Instantiate a new HTTP request, specify the method (GET) as well as the endpoint
        HttpRequest req = new HttpRequest();

        req.setEndpoint(endpoint + '/v1/artists/' + artistId + '/albums');
        req.setHeader('Content-Type', 'application/json');
        req.setHeader('accept', 'application/json');
        req.setHeader('Authorization', 'Bearer ' + Userinfo.getSessionId());
        req.setMethod('GET');
        HttpResponse res = h.send(req);
//        System.debug(res.getBody());
        return res.getBody();
    }

    @AuraEnabled(Cacheable=true)
    public static String getTrackByAlbumId(String albumID) {
        String endpoint = 'callout:apiSpotyfi';
        // Instantiate a new http object
        Http h = new Http();
        // Instantiate a new HTTP request, specify the method (GET) as well as the endpoint
        HttpRequest req = new HttpRequest();

        req.setEndpoint(endpoint + '/v1/albums/' + albumID + '/tracks');
        req.setHeader('Content-Type', 'application/json');
        req.setHeader('accept', 'application/json');
        req.setHeader('Authorization', 'Bearer ' + Userinfo.getSessionId());
        req.setMethod('GET');
        HttpResponse res = h.send(req);
//        System.debug(res.getBody());
        return res.getBody();
    }
    @AuraEnabled(Cacheable=true)
    public static String getArtistById(String artistId) {
        String endpoint = 'callout:apiSpotyfi';
        // Instantiate a new http object
        Http h = new Http();
        // Instantiate a new HTTP request, specify the method (GET) as well as the endpoint
        HttpRequest req = new HttpRequest();

        req.setEndpoint(endpoint + '/v1/artists/' + artistId);
        req.setHeader('Content-Type', 'application/json');
        req.setHeader('accept', 'application/json');
        req.setHeader('Authorization', 'Bearer ' + Userinfo.getSessionId());
        req.setMethod('GET');
        HttpResponse res = h.send(req);
//        System.debug(res.getBody());
        return res.getBody();
    }
    @AuraEnabled(Cacheable=true)
    public static List<Music_Favorite_Blacklist__c> getFavBlacklist(String userId) {
        List<Music_Favorite_Blacklist__c> res = [SELECT Item_Id__c, Type_Of_Object__c, Favourite_Blacklist__c, Name__c FROM Music_Favorite_Blacklist__c WHERE CreatedById = :userId];
        return res;
    }

    public class CustomArtist {
        @AuraEnabled
        public String id;
        @AuraEnabled
        public String name;
        @AuraEnabled
        public String genres;
        @AuraEnabled
        public String followers;
        @AuraEnabled
        public String images;
        @AuraEnabled
        public String type;

    }
    public class CustomTrack {
        @AuraEnabled
        public String id;
        @AuraEnabled
        public String name;
        @AuraEnabled
        public String type;
        @AuraEnabled
        public Integer duration_ms;
        @AuraEnabled
        public String artists;
        @AuraEnabled
        public String release_date;
    }
    public class WrapperArtist {

        public List<CustomTrack> tracks;
        public List<CustomArtist> artists ;
    }
    @AuraEnabled(Cacheable=true)
    public static WrapperArtist getCustomObject(String name) {
        String findItem = '%'+name+'%';
        List<Artist__c> customArtists = [SELECT Id, name__c, followers__c, genres__c, images__c, type__c FROM Artist__c WHERE name__c LIKE:('%' + name + '%')];
        List<Track__c> customTrack = [SELECT Id, name__c, duration_ms__c, release_date__c, type__c,artists__c FROM Track__c WHERE name__c LIKE:('%' + name + '%')];
        List<CustomArtist> listCustomArtists = new List<CustomArtist>();
        List<CustomTrack> listCustomTrack = new List<CustomTrack>();
        for (Artist__c item : customArtists) {
            CustomArtist newObject = new CustomArtist();
            newObject.id = item.Id ;
            newObject.name = item.name__c;
            newObject.type = 'artist';
            newObject.followers = item.followers__c;
            newObject.genres = item.genres__c;
            newObject.images = item.images__c;
            listCustomArtists.add(newObject);
        }
        for (Track__c item : customTrack) {
            CustomTrack newObject = new CustomTrack();
            newObject.id = item.Id;
            newObject.name = item.name__c;
            newObject.type = 'track';
            newObject.artists = item.artists__c;
            newObject.duration_ms = item.duration_ms__c.intValue();
            newObject.release_date = item.release_date__c;
            listCustomTrack.add(newObject);
        }
        WrapperArtist wrapperList = new WrapperArtist();
        wrapperList.artists = listCustomArtists;
        wrapperList.tracks = listCustomTrack;


        return wrapperList;
    }
    @AuraEnabled(Cacheable=true)
    public static String wrappedCustomObject(String name) {
        return JSON.serialize(getCustomObject(name));
    }
    @AuraEnabled(Cacheable=true)
    public static List<Music_Favorite_Blacklist__c> getBlockedItems (String id){
        List<Music_Favorite_Blacklist__c> getBanItems = [SELECT  Id,Item_Id__c FROM Music_Favorite_Blacklist__c WHERE CreatedById =:id AND Favourite_Blacklist__c='blocked'];
        System.debug(getBanItems);
        return getBanItems;
    }


}
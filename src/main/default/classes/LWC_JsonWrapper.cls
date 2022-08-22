/**
 * Created by dominikbarchanski on 07/06/2022.
 */

public with sharing class LWC_JsonWrapper {

    public class External_ids {
        public String isrc { get; set; }

        public External_ids(JSONParser parser) {
            while (parser.nextToken() != System.JSONToken.END_OBJECT) {
                if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
                    String text = parser.getText();
                    if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
                        if (text == 'isrc') {
                            isrc = parser.getText();
                        } else {
                            System.debug(LoggingLevel.WARN, 'External_ids consuming unrecognized property: ' + text);
                            consumeObject(parser);
                        }
                    }
                }
            }
        }
    }

    public class Tracks {
        public String href { get; set; }
        public List<Items> items { get; set; }
        public Integer limit_Z { get; set; } // in json: limit
        public String next { get; set; }
        public Integer offset { get; set; }
        public Object previous { get; set; }
        public Integer total { get; set; }

        public Tracks(JSONParser parser) {
            while (parser.nextToken() != System.JSONToken.END_OBJECT) {
                if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
                    String text = parser.getText();
                    if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
                        if (text == 'href') {
                            href = parser.getText();
                        } else if (text == 'items') {
                            items = arrayOfItems(parser);
                        } else if (text == 'limit') {
                            limit_Z = parser.getIntegerValue();
                        } else if (text == 'next') {
                            next = parser.getText();
                        } else if (text == 'offset') {
                            offset = parser.getIntegerValue();
                        } else if (text == 'previous') {
                            previous = parser.readValueAs(Object.class);
                        } else if (text == 'total') {
                            total = parser.getIntegerValue();
                        } else {
                            System.debug(LoggingLevel.WARN, 'Tracks consuming unrecognized property: ' + text);
                            consumeObject(parser);
                        }
                    }
                }
            }
        }
    }

    public Tracks tracks { get; set; }

    public LWC_JsonWrapper(JSONParser parser) {
        while (parser.nextToken() != System.JSONToken.END_OBJECT) {
            if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
                String text = parser.getText();
                if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
                    if (text == 'tracks') {
                        tracks = new Tracks(parser);
                    } else {
                        System.debug(LoggingLevel.WARN, 'JSON2Apex consuming unrecognized property: ' + text);
                        consumeObject(parser);
                    }
                }
            }
        }
    }

    public class Images {
        public Integer height { get; set; }
        public String url { get; set; }
        public Integer width { get; set; }

        public Images(JSONParser parser) {
            while (parser.nextToken() != System.JSONToken.END_OBJECT) {
                if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
                    String text = parser.getText();
                    if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
                        if (text == 'height') {
                            height = parser.getIntegerValue();
                        } else if (text == 'url') {
                            url = parser.getText();
                        } else if (text == 'width') {
                            width = parser.getIntegerValue();
                        } else {
                            System.debug(LoggingLevel.WARN, 'Images consuming unrecognized property: ' + text);
                            consumeObject(parser);
                        }
                    }
                }
            }
        }
    }

    public class Album {
        public String album_type { get; set; }
        public List<Artists> artists { get; set; }
        public List<String> available_markets { get; set; }
        public External_urls external_urls { get; set; }
        public String href { get; set; }
        public String id { get; set; }
        public List<Images> images { get; set; }
        public String name { get; set; }
        public String release_date { get; set; }
        public String release_date_precision { get; set; }
        public Integer total_tracks { get; set; }
        public String type { get; set; }
        public String uri { get; set; }

        public Album(JSONParser parser) {
            while (parser.nextToken() != System.JSONToken.END_OBJECT) {
                if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
                    String text = parser.getText();
                    if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
                        if (text == 'album_type') {
                            album_type = parser.getText();
                        } else if (text == 'artists') {
                            artists = arrayOfArtists(parser);
                        } else if (text == 'available_markets') {
                            available_markets = arrayOfString(parser);
                        } else if (text == 'external_urls') {
                            external_urls = new External_urls(parser);
                        } else if (text == 'href') {
                            href = parser.getText();
                        } else if (text == 'id') {
                            id = parser.getText();
                        } else if (text == 'images') {
                            images = arrayOfImages(parser);
                        } else if (text == 'name') {
                            name = parser.getText();
                        } else if (text == 'release_date') {
                            release_date = parser.getText();
                        } else if (text == 'release_date_precision') {
                            release_date_precision = parser.getText();
                        } else if (text == 'total_tracks') {
                            total_tracks = parser.getIntegerValue();
                        } else if (text == 'type') {
                            type = parser.getText();
                        } else if (text == 'uri') {
                            uri = parser.getText();
                        } else {
                            System.debug(LoggingLevel.WARN, 'Album consuming unrecognized property: ' + text);
                            consumeObject(parser);
                        }
                    }
                }
            }
        }
    }

    public class Items {
        public Album album { get; set; }
        public List<Artists> artists { get; set; }
        public List<String> available_markets { get; set; }
        public Integer disc_number { get; set; }
        public Integer duration_ms { get; set; }
        public Boolean explicit { get; set; }
        public External_ids external_ids { get; set; }
        public External_urls external_urls { get; set; }
        public String href { get; set; }
        public String id { get; set; }
        public Boolean is_local { get; set; }
        public String name { get; set; }
        public Integer popularity { get; set; }
        public String preview_url { get; set; }
        public Integer track_number { get; set; }
        public String type { get; set; }
        public String uri { get; set; }

        public Items(JSONParser parser) {
            while (parser.nextToken() != System.JSONToken.END_OBJECT) {
                if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
                    String text = parser.getText();
                    if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
                        if (text == 'album') {
                            album = new Album(parser);
                        } else if (text == 'artists') {
                            artists = arrayOfArtists(parser);
                        } else if (text == 'available_markets') {
                            available_markets = arrayOfString(parser);
                        } else if (text == 'disc_number') {
                            disc_number = parser.getIntegerValue();
                        } else if (text == 'duration_ms') {
                            duration_ms = parser.getIntegerValue();
                        } else if (text == 'explicit') {
                            explicit = parser.getBooleanValue();
                        } else if (text == 'external_ids') {
                            external_ids = new External_ids(parser);
                        } else if (text == 'external_urls') {
                            external_urls = new External_urls(parser);
                        } else if (text == 'href') {
                            href = parser.getText();
                        } else if (text == 'id') {
                            id = parser.getText();
                        } else if (text == 'is_local') {
                            is_local = parser.getBooleanValue();
                        } else if (text == 'name') {
                            name = parser.getText();
                        } else if (text == 'popularity') {
                            popularity = parser.getIntegerValue();
                        } else if (text == 'preview_url') {
                            preview_url = parser.getText();
                        } else if (text == 'track_number') {
                            track_number = parser.getIntegerValue();
                        } else if (text == 'type') {
                            type = parser.getText();
                        } else if (text == 'uri') {
                            uri = parser.getText();
                        } else {
                            System.debug(LoggingLevel.WARN, 'Items consuming unrecognized property: ' + text);
                            consumeObject(parser);
                        }
                    }
                }
            }
        }
    }

    public class External_urls {
        public String spotify { get; set; }

        public External_urls(JSONParser parser) {
            while (parser.nextToken() != System.JSONToken.END_OBJECT) {
                if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
                    String text = parser.getText();
                    if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
                        if (text == 'spotify') {
                            spotify = parser.getText();
                        } else {
                            System.debug(LoggingLevel.WARN, 'External_urls consuming unrecognized property: ' + text);
                            consumeObject(parser);
                        }
                    }
                }
            }
        }
    }

    public class Artists {
        public External_urls external_urls { get; set; }
        public String href { get; set; }
        public String id { get; set; }
        public String name { get; set; }
        public String type { get; set; }
        public String uri { get; set; }

        public Artists(JSONParser parser) {
            while (parser.nextToken() != System.JSONToken.END_OBJECT) {
                if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
                    String text = parser.getText();
                    if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
                        if (text == 'external_urls') {
                            external_urls = new External_urls(parser);
                        } else if (text == 'href') {
                            href = parser.getText();
                        } else if (text == 'id') {
                            id = parser.getText();
                        } else if (text == 'name') {
                            name = parser.getText();
                        } else if (text == 'type') {
                            type = parser.getText();
                        } else if (text == 'uri') {
                            uri = parser.getText();
                        } else {
                            System.debug(LoggingLevel.WARN, 'Artists consuming unrecognized property: ' + text);
                            consumeObject(parser);
                        }
                    }
                }
            }
        }
    }

    @AuraEnabled(Cacheable=true)
    public static LWC_JsonWrapper parse(String json) {
        System.JSONParser parser = System.JSON.createParser(json);
        return new LWC_JsonWrapper(parser);
    }
    @AuraEnabled(Cacheable=true)
    public static void consumeObject(System.JSONParser parser) {
        Integer depth = 0;
        do {
            System.JSONToken curr = parser.getCurrentToken();
            if (curr == System.JSONToken.START_OBJECT ||
                    curr == System.JSONToken.START_ARRAY) {
                depth++;
            } else if (curr == System.JSONToken.END_OBJECT ||
                    curr == System.JSONToken.END_ARRAY) {
                depth--;
            }
        } while (depth > 0 && parser.nextToken() != null);
    }


    private static List<String> arrayOfString(System.JSONParser p) {
        List<String> res = new List<String>();
        if (p.getCurrentToken() == null) p.nextToken();
        while (p.nextToken() != System.JSONToken.END_ARRAY) {
            res.add(p.getText());
        }
        return res;
    }


    private static List<Items> arrayOfItems(System.JSONParser p) {
        List<Items> res = new List<Items>();
        if (p.getCurrentToken() == null) p.nextToken();
        while (p.nextToken() != System.JSONToken.END_ARRAY) {
            res.add(new Items(p));
        }
        return res;
    }


    private static List<Artists> arrayOfArtists(System.JSONParser p) {
        List<Artists> res = new List<Artists>();
        if (p.getCurrentToken() == null) p.nextToken();
        while (p.nextToken() != System.JSONToken.END_ARRAY) {
            res.add(new Artists(p));
        }
        return res;
    }


    private static List<Images> arrayOfImages(System.JSONParser p) {
        List<Images> res = new List<Images>();
        if (p.getCurrentToken() == null) p.nextToken();
        while (p.nextToken() != System.JSONToken.END_ARRAY) {
            res.add(new Images(p));
        }
        return res;
    }

}
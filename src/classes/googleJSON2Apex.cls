/**
 * Created by dominikbarchanski on 03/08/2022.
 */

public with sharing class googleJSON2Apex {

        public class Address_components {
            public String long_name;
            public String short_name;
            public List<String> types;
        }

        public class Geometry {
            public Location location;
            public String location_type;
            public Viewport viewport;
        }

        public class Plus_code {
            public String compound_code;
            public String global_code;
        }

        public List<Results> results;
        public String status;

        public class Results {
            public List<Address_components> address_components;
            public String formatted_address;
            public Geometry geometry;
            public String place_id;
            public Plus_code plus_code;
            public List<String> types;
        }

        public class Viewport {
            public Location northeast;
            public Location southwest;
        }

        public class Location {
            public Double lat;
            public Double lng;
        }


        public static googleJSON2Apex parse(String json) {
            return (googleJSON2Apex) System.JSON.deserialize(json, googleJSON2Apex.class);
        }

}
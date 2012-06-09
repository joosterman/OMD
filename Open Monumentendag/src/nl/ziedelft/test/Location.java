package nl.ziedelft.test;

import java.util.Date;

import javax.persistence.Id;

import com.google.appengine.api.datastore.GeoPt;

public class Location {

		@Id Long id;
		String name;
		GeoPt geo;
		String city;
		String street;
		int streetNumber;
		Date lastChanged;
		
		@SuppressWarnings("unused")
		private Location(){};
		
		public Location(String name, String city){
			this.name = name;this.city = city;
		}
		
}

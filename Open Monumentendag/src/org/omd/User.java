package org.omd;

import java.util.UUID;

import javax.persistence.Id;
import javax.persistence.PrePersist;

import com.google.appengine.api.datastore.GeoPt;

public class User {

	@Id
	public Long id;
	public String email;
	public String key;
	public GeoPt location;
		
	@PrePersist void onPersist() { 
		if(key==null){
			key = UUID.randomUUID().toString();
		}
	}
}

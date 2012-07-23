package org.omd;

import java.util.Date;

import javax.persistence.Id;
import javax.persistence.PrePersist;

import com.google.appengine.api.datastore.GeoPt;

public class UserLocationHistory {

	@Id
	public Long id;
	public Long userId;
	public Date date;
	public GeoPt location;
	
	@PrePersist void onPersist() { 
		date = new Date();		
	}
}

package org.omd;

import java.util.Date;

import javax.persistence.Id;
import javax.persistence.PrePersist;

public class UserImage {

	@Id
	public Long id;
	public Long userID;
	public Long locationID;
	public int flagged;
	public Date date;
	public String blobKey;
	public boolean adminApproved;
	
	@PrePersist void onPersist() { 
		date = new Date();		
	}
	
}

package org.omd;

import java.util.Date;

import javax.persistence.Id;
import javax.persistence.PrePersist;

public class Comment {
	@Id
	public Long id;
	public Long userID;
	public Long locationID;
	public String comment;
	public Date date;
	public int flagged;
	
	@PrePersist void onPersist() { 
		date= new Date();
	}
}

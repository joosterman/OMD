package org.omd;

import java.util.Date;
import javax.persistence.Id;
import javax.persistence.PrePersist;

public class Like {
	@Id
	public Long id;
	public Long userID;
	public Long locationID;
	public Date date;
	public LikeStatus status;
	
	@PrePersist void onPersist() { 
		date = new Date();		
	}
	
	public enum LikeStatus {LIKE,DISLIKE,UNKNOWN};
}



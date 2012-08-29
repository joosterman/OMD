package org.omd;

import java.util.Date;
import javax.persistence.Id;
import javax.persistence.PrePersist;
import com.google.appengine.api.blobstore.BlobKey;

public class UserImage {

	@Id
	public Long id;
	public Long userID;
	public Long locationID;
	public int flagged;
	public Date date;
	public BlobKey blobKey;
	public boolean adminApproved;
	public String imageURL;
	
	@PrePersist void onPersist() { 
		date = new Date();		
	}
	
}

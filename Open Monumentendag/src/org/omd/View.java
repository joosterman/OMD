package org.omd;

import java.util.Date;
import javax.persistence.Id;
import javax.persistence.PrePersist;

public class View {
	@Id
	public Long id;
	public Long userID;
	public Long locationID;
	public Date date;
	
	@PrePersist void onPersist() { 
			date= new Date();
	}
}

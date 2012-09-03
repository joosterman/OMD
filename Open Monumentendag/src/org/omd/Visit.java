package org.omd;

import java.util.Date;

import javax.persistence.Id;
import javax.persistence.PrePersist;

public class Visit {
	@Id
	public Long id;
	public Long userID;
	public Long locationID;
	public Date date;
	public Boolean visited;

	@PrePersist
	void onPersist() {
		date = new Date();
	}

}

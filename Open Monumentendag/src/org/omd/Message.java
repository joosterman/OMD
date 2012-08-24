package org.omd;

import java.util.Date;
import javax.persistence.Id;
import javax.persistence.PrePersist;

public class Message {
	@Id
	public Long id;
	public String content;
	public String author;
	public Date dateCreated;
	public Date validUntil;
	public String importance;
	public String email;
	
	@PrePersist void onPersist() { 
		dateCreated = new Date();
	}
}

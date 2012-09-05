package org.omd;

import javax.persistence.Id;

public class Link {

	@Id
	public Long id;
	public Long locationID;
	public String linkText;
	public String linkURL;
	public String linkDescription;
}

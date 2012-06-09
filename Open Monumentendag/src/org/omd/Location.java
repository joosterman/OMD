package org.omd;

import java.util.Date;

import javax.persistence.Id;

import com.google.appengine.api.blobstore.BlobKey;

public class Location {

	@Id
	public Long id;
	public String name;
	public String latitude;
	public String longitude;
	public String city = "Delft";
	public String street;
	public String streetNumber;
	public String imageBlobKey;
	public Date lastChanged;

	public static boolean isTextField(String fieldName) {
		if ("id".equals(fieldName) || "imageBlobKey".equals(fieldName) || "lastChanged".equals(fieldName))
			return false;
		else
			return true;
	}

	public Location() {
	};

	public Location(String name) {
		this.name = name;
	}

	@Override
	public String toString() {
		return name;
	}
}

package org.omd;

import java.util.Date;

import javax.persistence.Id;

import org.omd.UserField.FieldType;

import com.google.appengine.api.blobstore.BlobKey;

public class Location {

	@Id
	public Long id;
	@UserField(fieldType=FieldType.radiobuttons)
	public boolean topLocation;
	@UserField
	public String number;
	@UserField
	public String name;
	@UserField(fieldType = FieldType.textarea)
	public String info;
	@UserField(fieldType = FieldType.textarea)
	public String description;
	@UserField
	public String openingHoursSaturday;
	@UserField
	public String openingHoursSunday;
	@UserField(fieldType=FieldType.radiobuttons)
	public boolean wheelchairFriendly;
	@UserField(fieldType=FieldType.radiobuttons)
	public boolean tourAvailable;
	@UserField
	public String city = "Delft";
	@UserField
	public String street;
	@UserField
	public String latitude;
	@UserField
	public String longitude;
	public BlobKey imageBlobKey;
	public Date lastChanged;

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

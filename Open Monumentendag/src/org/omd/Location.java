package org.omd;

import java.util.Date;

import javax.persistence.Id;

import org.omd.UserField.FieldType;

public class Location {

	@Id
	public Long id;
	@UserField
	public String number;
	@UserField
	public String name;
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
	public String streetNumber;
	@UserField
	public String latitude;
	@UserField
	public String longitude;
	public String imageBlobKey;
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

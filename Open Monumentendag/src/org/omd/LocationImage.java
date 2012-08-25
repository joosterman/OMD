package org.omd;

import java.util.Date;

import javax.persistence.Id;
import javax.persistence.PrePersist;

import org.omd.UserField.FieldType;

import com.google.appengine.api.blobstore.BlobKey;

public class LocationImage {

	@Id
	public Long id;
	public Long locationID;
	//@Transient
	public BlobKey imageBlobKey;
	@UserField
	public String filename;
	public boolean primary = false;
	@UserField(fieldType=FieldType.textarea)
	public String description;
	public String imageURL;
	public Date date;
	
	public LocationImage(){}
	
	public LocationImage(String filename){
		this.filename = filename;
	}
	
	@Override
	public String toString(){
		return filename;
	}
	
	@PrePersist void onPersist() { 
		date = new Date();
	}
}

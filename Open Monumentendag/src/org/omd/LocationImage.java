package org.omd;

import javax.persistence.Id;
import javax.persistence.Transient;

import org.omd.UserField.FieldType;

import com.google.appengine.api.blobstore.BlobKey;
import com.google.appengine.api.images.ServingUrlOptions;

public class LocationImage {

	@Id
	public Long id;
	public Long locationID;
	@Transient
	public BlobKey imageBlobKey;
	@UserField
	public String filename;
	public boolean primary = false;
	@UserField
	public double cropLeftX;
	@UserField
	public double cropTopY;
	@UserField
	public double cropRightX;
	@UserField
	public double cropBottomY;
	@UserField(fieldType=FieldType.textarea)
	public String description;
	public String thumbnailURL;
	public String imageURL;
	
	public LocationImage(){}
	
	public LocationImage(String filename){
		this.filename = filename;
	}
	
	@Override
	public String toString(){
		return filename;
	}
}

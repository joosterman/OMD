/*
 * $Id: HolderOfStringAndLong.java 319 2010-02-09 02:33:41Z lhoriman $
 * $URL: https://objectify-appengine.googlecode.com/svn/trunk/src/com/googlecode/objectify/test/entity/HolderOfStringAndLong.java $
 */

package com.googlecode.objectify.test.entity;

import com.googlecode.objectify.annotation.Cached;


/**
 * A holder of a string, and a Long.
 * 
 * @author Scott Hernandez
 */
@Cached
public class HolderOfStringAndLong extends HolderOfString
{
	protected Long myPrecious;
	
	/** Default constructor must always exist */
	public HolderOfStringAndLong() {}

	public HolderOfStringAndLong(String s, Long l) {super(s); this.myPrecious = l; }

	public Long getMyPrecious()
	{
		return this.myPrecious;
	}
}
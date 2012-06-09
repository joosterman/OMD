/*
 * $Id: Banana.java 319 2010-02-09 02:33:41Z lhoriman $
 * $URL: https://objectify-appengine.googlecode.com/svn/trunk/src/com/googlecode/objectify/test/entity/Banana.java $
 */

package com.googlecode.objectify.test.entity;

import com.googlecode.objectify.annotation.Cached;


/**
 * A banana fruit.
 * 
 * @author Scott Hernandez
 */
@Cached
public class Banana extends Fruit
{
	public static final String COLOR = "yellow";
	public static final String TASTE = "sweet";
	
	private String shape;
	
	/** Default constructor must always exist */
	public Banana() {}
	
	/** Constructor*/
	public Banana(String color, String taste)
	{
		super(color,taste);
		this.shape = "like a banana";
	}
	
	public String getShape() 
	{
		return this.shape;
	}
}
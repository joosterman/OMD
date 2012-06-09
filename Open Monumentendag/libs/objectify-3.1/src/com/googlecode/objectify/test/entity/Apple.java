/*
 * $Id: Apple.java 319 2010-02-09 02:33:41Z lhoriman $
 * $URL: https://objectify-appengine.googlecode.com/svn/trunk/src/com/googlecode/objectify/test/entity/Apple.java $
 */

package com.googlecode.objectify.test.entity;

import com.googlecode.objectify.annotation.Cached;


/**
 * A fruit, an apple.
 * 
 * @author Scott Hernandez
 */
@Cached
public class Apple extends Fruit
{
	public static final String COLOR = "red";
	public static final String TASTE = "sweet";
	
	private String size;
	
	/** Default constructor must always exist */
	public Apple() {}
	
	/** Constructor*/
	public Apple(String color, String taste)
	{
		super(color,taste);
		this.size = "small";
	}
	
	public String getSize() 
	{
		return this.size;
	}
}
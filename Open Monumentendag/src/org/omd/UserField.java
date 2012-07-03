package org.omd;

import java.lang.annotation.Retention;
import java.lang.annotation.RetentionPolicy;

@Retention(RetentionPolicy.RUNTIME)
public @interface UserField{
	public enum FieldType  {textbox,textarea,radiobuttons};
	public FieldType fieldType() default FieldType.textbox; 		
}

package org.omd;

import java.util.Comparator;

public class LocationsSort implements Comparator<Location>  {

	@Override
	public int compare(Location o1, Location o2) {
		// check special location (no number)
				boolean o1letter = o1.number.trim().equals("S") || o1.number.trim().equals("D");
				boolean o2letter = o2.number.trim().equals("S") || o2.number.trim().equals("D");
				if (o1letter && !o2letter)
					return -1;
				else if (!o1letter && o2letter)
					return 1;
				else if (o1letter && o2letter)
					//intentional reverse sort
					return o2.name.compareTo(o1.name);
				else {
					// check top location vs normal location
					if (o1.topLocation && !o2.topLocation)
						return -1;
					else if (!o1.topLocation && o2.topLocation)
						return 1;
					else {
						try {
							int nr1 = Integer.valueOf(o1.number);
							int nr2 = Integer.valueOf(o2.number);
							if(nr1<nr2)
								return -1;
							else if(nr1>nr2)
								return 1;
							else
								return 0;
						}
						catch (NumberFormatException ex) {
							return 0;
						}
					}
				}

	}
	
}

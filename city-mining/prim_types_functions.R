# List of primary types

property <- c("ARSON", "BURGLARY", "CRIMINAL DAMAGE", "CRIMINAL TRESPASS", "MOTOR VEHICLE THEFT", "THEFT")
violent <- c("ASSAULT", "BATTERY", "CRIM SEXUAL ASSAULT", "DOMESTIC VIOLENCE", "HOMICIDE", "HUMAN TRAFFICKING", "INTIMIDATION", "KIDNAPPING", "ROBBERY", "SEX OFFENSE", "STALKING", "WEAPONS VIOLATION")
other <- c("CONCEALED CARRY LICENSE VIOLATION", "DECEPTIVE PRACTICE", "GAMBLING", "INTERFERENCE WITH PUBLIC OFFICER", "LIQUOR LAW VIOLATION", "NARCOTICS", "NON-CRIMINAL", "OBSCENITY", "OFFENSE INVOLVING CHILDREN", "OTHER NARCOTIC VIOLATION",  "OTHER OFFENSE", "PROSTITUTION", "PUBLIC INDECENCY", "PUBLIC PEACE VIOLATION", "RITUALISM")

find_prim_type <- function(a){
	return (ifelse(a %in% property, "PROPERTY", ifelse(a %in% violent, "VIOLENT", "OTHER")))
}

find_new_prim_type <- function(df){
	list <- c(unique(df$Primary.Type))
	new <- c()
	for (a in list) {
		if ( a %in% property | a %in% violent | a %in% other ) {}
		else { new <- c(new, a) }
	}
	return (new)
}

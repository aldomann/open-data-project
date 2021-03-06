# Functions classify the Primary Type of crime data (UCR)
# Authors: Cristian Estany <cresbabellpuig@gmail.com>
#          Alfredo Hernández <aldomann.designs@gmail.com>
#          Alejandro Jiménez <aljrico@gmail.com>

# Finished Cities: Chicago, Detroit, San Francisco,
#                  Seattle, Honolulu, Baltimore,
#                  Washington, Philadelphia, New York City,
#                  Atlanta, Minneapolis, Austin,
#                  Dallas, Portland, Los Angeles


# Start Propert --------------------------------------------
property <- c(
	"AGRICULTURE & MRKTS LAW-UNCLASSIFIED",
	"ALL OTHER LARCENY",
	"ARSON",
	"ATTEMPTED ROBBERY",
	"AUTO RECOVERIES",
	"AUTO THEFT",
	"AUTO THEFTS",
	"BAD CHECKS",
	"BIKE - ATTEMPTED STOLEN",
	"BIKE - STOLEN",
	"BIKE THEFT",
	"BOAT - STOLEN",
	"BUNCO, ATTEMPT",
	"BUNCO, GRAND THEFT",
	"BUNCO, PETTY THEFT",
	"BURGLAR'S TOOLS",
	"BURGLARY /",
	"BURGLARY FROM VEHICLE",
	"BURGLARY FROM VEHICLE, ATTEMPTED",
	"BURGLARY NON-RESIDENTIAL",
	"BURGLARY OF BUSINESS",
	"BURGLARY OF DWELLING",
	"BURGLARY RESIDENTIAL",
	"BURGLARY",
	"BURGLARY, ATTEMPTED",
	"BURGLARY-BUSINESS" ,
	"BURGLARY-NONRES",
	"BURGLARY-RESIDENCE",
	"COMMERCIAL BURGLARIES",
	"COUNTERFEIT",
	"COUNTERFEITING/FORGERY",
	"CREDIT CARD/ATM FRAUD",
	"CREDIT CARDS, FRAUD USE ($950 & UNDER",
	"CREDIT CARDS, FRAUD USE ($950.01 & OVER)",
	"CRIMINAL DAMAGE",
	"CRIMINAL MISCHIEF/VANDALI" ,
	"CRIMINAL TRESPASS",
	"DAMAGE TO PROPERTY",
	"DEFRAUDING INNKEEPER/THEFT OF SERVICES, $400 & UNDER",
	"DEFRAUDING INNKEEPER/THEFT OF SERVICES, OVER $400",
	"DISHONEST EMPLOYEE - GRAND THEFT",
	"DISHONEST EMPLOYEE - PETTY THEFT",
	"DISHONEST EMPLOYEE ATTEMPTED THEFT",
	"DISRUPT SCHOOL",
	"DISTURBING THE PEACE",
	"DOCUMENT FORGERY / STOLEN FELONY",
	"DOCUMENT WORTHLESS ($200 & UNDER)",
	"DOCUMENT WORTHLESS ($200.01 & OVER)",
	"DRIVING WITHOUT OWNER CONSENT (DWOC)",
	"EMBEZZLEMENT",
	"EMBEZZLEMENT, GRAND THEFT ($950.01 & OVER)",
	"EMBEZZLEMENT, PETTY THEFT ($950 & UNDER)",
	"ENVIRONMENT",
	"FORGE & COUNTERFEIT" ,
	"FORGERY AND COUNTERFEITING",
	"FORGERY",
	"FORGERY/COUNTERFEITING",
	"FRAUD CALLS",
	"FRAUD",
	"FRAUDS",
	"FRAUDULENT ACCOSTING",
	"GAS STATION DRIV-OFF",
	"GRAND LARCENY OF MOTOR VEHICLE",
	"GRAND LARCENY",
	"GRAND THEFT / AUTO REPAIR",
	"GRAND THEFT / INSURANCE FRAUD",
	"HACKING/COMPUTER INVASION",
	"IDENTITY THEFT",
	"IMPERSONATION",
	"LARCENY FROM AUTO",
	"LARCENY",
	"LARCENY-FROM VEHICLE",
	"LARCENY-NON VEHICLE",
	"LARCENY/THEFT",
	"LOOTING",
	"MOTOR VEHICLE THEFT",
	"OFFENSES INVOLVING FRAUD",
	"ON-LINE THEFT",
	"OTHER BURGLARY",
	"OTHER OFFENSES RELATED TO THEF",
	"OTHER THEFTS",
	"PETIT LARCENY OF MOTOR VEHICLE",
	"PETIT LARCENY",
	"PETTY THEFT - AUTO REPAIR",
	"PICKPOCKET",
	"PICKPOCKET, ATTEMPT",
	"POSSESSION OF STOLEN PROPERTY",
	"PROPERTY - MISSING, FOUND",
	"PROPERTY DAMAGE",
	"PURSE SNATCHING - ATTEMPT",
	"PURSE SNATCHING",
	"PURSE-SNATCHING",
	"RECEIVING STOLEN PROPERTY",
	"RECOVERED STOLEN MOTOR VEHICLE",
	"RECOVERED VEHICLE",
	"RESIDENTIAL BURGLARIES",
	"ROBBERY OF BUSINESS",
	"ROBBERY OF PERSON",
	"ROBBERY-BUSINESS",
	"ROBBERY-INDIVIDUAL",
	"SCRAPPING-RECYCLING THEFT",
	"SHOPLIFTING - ATTEMPT",
	"SHOPLIFTING - PETTY THEFT ($950 & UNDER)",
	"SHOPLIFTING",
	"SHOPLIFTING-GRAND THEFT ($950.01 & OVER)",
	"STOLEN PROPERTY OFFENSES",
	"STOLEN PROPERTY",
	"STOLEN VEHICLE",
	"TELEPHONE PROPERTY - DAMAGE",
	"THEFT BY COMPUTER",
	"THEFT BY SWINDLE",
	"THEFT F/AUTO",
	"THEFT FROM BUILDING",
	"THEFT FROM COIN-OPERATED MACHINE OR DEVICE",
	"THEFT FROM MOTOR VEHICLE - ATTEMPT",
	"THEFT FROM MOTOR VEHICLE - GRAND ($400 AND OVER)",
	"THEFT FROM MOTOR VEHICLE - PETTY ($950 & UNDER)",
	"THEFT FROM MOTOR VEHICLE",
	"THEFT FROM MOTR VEHC",
	"THEFT FROM PERSON - ATTEMPT",
	"THEFT FROM PERSON",
	"THEFT FROM VEHICLE",
	"THEFT OF IDENTITY",
	"THEFT OF MOTOR VEHICLE PARTS OR ACCESSORIES",
	"THEFT OF SERVICES",
	"THEFT ORG RETAIL",
	"THEFT PLAIN - ATTEMPT",
	"THEFT PLAIN - PETTY ($950 & UNDER)",
	"THEFT",
	"THEFT, COIN MACHINE - ATTEMPT",
	"THEFT, COIN MACHINE - GRAND ($950.01 & OVER)",
	"THEFT, COIN MACHINE - PETTY ($950 & UNDER)",
	"THEFT, PERSON",
	"THEFT-FRAUD",
	"THEFT-GRAND ($950.01 & OVER)EXCPT,GUNS,FOWL,LIVESTK,PROD0036",
	"THEFT-MOTR VEH PARTS",
	"THEFT/BMV" ,
	"THEFT/COINOP DEVICE",
	"THEFT/LARCENY",
	"THEFT/OTHER",
	"THEFT/SHOPLIFT" ,
	"THEFT: ALL OTHER LARCENY",
	"THEFT: AUTO PARTS",
	"THEFT: BOV",
	"THEFT: COIN OP MACHINE",
	"THEFT: FROM BUILDING",
	"THEFT: POCKET PICKING",
	"THEFT: PURSE SNATCHING",
	"THEFT: SHOPLIFTING",
	"THEFTS",
	"TILL TAP - ATTEMPT",
	"TILL TAP - GRAND THEFT ($950.01 & OVER)",
	"TILL TAP - PETTY ($950 & UNDER)",
	"TRAIN WRECKING",
	"TREA",
	"TRESPASS",
	"TRESPASSING",
	"UNAUTHORIZED COMPUTER ACCESS",
	"UNAUTHORIZED USE OF A VEHICLE",
	"UUMV",
	"VANDALISM - FELONY ($400 & OVER, ALL CHURCH VANDALISMS) 0114",
	"VANDALISM - MISDEAMEANOR ($399 OR UNDER)",
	"VANDALISM",
	"VEHICLE - ATTEMPT STOLEN",
	"VEHICLE - STOLEN",
	"VEHICLE BREAK-IN/THEFT",
	"VEHICLE THEFT",
	"WELFARE FRAUD",
	"WIRE FRAUD"
)

# End Property -----

# Start Violent --------------------------------------------
violent <- c(
	"1ST DEG DOMES ASSLT",
	"2ND DEG DOMES ASLT",
	"3RD DEG DOMES ASLT",
	"ADULTERATION/POISON",
	"AGG ASSAULT - NFV" ,
	"AGG ASSAULT",
	"AGG. ASSAULT",
	"AGGRAVATED ASSAULT FIREARM",
	"AGGRAVATED ASSAULT NO FIREARM",
	"AGGRAVATED ASSAULT",
	"ANIMAL BITE",
	"ANIMAL CRUELTY",
	"ASLT-GREAT BODILY HM",
	"ASLT-POLICE/EMERG P",
	"ASLT-SGNFCNT BDLY HM",
	"ASSAULT 3 & RELATED OFFENSES",
	"ASSAULT BY THREAT",
	"ASSAULT W/DANGEROUS WEAPON",
	"ASSAULT WITH DEADLY WEAPON ON POLICE OFFICER",
	"ASSAULT WITH DEADLY WEAPON, AGGRAVATED ASSAULT",
	"ASSAULT",
	"ASSAULTS",
	"ASSLT W/DNGRS WEAPON",
	"BATTERY - SIMPLE ASSAULT",
	"BATTERY ON A FIREFIGHTER",
	"BATTERY POLICE (SIMPLE)",
	"BATTERY WITH SEXUAL CONTACT",
	"BATTERY",
	"BEASTIALITY, CRIME AGAINST NATURE SEXUAL ASSLT WITH ANIM0065",
	"BOMB SCARE",
	"BRANDISH WEAPON",
	"CAR PROWL",
	"CASUALTIES",
	"CHILD ABUSE (PHYSICAL) - AGGRAVATED ASSAULT",
	"CHILD ABUSE (PHYSICAL) - SIMPLE ASSAULT",
	"CHILD ANNOYING (17YRS & UNDER)",
	"CHILD NEGLECT (SEE 300 W.I.C.)",
	"CHILD STEALING",
	"COMMON ASSAULT",
	"CRIM SEX COND-RAPE",
	"CRIM SEXUAL ASSAULT",
	"CRIMINAL HOMICIDE",
	"CRIMINAL THREATS - NO WEAPON DISPLAYED",
	"CRM AGNST CHLD (13 OR UNDER) (14-15 & SUSP 10 YRS OLDER)0060",
	"CRUELTY TO ANIMALS",
	"DISARM A POLICE OFFICER",
	"DISCHARGE FIREARMS/SHOTS FIRED",
	"DISORDERLY CONDUCT",
	"DISTURBANCES",
	"DOMESTIC ASSAULT/STRANGULATION",
	"DOMESTIC VIOLENCE",
	"EXTORTION",
	"EXTORTION/BLACKMAIL",
	"FAMILY OFFENSE",
	"FAMILY OFFENSES",
	"FELONY ASSAULT",
	"GUN CALLS",
	"HARRASSMENT 2",
	"HAZARDS",
	"HOMICIDE - CRIMINAL",
	"HOMICIDE - GROSS NEGLIGENCE",
	"HOMICIDE - JUSTIFIABLE",
	"HOMICIDE",
	"HOMICIDE-NEGLIGENT,UNCLASSIFIE",
	"HOMICIDE-NEGLIGENT-VEHICLE",
	"HOMICIDE: MURDER & NONNEGLIGENT MANSLAUGHTER",
	"HUMAN TRAFFICKING",
	"INJURED FIREARM" ,
	"INJURED HOME",
	"INJURED OCCUPA",
	"INJURED PUBLIC",
	"INTIMATE PARTNER - AGGRAVATED ASSAULT",
	"INTIMATE PARTNER - SIMPLE ASSAULT",
	"INTIMIDATION",
	"INTOXICATION MANSLAUGHTER",
	"INVOLUNTARY SERVITUDE",
	"JOSTLING",
	"JUSTIFIABLE HOMICIDE",
	"KIDNAPING",
	"KIDNAPPING & RELATED OFFENSES",
	"KIDNAPPING - GRAND ATTEMPT",
	"KIDNAPPING AND RELATED OFFENSES",
	"KIDNAPPING",
	"KIDNAPPING/ABDUCTION",
	"LANDALISM & CRIM MISCHIEF" ,
	"LETTERS, LEWD",
	"LEWD CONDUCT",
	"LOITERING",
	"LYNCHING - ATTEMPTED",
	"LYNCHING",
	"MANSLAUGHTER, NEGLIGENT",
	"MURDER & NON-NEGL. MANSLAUGHTER",
	"MURDER (GENERAL)",
	"MURDER AND NON-NEGLIGENT MANSLAUGHTER",
	"MURDER",
	"MURDER/INFORMATION",
	"NEGLIGENT HOMICIDE",
	"NEGLIGENT MANSLAUGHTER",
	"NUISANCE, MISCHIEF COMPLAINTS",
	"OFFENSE AGAINST CHILD",
	"OFFENSES AGAINST FAMILY AND CHILDREN",
	"OFFENSES RELATED TO CHILDREN",
	"OTHER ASSAULT",
	"OTHER ASSAULTS",
	"OTHER THEFT",
	"OTHER VEHICLE THEFT",
	"POCKET-PICKING",
	"PROWLER",
	"RAPE",
	"RAPE, ATTEMPTED",
	"RAPE, FORCIBLE",
	"RECKLESS BURNING",
	"RECKLESS DRIVING",
	"RESIST ARREST" ,
	"RESISTING ARREST",
	"ROBBERY - CARJACKING",
	"ROBBERY - COMMERCIAL",
	"ROBBERY - RESIDENCE",
	"ROBBERY - STREET",
	"ROBBERY FIREARM",
	"ROBBERY NO FIREARM",
	"ROBBERY PER AGG",
	"ROBBERY",
	"ROBBERY-COMMERCIAL",
	"ROBBERY-PEDESTRIAN",
	"ROBBERY-RESIDENCE",
	"SEX ABUSE",
	"SEX OFFENSE (NO RAPE)",
	"SEX OFFENSE",
	"SEX OFFENSES",
	"SEX OFFENSES, FORCIBLE",
	"SEX OFFENSES, NON FORCIBLE",
	"SEXUAL ASSAULT WITH AN OBJECT",
	"SEXUAL PENTRATION WITH A FOREIGN OBJECT",
	"SHOOTING",
	"SHOTS FIRED AT INHABITED DWELLING",
	"SHOTS FIRED AT MOVING VEHICLE, TRAIN OR AIRCRAFT",
	"SIMPLE ASSAULT",
	"STALKING",
	"STATUTORY RAPE",
	"TERRORISTIC THREAT",
	"THREATENING PHONE CALLS/LETTERS",
	"THREATS, HARASSMENT",
	"THROWING OBJECT AT MOVING VEHICLE",
	"TRAFFIC FATALITY" ,
	"VAGRANCY/LOITERING",
	"VANDALISM & CRIM MISCHIEF",
	"VANDALISM/CRIMINAL MISCHIEF",
	"VICE CALLS",
	"WEAPONS CALLS",
	"WEAPONS VIOLATION"
)
# End Violent ----

# Start Other ----------------------------------------------
other <- c(
	" ",
	"",
	"ABORTION",
	"ABORTION/ILLEGAL",
	"ACCIDENT MV" ,
	"ADMINISTRATIVE CODE",
	"ADMINISTRATIVE CODES",
	"ALCOHOLIC BEVERAGE CONTROL LAW",
	"ALL OTHER OFFENSES",
	"ANIMAL COMPLAINTS",
	"ANTICIPATORY OFFENSES",
	"ASSISTING OR PROMOTING PROSTITUTION",
	"BIGAMY",
	"BLOCKING DOOR INDUCTION CENTER",
	"BRIBERY",
	"BURGLARY ALACAD (FALSE)",
	"BURGLARY ALARMS (FALSE)",
	"CHILD ABANDONMENT",
	"CHILD ABANDONMENT/NON SUPPORT",
	"CIVIL",
	"COMMERCIAL SEX ACTS",
	"CONCEALED CARRY LICENSE VIOLATION",
	"CONSPIRACY",
	"CONTEMPT OF COURT",
	"CONTRIBUTING",
	"CRIMINAL MISCHIEF & RELATED OF",
	"CRISIS CALL",
	"DANGEROUS DRUGS",
	"DANGEROUS WEAPONS",
	"DECEPTIVE PRACTICE",
	"DISRUPTION OF A RELIGIOUS SERV",
	"DRIVING UNDER THE INFLUENCE",
	"DRUG EQUIPMENT VIOLATIONS",
	"DRUG/NARCOTIC VIOLATIONS",
	"DRUG/NARCOTIC",
	"DRUGS, TO A MINOR",
	"DRUNK ROLL - ATTEMPT",
	"DRUNK ROLL",
	"DRUNKENNESS",
	"DWI",
	"ENDAN WELFARE INCOMP",
	"ESCAPE 3",
	"ESCAPE" ,
	"EVADING" ,
	"FAILURE TO DISPERSE",
	"FAILURE TO YIELD",
	"FALSE IMPRISONMENT",
	"FALSE POLICE REPORT",
	"FALSE PRETENSES/SWINDLE/CONFIDENCE GAME",
	"FIREARMS RESTRAINING ORDER (FIREARMS RO)",
	"FONDLING",
	"FORTUNE TELLING",
	"FOUND" ,
	"GAMBLING VIOLATIONS",
	"GAMBLING",
	"HARBOR CALLS",
	"ILLEGAL DUMPING",
	"IMMIGRATION",
	"INCEST (SEXUAL ACTS BETWEEN BLOOD RELATIVES)",
	"INCEST",
	"INCITING A RIOT",
	"INDECENT EXPOSURE",
	"INTERFERENCE WITH PUBLIC OFFICER",
	"INTOXICATED/IMPAIRED DRIVING",
	"LIQUOR LAW VIOLATION",
	"LIQUOR LAW VIOLATIONS",
	"LIQUOR LAWS",
	"LIQUOR OFFENSE" ,
	"LIQUOR VIOLATIONS",
	"LIQUOR",
	"LOITERING FOR DRUG PURPOSES",
	"LOITERING/GAMBLING (CARDS, DIC",
	"LOST",
	"MENTAL CALL",
	"MILITARY",
	"MISCELLANEOUS ARREST",
	"MISCELLANEOUS MISDEMEANORS",
	"MISCELLANEOUS PENAL LAW",
	"MISCELLANEOUS",
	"MISSING PERSON",
	"MOTOR VEHICLE ACCIDENT",
	"NARCOTIC / DRUG LAW VIOLATIONS",
	"NARCOTICS & DRUGS" ,
	"NARCOTICS COMPLAINTS",
	"NARCOTICS",
	"NEW YORK CITY HEALTH CODE",
	"NOISE DISTURBANCE",
	"NON-CRIMINAL",
	"NULL",
	"NYS LAWS-UNCLASSIFIED FELONY",
	"NYS LAWS-UNCLASSIFIED VIOLATION",
	"OBSCENITY",
	"OBSTRUCTING JUDICIARY",
	"OBSTRUCTING THE POLICE",
	"OFF. AGNST PUB ORD SENSBLTY &",
	"OFFENSE INVOLVING CHILDREN",
	"OFFENSES AGAINST PUBLIC ADMINI",
	"OFFENSES AGAINST PUBLIC SAFETY",
	"OFFENSES AGAINST THE PERSON",
	"ORAL COPULATION",
	"ORANIZED CRIME",
	"OTHER MISCELLANEOUS CRIME",
	"OTHER NARCOTIC VIOLATION",  "OTHER OFFENSE",
	"OTHER OFFENSES",
	"OTHER SEX OFFENSES (NOT COMMERCIALIZED)",
	"OTHER STATE LAWS (NON PENAL LA",
	"OTHER STATE LAWS (NON PENAL LAW)",
	"OTHER STATE LAWS",
	"OTHER TRAFFIC INFRACTION",
	"OTHER",
	"OTHERS",
	"OUIL",
	"PANDERING",
	"PANIC ALACAD (FALSE)",
	"PANIC ALARMS (FALSE)",
	"PARKING VIOLATIONS",
	"PARKS EXCLUSIONS",
	"PEEPING TOM",
	"PERSONS - LOST, FOUND, MISSING",
	"PIMPING",
	"PORNOGRAPHY/OBSCENE MAT",
	"PORNOGRAPHY/OBSCENE MATERIAL",
	"PROSTITUTION & RELATED OFFENSES",
	"PROSTITUTION AND COMMERCIALIZED VICE","INTOXICATED & IMPAIRED DRIVING",
	"PROSTITUTION",
	"PUBLIC DRUNKENNESS",
	"PUBLIC GATHERINGS",
	"PUBLIC INDECENCY",
	"PUBLIC PEACE VIOLATION",
	"PURCHASING PROSTITUTION",
	"REPLICA FIREARMS(SALE,DISPLAY,MANUFACTURE OR DISTRIBUTE)0132",
	"RITUALISM",
	"RUNAWAY",
	"SECONDARY CODES",
	"SEX CRIMES",
	"SEX, UNLAWFUL",
	"SODOMY",
	"SODOMY/SEXUAL CONTACT B/W PENIS OF ONE PERS TO ANUS OTH 0007=02",
	"SOLICITATION",
	"SUDDEN DEATH&FOUND BODIES" ,
	"SUICIDE",
	"SUSPICIOUS CIRCUMSTANCES",
	"SUSPICIOUS OCC",
	"TRAFFIC OFFENSES",
	"TRAFFIC RELATED CALLS",
	"TRAFFIC VIOLATION" ,
	"TRAFFIC",
	"UNDER THE INFLUENCE OF DRUGS",
	"UNLAWFUL POSS. WEAP. ON SCHOOL",
	"VAGRANCY (OTHER)",
	"VEHICLE ALACAD (FALSE)",
	"VEHICLE ALARMS (FALSE)",
	"VEHICLE AND TRAFFIC LAWS",
	"VIOLATION OF COURT ORDER",
	"VIOLATION OF RESTRAINING ORDER",
	"VIOLATION OF TEMPORARY RESTRAINING ORDER",
	"WARRANT CALLS",
	"WARRANTS",
	"WEAPON LAWS",
	"WEAPON VIOLATIONS",
	"WEAPONS LAW VIOLATIONS",
	"WEAPONS OFFENSES",
	"WEAPONS POSSESSION/BOMBING",
	"WEAPONS"
)

# End Other ----


# Functions ------------------------------------------------

# Classify primary type into Categories
find_prim_type <- function(a){
	return (ifelse(toupper(a) %in% toupper(property), "PROPERTY",
								 ifelse(toupper(a) %in% toupper(violent), "VIOLENT",
												"OTHER")))
}

# List non-classified primary types
find_new_prim_type <- function(df){
	list <- c(unique(toupper(df$Primary.Type)))
	new <- c()
	for (a in list) {
		if ( a %in% toupper(property) | a %in% toupper(violent) | a %in% toupper(other) ) {}
		else { new <- c(new, a) }
	}
	return (new)
}

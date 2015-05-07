;This is a sample TNC initialisation file for use with
;the Kenwood TM-D710.
;TM-D710.ORG will allow you to revert to the default
;version of this file, if you edit it and mess it up!
;
;KI4LAX - Kevin Wnuk
;LA3QMA - Kai Gunter Brandt

[SETUP]
;DON'T alter anything in this section unless you are
;sure you know what you are doing!
COMMAND_PROMPT=cmd:
COMMAND_CHARACTER_CODE=3
ESCAPE_CHARACTER_CODE=
CONV_COMMAND=CONV
MYCALL_COMMAND="MYCALL "
UNPROTO_COMMAND="UNPROTO "
NO_BEACON_COMMAND=BEACON EVERY 0

[INIT_COMMANDS]
;Added by LN - Supposedly need three ctl-c to get into command mode
^C
^C
^C
;LN - TC Undocumented as far as I can tell. For 700, it's enabling control mode.
TC 1
;Enable TNC on band A
TN 2,0
;Use TN 2,1 for band B
;Use TN 2,2 for A=TX and B=RX
;Use TN 2,3 for A=RX and B=TX
;Special cmd for driver ^W<seconds to wait 0-9>
;Allows time for the TN command to execute
^W5
;ECHO or E
;values OFF/ON
;default ON
E OFF
;DIGIPEAT or DIG
;values OFF/ON
;default ON
DIG OFF
;GBAUD or GB baud rate of the GPS hooked up to the radio,
;values 2400/4800/9600
;default 4800
GB 9600
;HBAUD or HB TNC baud rate
;values 1200/9600
;default 1200
HB 1200
;GPSTEXT or GPST
;values $GPRMC/$GPGGA/$PNTS
;others may work haven't tried them
;default $PNTS
GPST $GPRMC
;LTMMON or LTM
;Specifies the interval for displaying a message
;determined by LTEXT on the screen 1 second intervals
;values 0-250
;default is 0 or off.
LTM 10
;LTMHEAD or LTMH
;values OFF/ON
;default is ON
LTMH ON
;LOCATION or LOC method of sending GPS Data
;10 second intervals
;parameters EVERY or E, AFTER or A
;values 0-250
;default 0 or off
LOC E 0
;MONITOR or M monitor packets
;values OFF/ON
;default ON
M ON
;MCOM moniter control packets
;values OFF/ON
;default OFF
MCOM ON
;MSTAMP or MS display data and time info for packets
;values ON/OFF
;default OFF
MS OFF
;CONOK or CONO accept request and return UA packet
;values ON/OFF
;default ON
CONO OFF
;PACLEN or P max length of data
;values 0-255
;default 128
P 250
;UIDIGI or UI
;values OFF/ON CALL1,...,CALL14
;default OFF
UI OFF
;UIFLOOD OR UIF
;values ID/NOID/FIRST
;default NOID
UIF NOID
;UITRACE or UIT
;values 5 alphanumeric characters
;default
UIT %
;XFLOW or X software flow contorl
;values OFF/ON
;default ON
X OFF
;HEADERLN or HE
;values OFF/ON
;default OFF
HEADER OFF
;NEWMODE or NE
;values OFF/ON
;default OFF
NE ON
;NOMODE or NO
;values OFF/ON
;default OFF
NO OFF

[EXIT_COMMANDS]
LTM 0
*---------------------------------------------------------------------*
*    view related data declarations
*---------------------------------------------------------------------*
*...processing: ZVSA0104........................................*
TABLES: ZVSA0104, *ZVSA0104. "view work areas
CONTROLS: TCTRL_ZVSA0104
TYPE TABLEVIEW USING SCREEN '0020'.
DATA: BEGIN OF STATUS_ZVSA0104. "state vector
          INCLUDE STRUCTURE VIMSTATUS.
DATA: END OF STATUS_ZVSA0104.
* Table for entries selected to show on screen
DATA: BEGIN OF ZVSA0104_EXTRACT OCCURS 0010.
INCLUDE STRUCTURE ZVSA0104.
          INCLUDE STRUCTURE VIMFLAGTAB.
DATA: END OF ZVSA0104_EXTRACT.
* Table for all entries loaded from database
DATA: BEGIN OF ZVSA0104_TOTAL OCCURS 0010.
INCLUDE STRUCTURE ZVSA0104.
          INCLUDE STRUCTURE VIMFLAGTAB.
DATA: END OF ZVSA0104_TOTAL.

*...processing: ZVSA0199........................................*
TABLES: ZVSA0199, *ZVSA0199. "view work areas
CONTROLS: TCTRL_ZVSA0199
TYPE TABLEVIEW USING SCREEN '0040'.
DATA: BEGIN OF STATUS_ZVSA0199. "state vector
          INCLUDE STRUCTURE VIMSTATUS.
DATA: END OF STATUS_ZVSA0199.
* Table for entries selected to show on screen
DATA: BEGIN OF ZVSA0199_EXTRACT OCCURS 0010.
INCLUDE STRUCTURE ZVSA0199.
          INCLUDE STRUCTURE VIMFLAGTAB.
DATA: END OF ZVSA0199_EXTRACT.
* Table for all entries loaded from database
DATA: BEGIN OF ZVSA0199_TOTAL OCCURS 0010.
INCLUDE STRUCTURE ZVSA0199.
          INCLUDE STRUCTURE VIMFLAGTAB.
DATA: END OF ZVSA0199_TOTAL.

*...processing: ZVSA01PRO.......................................*
TABLES: ZVSA01PRO, *ZVSA01PRO. "view work areas
CONTROLS: TCTRL_ZVSA01PRO
TYPE TABLEVIEW USING SCREEN '0030'.
DATA: BEGIN OF STATUS_ZVSA01PRO. "state vector
          INCLUDE STRUCTURE VIMSTATUS.
DATA: END OF STATUS_ZVSA01PRO.
* Table for entries selected to show on screen
DATA: BEGIN OF ZVSA01PRO_EXTRACT OCCURS 0010.
INCLUDE STRUCTURE ZVSA01PRO.
          INCLUDE STRUCTURE VIMFLAGTAB.
DATA: END OF ZVSA01PRO_EXTRACT.
* Table for all entries loaded from database
DATA: BEGIN OF ZVSA01PRO_TOTAL OCCURS 0010.
INCLUDE STRUCTURE ZVSA01PRO.
          INCLUDE STRUCTURE VIMFLAGTAB.
DATA: END OF ZVSA01PRO_TOTAL.

*.........table declarations:.................................*
TABLES: ZTSA0102                       .
TABLES: ZTSA0102_T                     .
TABLES: ZTSA0199                       .
TABLES: ZTSA01PRO                      .
TABLES: ZTSA01PRO_T                    .

*---------------------------------------------------------------------*
*    view related data declarations
*---------------------------------------------------------------------*
*...processing: ZVSA01VEN.......................................*
TABLES: ZVSA01VEN, *ZVSA01VEN. "view work areas
CONTROLS: TCTRL_ZVSA01VEN
TYPE TABLEVIEW USING SCREEN '0010'.
DATA: BEGIN OF STATUS_ZVSA01VEN. "state vector
          INCLUDE STRUCTURE VIMSTATUS.
DATA: END OF STATUS_ZVSA01VEN.
* Table for entries selected to show on screen
DATA: BEGIN OF ZVSA01VEN_EXTRACT OCCURS 0010.
INCLUDE STRUCTURE ZVSA01VEN.
          INCLUDE STRUCTURE VIMFLAGTAB.
DATA: END OF ZVSA01VEN_EXTRACT.
* Table for all entries loaded from database
DATA: BEGIN OF ZVSA01VEN_TOTAL OCCURS 0010.
INCLUDE STRUCTURE ZVSA01VEN.
          INCLUDE STRUCTURE VIMFLAGTAB.
DATA: END OF ZVSA01VEN_TOTAL.

*.........table declarations:.................................*
TABLES: ZTSA01VEN                      .

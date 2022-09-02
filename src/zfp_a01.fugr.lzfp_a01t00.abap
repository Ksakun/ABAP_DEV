*---------------------------------------------------------------------*
*    view related data declarations
*---------------------------------------------------------------------*
*...processing: ZTSAPLANE_A01...................................*
DATA:  BEGIN OF STATUS_ZTSAPLANE_A01                 .   "state vector
         INCLUDE STRUCTURE VIMSTATUS.
DATA:  END OF STATUS_ZTSAPLANE_A01                 .
CONTROLS: TCTRL_ZTSAPLANE_A01
            TYPE TABLEVIEW USING SCREEN '0040'.
*...processing: ZTSCARR_A01.....................................*
DATA:  BEGIN OF STATUS_ZTSCARR_A01                   .   "state vector
         INCLUDE STRUCTURE VIMSTATUS.
DATA:  END OF STATUS_ZTSCARR_A01                   .
CONTROLS: TCTRL_ZTSCARR_A01
            TYPE TABLEVIEW USING SCREEN '0010'.
*...processing: ZTSFLIGHT_A01...................................*
DATA:  BEGIN OF STATUS_ZTSFLIGHT_A01                 .   "state vector
         INCLUDE STRUCTURE VIMSTATUS.
DATA:  END OF STATUS_ZTSFLIGHT_A01                 .
CONTROLS: TCTRL_ZTSFLIGHT_A01
            TYPE TABLEVIEW USING SCREEN '0030'.
*...processing: ZTSPFLI_A01.....................................*
DATA:  BEGIN OF STATUS_ZTSPFLI_A01                   .   "state vector
         INCLUDE STRUCTURE VIMSTATUS.
DATA:  END OF STATUS_ZTSPFLI_A01                   .
CONTROLS: TCTRL_ZTSPFLI_A01
            TYPE TABLEVIEW USING SCREEN '0020'.
*.........table declarations:.................................*
TABLES: *ZTSAPLANE_A01                 .
TABLES: *ZTSCARR_A01                   .
TABLES: *ZTSFLIGHT_A01                 .
TABLES: *ZTSPFLI_A01                   .
TABLES: ZTSAPLANE_A01                  .
TABLES: ZTSCARR_A01                    .
TABLES: ZTSFLIGHT_A01                  .
TABLES: ZTSPFLI_A01                    .

* general table data declarations..............
  INCLUDE LSVIMTDT                                .

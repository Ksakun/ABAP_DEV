*&---------------------------------------------------------------------*
*& Include BC405_SCREEN_S1B_TOP                                        *
*&---------------------------------------------------------------------*

* Workarea for data fetch
DATA: gs_flight TYPE dv_flights,
      gv_change.

TABLES sscrfields.

* Constant for CASE statement
CONSTANTS gc_mark VALUE 'X'.

* Selections for connections
SELECTION-SCREEN BEGIN OF SCREEN 1100 AS SUBSCREEN.
  SELECT-OPTIONS: so_car FOR gs_flight-carrid MEMORY ID car,
                  so_con FOR gs_flight-connid.
SELECTION-SCREEN END OF SCREEN 1100.

* Selections for flights
SELECTION-SCREEN BEGIN OF SCREEN 1200 AS SUBSCREEN.
  SELECT-OPTIONS so_fdt FOR gs_flight-fldate NO-EXTENSION.
SELECTION-SCREEN END OF SCREEN 1200.

* Output parameter
SELECTION-SCREEN BEGIN OF SCREEN 1300 AS SUBSCREEN.
  SELECTION-SCREEN BEGIN OF BLOCK radio WITH FRAME.
    PARAMETERS: pa_all RADIOBUTTON GROUP rbg1,
                pa_nat RADIOBUTTON GROUP rbg1,
                pa_int RADIOBUTTON GROUP rbg1 DEFAULT 'X'.
  SELECTION-SCREEN END OF BLOCK radio.
SELECTION-SCREEN END OF SCREEN 1300.

SELECTION-SCREEN BEGIN OF SCREEN 1400 AS SUBSCREEN.
  SELECT-OPTIONS: so_cfr FOR gs_flight-countryfr MODIF ID det,
                  so_cifr FOR gs_flight-cityfrom MODIF ID det.
  "한줄 띄어주기
  SELECTION-SCREEN SKIP 1.
  "Push Button
SELECTION-SCREEN PUSHBUTTON /pos_low(12) button USER-COMMAND on.
SELECTION-SCREEN END OF SCREEN 1400.

SELECTION-SCREEN BEGIN OF TABBED BLOCK airlines FOR 5 LINES.
  SELECTION-SCREEN TAB (20) tab1 USER-COMMAND conn "sy-ucomm = conn
    DEFAULT SCREEN 1100.
  SELECTION-SCREEN TAB (20) tab2 USER-COMMAND date
    DEFAULT SCREEN 1200.
  SELECTION-SCREEN TAB (20) tab3 USER-COMMAND type
    DEFAULT SCREEN 1300.
  SELECTION-SCREEN TAB (20) tab4 USER-COMMAND dest
    DEFAULT SCREEN 1400.

SELECTION-SCREEN END OF BLOCK airlines .

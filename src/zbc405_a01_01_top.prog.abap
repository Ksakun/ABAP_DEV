*&---------------------------------------------------------------------*
*& Include ZBC405_A01_01_TOP                        - Report ZBC405_A01_01
*&---------------------------------------------------------------------*
REPORT zbc405_a01_01.
DATA: gs_flight TYPE dv_flights,
      gt_flight LIKE TABLE OF dv_flights.


CONSTANTS mark VALUE 'X'.

SELECTION-SCREEN BEGIN OF SCREEN 101 AS SUBSCREEN.
  "Select option for airline
  SELECT-OPTIONS so_car FOR gs_flight-carrid MEMORY ID car.
  "Select options for flight conn
  SELECT-OPTIONS so_con FOR gs_flight-connid.

SELECTION-SCREEN END OF SCREEN 101.

SELECTION-SCREEN BEGIN OF SCREEN 102 AS SUBSCREEN.
  "Select options for flight date
  SELECT-OPTIONS so_dat FOR gs_flight-fldate NO-EXTENSION.
SELECTION-SCREEN END OF SCREEN 102.

SELECTION-SCREEN BEGIN OF SCREEN 103 AS SUBSCREEN.
  "Radio Button Group
  SELECTION-SCREEN BEGIN OF BLOCK radio WITH FRAME TITLE TEXT-001.
    PARAMETERS: pa_rdb1 RADIOBUTTON GROUP gr1, "Read ALl flights
                pa_rdb2 RADIOBUTTON GROUP gr1, "Reald only domestic
                pa_rdb3 RADIOBUTTON GROUP gr1  DEFAULT 'X'. "Read only international
  SELECTION-SCREEN END OF BLOCK radio.
SELECTION-SCREEN END OF SCREEN 103.

SELECTION-SCREEN BEGIN OF TABBED BLOCK tab FOR 6 LINES.
  SELECTION-SCREEN TAB (15) tab1 USER-COMMAND comm1 DEFAULT SCREEN 101.
  SELECTION-SCREEN TAB (15) tab2 USER-COMMAND comm2 DEFAULT SCREEN 102.
  SELECTION-SCREEN TAB (15) tab3 USER-COMMAND comm3 DEFAULT SCREEN 103.
 SELECTION-SCREEN END OF BLOCK tab.

*&---------------------------------------------------------------------*
*& Include ZRSA01_91_TOP                            - Report ZRSA01_91
*&---------------------------------------------------------------------*
REPORT zrsa01_91.

TABLES: ztsa0199, sscrfields.

DATA: ok_code TYPE sy-ucomm,
      gs_data TYPE zssa0192,
      gt_data LIKE TABLE OF gs_data,
      gv_name LIKE scarr-carrname.

CONSTANTS gc_mark VALUE 'X'.

"Selection-screen Radio Button In Block AS 1100

SELECTION-SCREEN BEGIN OF BLOCK radio WITH FRAME TITLE TEXT-001.

  PARAMETERS: pa_und RADIOBUTTON GROUP rdb DEFAULT 'X',
              pa_b2b RADIOBUTTON GROUP rdb,
              pa_b2c RADIOBUTTON GROUP rdb,
              pa_b2g RADIOBUTTON GROUP rdb.

SELECTION-SCREEN END OF BLOCK radio.

SELECTION-SCREEN SKIP 4.

"Selection-screen 2 Tabs 1: Carrid Condtion, 2: Meal Conditions.

SELECTION-SCREEN BEGIN OF SCREEN 1100 AS SUBSCREEN.
  PARAMETERS: pa_car TYPE scarr-carrid.


  SELECTION-SCREEN SKIP 1.
  SELECTION-SCREEN PUSHBUTTON /pos_low(10) button USER-COMMAND push.
SELECTION-SCREEN END OF SCREEN 1100.

SELECTION-SCREEN BEGIN OF SCREEN 1200 AS SUBSCREEN.
  SELECT-OPTIONS so_meal FOR ztsa0199-mealnumber.
SELECTION-SCREEN END OF SCREEN 1200.


SELECTION-SCREEN BEGIN OF TABBED BLOCK tab FOR 5 LINES.

  SELECTION-SCREEN TAB (15) tab1 USER-COMMAND comm1 DEFAULT SCREEN 1100.
  SELECTION-SCREEN TAB (15) tab2 USER-COMMAND comm2 DEFAULT SCREEN 1200.

SELECTION-SCREEN END OF BLOCK tab.

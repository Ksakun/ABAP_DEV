*&---------------------------------------------------------------------*
*& Include MZSA0190_TOP                             - Module Pool      SAPMZSA0190
*&---------------------------------------------------------------------*
PROGRAM SAPMZSA0190.

DATA ok_code TYPE sy-ucomm.


TABLES: zssa0190, "Condition
        zssa0191, "Flight Info
        zssa0192. "Vendor Info


"Tab Strip
CONTROLS ts_info TYPE TABSTRIP.
*CONTROLS tc_100  TYPE TABLEVIEW USING SCREEN 100. " Table Control

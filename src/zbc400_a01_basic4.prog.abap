*&---------------------------------------------------------------------*
*& Report ZBC400_A01_BASIC3
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zbc400_a01_basic4.

TABLES sbuspart.


SELECTION-SCREEN BEGIN OF BLOCK b1 WITH FRAME TITLE TEXT-001.

  PARAMETERS: pa_bus TYPE sbuspart-buspartnum OBLIGATORY.
  SELECT-OPTIONS so_con FOR sbuspart-contact NO INTERVALS.

SELECTION-SCREEN END OF BLOCK b1.

SELECTION-SCREEN SKIP 2.

SELECTION-SCREEN BEGIN OF BLOCK radio WITH FRAME TITLE TEXT-002.

  SELECTION-SCREEN BEGIN OF LINE.
    PARAMETERS: pa_rata RADIOBUTTON GROUP r1 DEFAULT 'X',
                pa_rafc RADIOBUTTON GROUP r1.
  SELECTION-SCREEN END OF LINE.
SELECTION-SCREEN END OF BLOCK radio.

DATA: gt_buspart TYPE TABLE OF sbuspart,
      gv_type    TYPE sbuspart-buspatyp.
CONSTANTS mark VALUE 'X'.

REFRESH gt_buspart.



START-OF-SELECTION.

  CASE mark.
    WHEN pa_rata.
      gv_type = 'TA'.
    WHEN pa_rafc.
      gv_type = 'FC'.
  ENDCASE.

  SELECT buspartnum contact contphono buspatyp
    FROM sbuspart
    INTO CORRESPONDING FIELDS OF TABLE gt_buspart
   WHERE buspartnum = pa_bus
     AND buspatyp   = gv_type
     AND contact   IN so_con.

  cl_demo_output=>display_data( gt_buspart ).
*  CASE mark.
*    WHEN pa_rata.
*      SELECT buspartnum contact contphono buspatyp
*        FROM sbuspart
*        INTO CORRESPONDING FIELDS OF TABLE gt_buspart
*       WHERE buspartnum = pa_bus
*         AND buspatyp   = 'TA'
*         AND contact   IN so_con.
*
*      cl_demo_output=>display_data( gt_buspart ).
*
*    WHEN pa_rafc.
*
*      SELECT buspartnum contact contphono buspatyp
*        FROM sbuspart
*        INTO CORRESPONDING FIELDS OF TABLE gt_buspart
*       WHERE buspartnum = pa_bus
*         AND buspatyp   = 'FC'
*         AND contact   IN so_con.
*
*      cl_demo_output=>display_data( gt_buspart ).
*
*  ENDCASE.

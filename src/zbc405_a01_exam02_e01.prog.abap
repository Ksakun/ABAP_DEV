*&---------------------------------------------------------------------*
*& Include          ZBC405_A01_EXAM01_E01
*&---------------------------------------------------------------------*
AT SELECTION-SCREEN ON VALUE-REQUEST FOR p_layout.

  CALL FUNCTION 'LVC_VARIANT_SAVE_LOAD'
    EXPORTING
      i_save_load = 'L'
    CHANGING
      cs_variant  = gs_variant.
  IF sy-subrc <> 0.
* Implement suitable error handling here
  ELSE.
    p_layout = gs_variant-variant.
  ENDIF.


INITIALIZATION.

  gs_variant = sy-cprog.


START-OF-SELECTION.

  IF p_screen = 'X'.
    CALL SCREEN 200.
  ELSE.
    PERFORM get_data.
    CALL SCREEN 100.
  ENDIF.

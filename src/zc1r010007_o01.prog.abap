*&---------------------------------------------------------------------*
*& Include          ZC1R010007_O01
*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*& Module STATUS_0100 OUTPUT
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
MODULE status_0100 OUTPUT.
  SET PF-STATUS 'S0100'.
  SET TITLEBAR 'T0100'.
ENDMODULE.
*&---------------------------------------------------------------------*
*& Module SET_FCAT_LAYOUT OUTPUT
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
MODULE set_fcat_layout OUTPUT.

  PERFORM set_fcat_layout.

ENDMODULE.
*&---------------------------------------------------------------------*
*& Module DISPLAY_SCREEN OUTPUT
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
MODULE display_screen OUTPUT.
  IF gcl_container IS NOT BOUND.
    CREATE OBJECT gcl_container
      EXPORTING
        repid     = sy-repid
        dynnr     = sy-dynnr
        side      = gcl_container->dock_at_left
        extension = 3000.

    CREATE OBJECT gcl_grid
      EXPORTING
        i_parent = gcl_container.

    gs_variant-report = sy-repid.
    "여기가 instance 메서스 사용방법.
    IF gcl_handler IS NOT BOUND.
      CREATE OBJECT gcl_handler.
    ENDIF.

    SET HANDLER: gcl_handler->handle_hotspot FOR gcl_grid.

    CALL METHOD gcl_grid->set_table_for_first_display
      EXPORTING
        is_variant      = gs_variant
        i_save          = 'A'
        i_default       = 'X'
        is_layout       = gs_layout
      CHANGING
        it_outtab       = gt_data
        it_fieldcatalog = gt_fcat.

  ENDIF.



ENDMODULE.
*&---------------------------------------------------------------------*
*& Form handle_hotspot
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*&      --> E_ROW_ID
*&      --> E_COLUMN_ID
*&---------------------------------------------------------------------*
FORM handle_hotspot  USING  ps_row_id    TYPE lvc_s_row
                            ps_column_id TYPE lvc_s_col.

  READ TABLE gt_data INTO gs_data INDEX ps_row_id-index.

  IF sy-subrc <> 0.
    MESSAGE i001.
    EXIT.
  ENDIF.

  CASE ps_column_id-fieldname.
    WHEN 'BELNR'.
      IF gs_data-belnr IS INITIAL.
        EXIT.
      ENDIF.
      SET PARAMETER ID : 'BLN' FIELD gs_data-belnr,
                         'BUK' FIELD pa_bukrs,
                         'GJR' FIELD pa_gjahr.


      CALL TRANSACTION 'FB03' AND SKIP FIRST SCREEN.
  ENDCASE.



ENDFORM.

*&---------------------------------------------------------------------*
*& Include          ZC1R010004_O01
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
*& Module SET_DISPLAY OUTPUT
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
MODULE set_display OUTPUT.

  PERFORM set_setting.

ENDMODULE.
*&---------------------------------------------------------------------*
*& Module DISPLAY_SCREEN OUTPUT
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
MODULE display_screen OUTPUT.
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


  IF gcl_handler IS NOT BOUND.
    CREATE OBJECT gcl_handler.
  ENDIF.
  PERFORM set_handler.

  CALL METHOD gcl_grid->set_table_for_first_display
    EXPORTING
      is_variant      = gs_variant
      i_save          = 'A'
      i_default       = 'X'
      is_layout       = gs_layout
    CHANGING
      it_outtab       = gt_data
      it_fieldcatalog = gt_fcat.
ENDMODULE.

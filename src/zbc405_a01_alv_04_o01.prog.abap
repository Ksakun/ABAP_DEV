*&---------------------------------------------------------------------*
*& Include          ZBC405_A01_ALV_04_O01
*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*& Module STATUS_0100 OUTPUT
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
MODULE status_0100 OUTPUT.
  SET PF-STATUS 'S100'.
  SET TITLEBAR 'T100' WITH sy-datum sy-uname.
ENDMODULE.
*&---------------------------------------------------------------------*
*& Module CREATE_ALV_OBJECT OUTPUT
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
MODULE create_alv_object OUTPUT.

  IF go_container IS INITIAL.
    CREATE OBJECT go_container
      EXPORTING
        container_name = 'MY_CONTROL_AREA'.

    IF sy-subrc = 0.
      CREATE OBJECT go_alv
        EXPORTING
          i_parent = go_container.

      IF sy-subrc = 0.

        "ALV Grid Setting
        PERFORM set_layout.

        CALL METHOD go_alv->set_table_for_first_display
          EXPORTING
*           i_buffer_active  =
*           i_bypassing_buffer            =
*           i_consistency_check           =
            i_structure_name = 'ZTSFLIGHT_A01'
*           is_variant       =
*           i_save           =
*           i_default        = 'X'
            is_layout        = gs_layout
*           is_print         =
*           it_special_groups             =
*           it_toolbar_excluding          =
*           it_hyperlink     =
*           it_alv_graphics  =
*           it_except_qinfo  =
*           ir_salv_adapter  =
          changing
            it_outtab        = gt_flight
*           it_fieldcatalog  =
*           it_sort          =
*           it_filter        =
*          EXCEPTIONS
*           invalid_parameter_combination = 1
*           program_error    = 2
*           too_many_lines   = 3
*           others           = 4
          .
        IF sy-subrc <> 0.
*         Implement suitable error handling here
        ENDIF.



      ENDIF.
    ENDIF.
  ENDIF.

ENDMODULE.

*&---------------------------------------------------------------------*
*& Include          ZBC405_A01_EXAM01_O01
*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*& Module STATUS_0100 OUTPUT
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
MODULE status_0100 OUTPUT.
  IF p_edit = 'X'.
    SET PF-STATUS 'S100'.
  ELSE.
    SET PF-STATUS 'S100' EXCLUDING 'SAVE'.
  ENDIF.
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
*       parent         =
        container_name = 'MY_CONTROL_AREA'.
    IF sy-subrc = 0.
      CREATE OBJECT go_alv
        EXPORTING
*         i_shellstyle      = 0
*         i_lifetime        =
          i_parent = go_container.

      IF sy-subrc = 0.

        PERFORM set_alv_setting.

        CALL METHOD go_alv->register_edit_event
          EXPORTING
            i_event_id = cl_gui_alv_grid=>mc_evt_modified.

        SET HANDLER lcl_handler=>on_doubleclick FOR go_alv.
        SET HANDLER lcl_handler=>on_toolbar FOR go_alv.
        SET HANDLER lcl_handler=>on_user_command FOR go_alv.
        SET HANDLER lcl_handler=>on_data_changed FOR go_alv.
        SET HANDLER lcl_handler=>on_data_changed_finished FOR go_alv.

        APPEND cl_gui_alv_grid=>mc_fc_loc_cut TO gt_exct.
        APPEND cl_gui_alv_grid=>mc_fc_loc_copy TO gt_exct.
        APPEND cl_gui_alv_grid=>mc_mb_paste TO gt_exct.
        APPEND cl_gui_alv_grid=>mc_fc_loc_undo TO gt_exct.
        APPEND cl_gui_alv_grid=>mc_fc_loc_append_row TO gt_exct.
        APPEND cl_gui_alv_grid=>mc_fc_loc_insert_row TO gt_exct.
        APPEND cl_gui_alv_grid=>mc_fc_loc_delete_row TO gt_exct.
        APPEND cl_gui_alv_grid=>mc_fc_loc_copy_row TO gt_exct.


        CALL METHOD go_alv->set_table_for_first_display
          EXPORTING
*           i_buffer_active               =
*           i_bypassing_buffer            =
*           i_consistency_check           =
            i_structure_name              = 'ZTSPFLI_A01'
            is_variant                    = gs_variant
            i_save                        = 'A'
            i_default                     = 'X'
            is_layout                     = gs_layout
*           is_print                      =
*           it_special_groups             =
            it_toolbar_excluding          = gt_exct
*           it_hyperlink                  =
*           it_alv_graphics               =
*           it_except_qinfo               =
*           ir_salv_adapter               =
          CHANGING
            it_outtab                     = gt_flight
            it_fieldcatalog               = gt_fcat
*           it_sort                       =
*           it_filter                     =
          EXCEPTIONS
            invalid_parameter_combination = 1
            program_error                 = 2
            too_many_lines                = 3
            OTHERS                        = 4.
      ENDIF.

    ENDIF.
  ELSE.
    ON CHANGE OF gt_flight.
      gv_soft_refresh = 'X'.
      gs_stable-row   = 'X'.
      gs_stable-col   = 'X'.

      CALL METHOD go_alv->refresh_table_display
        EXPORTING
          is_stable      = gs_stable
          i_soft_refresh = gv_soft_refresh
        EXCEPTIONS
          finished       = 1
          OTHERS         = 2.

    ENDON.
  ENDIF.
ENDMODULE.

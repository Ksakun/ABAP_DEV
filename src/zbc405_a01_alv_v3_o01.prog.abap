*&---------------------------------------------------------------------*
*& Include          ZBC405_A01_ALV_V3_O01
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

    "Make ALV Container
    CREATE OBJECT go_container
      EXPORTING
        container_name = 'MY_CONTROL_AREA'.

    "MAKE ALV
    IF sy-subrc = 0.
      CREATE OBJECT go_alv
        EXPORTING
          i_parent = go_container. "alv가 올라가는 부분.

      IF sy-subrc = 0.

        "Variant, Layout, Sort
        PERFORM set_setting.

        CALL METHOD go_alv->register_edit_event
          EXPORTING
            i_event_id = cl_gui_alv_grid=>mc_evt_modified.



        "특정 toolbar 버튼 없애기. excluding / Filter, Info
        APPEND cl_gui_alv_grid=>mc_fc_filter TO gt_exct.
        APPEND cl_gui_alv_grid=>mc_fc_info   TO gt_exct.

        APPEND cl_gui_alv_grid=>mc_fc_loc_append_row TO gt_exct.
        APPEND cl_gui_alv_grid=>mc_fc_loc_copy_row   TO gt_exct.

        "EVENT Handelr trigger
        SET HANDLER lcl_handler=>on_doubleclick FOR go_alv.
        SET HANDLER lcl_handler=>on_toolbar     FOR go_alv.
        SET HANDLER lcl_handler=>on_user_command FOR go_alv.
        SET HANDLER lcl_handler=>on_data_changed FOR go_alv.
        SET HANDLER lcl_handler=>on_data_changed_finished FOR go_alv.

        "CALL method SET_TABLE_FOR FIST_DISPLAY 처음 화면 부분 그리는 METHOD
        CALL METHOD go_alv->set_table_for_first_display
          EXPORTING
*           i_buffer_active      =
*           i_bypassing_buffer   =
*           i_consistency_check  =
            i_structure_name     = 'ZTSBOOK_A01'   "참조해서 보여줄 table 이름을 여기에 적는다.
            "variant, save, default -> variant 버튼 활성화
            is_variant           = gs_variant
            i_save               = 'A'             "4가지 OPTION = ' ':변경만 가능, 'A':global, useur-specif, 'X':global, 'U':User-Specify
            i_default            = 'X'
            is_layout            = gs_layout
*           is_print             =
*           it_special_groups    =
            it_toolbar_excluding = gt_exct     "Screen의 Excluding이다 . ZBC405_A01_ALV 확인하기.
*           it_hyperlink         =
*           it_alv_graphics      =
*           it_except_qinfo      =
*           ir_salv_adapter      =
          CHANGING
            it_outtab            = gt_book     "db table에서 내가 작업할 work area internal table을 적는다.
            it_fieldcatalog      = gt_fcat
            it_sort              = gt_sort     "sort: TOP에 gt_sort, gs_sort(wa) 선언
*           it_filter            =
*          EXCEPTIONS
*           invalid_parameter_combination = 1
*           program_error        = 2
*           too_many_lines       = 3
*           others               = 4
          .
        IF sy-subrc <> 0.
*         Implement suitable error handling here
        ENDIF.
      ENDIF.
    ENDIF.
  ELSE.

    "Refresh ALV CONTAINER -> 해줘야 db테이블이 반영이된다. 화면을 새로고침해준다?
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
    IF sy-subrc <> 0.
*   Implement suitable error handling here
    ENDIF.



  ENDIF.

ENDMODULE.

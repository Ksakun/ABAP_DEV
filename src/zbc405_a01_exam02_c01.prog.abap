*&---------------------------------------------------------------------*
*& Include          ZBC405_A01_EXAM01_C01
*&---------------------------------------------------------------------*

CLASS lcl_handler DEFINITION.
  PUBLIC SECTION.
    CLASS-METHODS:
      on_doubleclick FOR EVENT double_click  OF cl_gui_alv_grid
        IMPORTING e_row e_column es_row_no,

      on_toolbar     FOR EVENT toolbar       OF cl_gui_alv_grid
        IMPORTING e_object,

      on_user_command FOR EVENT user_command OF cl_gui_alv_grid
        IMPORTING e_ucomm,

      on_data_changed FOR EVENT data_changed OF cl_gui_alv_grid
        IMPORTING er_data_changed,

      on_data_changed_finished FOR EVENT data_changed_finished OF cl_gui_alv_grid
        IMPORTING e_modified et_good_cells.


ENDCLASS.


CLASS lcl_handler IMPLEMENTATION.

  METHOD on_data_changed_finished.
    DATA: ls_mod TYPE lvc_s_modi.

    CHECK e_modified = 'X'.

    LOOP AT et_good_cells INTO ls_mod.
      PERFORM check_modified USING ls_mod.
    ENDLOOP.

  ENDMETHOD.

  METHOD on_data_changed.
    DATA: ls_mod    TYPE lvc_s_modi,
          l_fltime  TYPE ztspfli_a01-fltime,
          l_arrtime TYPE ztspfli_a01-arrtime,
          l_deptime TYPE spfli-deptime,
          l_period  TYPE n,
          l_except  TYPE c LENGTH 1.

    LOOP AT er_data_changed->mt_good_cells INTO ls_mod.

      CASE ls_mod-fieldname.
        WHEN 'FLTIME' OR 'ARRTIME'.
          READ TABLE gt_flight INTO gs_flight INDEX ls_mod-row_id.

          "FLTIME 타이핑 수정 시
          CALL METHOD er_data_changed->get_cell_value
            EXPORTING
              i_row_id    = ls_mod-row_id
              i_fieldname = 'FLTIME'
            IMPORTING
              e_value     = l_fltime.

          "DEPARTURE TIME 수정시
          CALL METHOD er_data_changed->get_cell_value
            EXPORTING
              i_row_id    = ls_mod-row_id
              i_fieldname = 'DEPTIME'
            IMPORTING
              e_value     = l_deptime.

          "입력한 값으로 시간 계산 & 도착시간, period 출력
          CALL FUNCTION 'ZBC405_CALC_ARRTIME'
            EXPORTING
              iv_fltime       = l_fltime
              iv_deptime      = l_deptime
              iv_utc          = gs_flight-ftzone
              iv_utc1         = gs_flight-ttzone
            IMPORTING
              ev_arrival_time = l_arrtime
              ev_period       = l_period.

          "exception handling 자동 바뀌는 부분
          IF l_period GE 2.
            l_except = 1.
          ELSEIF l_period = 1.
            l_except = 2.
          ELSE.
            l_except = 3.
          ENDIF.

          "변한값들을 해당 cell에 업데이트
          "arrtime
          CALL METHOD er_data_changed->modify_cell
            EXPORTING
              i_row_id    = ls_mod-row_id
              i_fieldname = 'ARRTIME'
              i_value     = l_arrtime.

          "period
          CALL METHOD er_data_changed->modify_cell
            EXPORTING
              i_row_id    = ls_mod-row_id
              i_fieldname = 'PERIOD'
              i_value     = l_period.

          "Exception Handling
          CALL METHOD er_data_changed->modify_cell
            EXPORTING
              i_row_id    = ls_mod-row_id
              i_fieldname = 'LIGHT'
              i_value     = l_except.


          gs_flight-fltime  = l_fltime.
          gs_flight-deptime = l_deptime.
          gs_flight-arrtime = l_arrtime.
          gs_flight-period  = l_period.
          gs_flight-light   = l_except.


          MODIFY gt_flight FROM gs_flight INDEX ls_mod-row_id.

      ENDCASE.
    ENDLOOP.

  ENDMETHOD.

  METHOD on_doubleclick.
    IF e_column-fieldname = 'CARRID' OR e_column-fieldname = 'CONNID'.
      READ TABLE gt_flight INTO gs_flight INDEX e_row-index.
      IF sy-subrc = 0.
        SUBMIT bc405_event_s4 AND RETURN
          WITH so_car = gs_flight-carrid
          WITH so_con = gs_flight-connid.
      ENDIF.
    ENDIF.

  ENDMETHOD.

  METHOD on_toolbar.
    DATA: ls_button TYPE stb_button.

    CLEAR ls_button.
    ls_button-function = 'GETNAME'.
    ls_button-icon     = icon_ws_plane.
    ls_button-butn_type = '0'.
    ls_button-text     = 'Flight'.
    INSERT ls_button INTO TABLE e_object->mt_toolbar.

    CLEAR ls_button.
    ls_button-function = 'FLINFO'.
    ls_button-butn_type = '0'.
    ls_button-text     = 'Flight Info'.
    INSERT ls_button INTO TABLE e_object->mt_toolbar.

    CLEAR ls_button.
    ls_button-function = 'FLDATA'.
    ls_button-butn_type = '0'.
    ls_button-text     = 'Flight Data'.
    INSERT ls_button INTO TABLE e_object->mt_toolbar.

  ENDMETHOD.

  METHOD on_user_command.

    DATA: ls_col  TYPE lvc_s_col,
          ls_roid TYPE lvc_s_roid,
          ls_row  TYPE lvc_s_row,
          lt_row  TYPE lvc_t_row.

    DATA: lv_text TYPE scarr-carrname.

    CALL METHOD go_alv->get_current_cell
      IMPORTING
        es_row_no = ls_roid
        es_col_id = ls_col.



    CASE e_ucomm.
      WHEN 'GETNAME'. "CARRID 찍었을 때만 메시지창으로 보여주기 / 다른 데는 각각 다른 메시지 뜨게 설정
        IF ls_col-fieldname = 'CARRID'.
          READ TABLE gt_flight INTO gs_flight INDEX ls_roid-row_id.
          IF sy-subrc = 0.
            CLEAR lv_text.
            SELECT SINGLE carrname
              FROM scarr
              INTO lv_text
             WHERE carrid = gs_flight-carrid.

            IF sy-subrc = 0.
              MESSAGE i000(zmcsa01) WITH 'Airline Name : ' lv_text.
            ELSE.
              MESSAGE i000(zmcsa01) WITH 'Find Name Faileld, Check again.'.
            ENDIF.
          ENDIF.
        ELSE.
          MESSAGE i000(zmcsa01) WITH 'Click "Airline".'.
          EXIT.
        ENDIF.

      WHEN 'FLINFO'. "누르면 다른 프로그램으로 이동하게 만들기.
        CALL METHOD go_alv->get_selected_rows
          IMPORTING
            et_index_rows = lt_row.
        CLEAR mem_it_spfli.
        LOOP AT lt_row INTO ls_row.
          READ TABLE gt_flight INTO gs_flight INDEX ls_row-index.
          MOVE-CORRESPONDING gs_flight TO mem_is_spfli.
          APPEND mem_is_spfli TO mem_it_spfli.
          CLEAR: mem_is_spfli, gs_flight.
        ENDLOOP.
        IF mem_it_spfli IS NOT INITIAL.
          EXPORT mem_it_spfli FROM mem_it_spfli TO MEMORY ID 'BC405'.
          SUBMIT bc405_call_flights AND RETURN.
        ELSE.
          MESSAGE i000(zmcsa01) WITH 'Select least 1 row'.
        ENDIF.

      WHEN 'FLDATA'.
        READ TABLE gt_flight INTO gs_flight INDEX ls_roid-row_id.
        IF sy-subrc = 0.
          SET PARAMETER ID: 'CAR' FIELD gs_flight-carrid,
                            'CON' FIELD gs_flight-connid,
                            'DAY' FIELD space.

          CALL TRANSACTION 'SAPBC410A_INPUT_FIEL'.
        ENDIF.

    ENDCASE.


  ENDMETHOD.

ENDCLASS.

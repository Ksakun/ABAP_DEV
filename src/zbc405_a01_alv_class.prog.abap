*&---------------------------------------------------------------------*
*& Include          ZBC405_A01_ALV_CLASS
*&---------------------------------------------------------------------*
"Class 정의 부분
CLASS lcl_handler DEFINITION.
  PUBLIC SECTION.
    CLASS-METHODS:
      "더블클릭 이벤트를 cl_gui_alv_grid event에서 가져오기
      on_doubleclick FOR EVENT double_click OF cl_gui_alv_grid
        IMPORTING e_row e_column es_row_no,
      "Hot Spot class
      on_hotspot     FOR EVENT hotspot_click OF cl_gui_alv_grid
        IMPORTING e_row_id e_column_id es_row_no,
      "Toolbar 버튼 만들기
      on_toolbar     FOR EVENT toolbar       OF cl_gui_alv_grid
        IMPORTING e_object,
      "User Command 추가
      on_user_command FOR EVENT user_command OF cl_gui_alv_grid
        IMPORTING e_ucomm,
      "Button Click
      on_button_click FOR EVENT button_click OF cl_gui_alv_grid
        IMPORTING es_col_id es_row_no,
      "Context Menu
      on_context_menu_request FOR EVENT context_menu_request OF cl_gui_alv_grid
        IMPORTING e_object,
      "Before User Command
      on_before_user_comm   FOR EVENT before_user_command OF cl_gui_alv_grid
        IMPORTING e_ucomm.
    "여기에 계속 Method 추가 가능.
ENDCLASS.


"Class 구현 부분
CLASS lcl_handler IMPLEMENTATION.

  METHOD on_doubleclick. "더블클릭을 하는 순간 flight의 예약된 좌석수 (seatsocc + seatsocc_b + seatsocc_f )를 알려줌.

    DATA: lv_total   LIKE gs_flt-seatsocc,
          lv_total_c TYPE n LENGTH 10.

    "특정 컬럼을 더블클릭할때만 정보를 띄워주게 하고 싶을 때
    CASE e_column-fieldname.
      WHEN 'CHANGES_POSSIBLE'.
        READ TABLE gt_flt INTO gs_flt INDEX es_row_no-row_id. "클릭한 cell의 줄 넘버 확인하기

        IF sy-subrc = 0. "Row number를 가져왔다면
          lv_total = gs_flt-seatsocc + gs_flt-seatsocc_b + gs_flt-seatsocc_f.
          lv_total_c = lv_total.
          CONDENSE lv_total_c.
          MESSAGE i000(zmcsa01) WITH 'Total Number of Bookings:' lv_total_c.
        ELSE.
          MESSAGE i075(bc405_408).
          EXIT.
        ENDIF.
    ENDCASE.
  ENDMETHOD.

  METHOD on_hotspot.

    DATA: lv_name TYPE scarr-carrname.
    CASE e_column_id-fieldname.
      WHEN 'CARRID'.
        READ TABLE gt_flt INTO gs_flt INDEX es_row_no-row_id.

        IF sy-subrc = 0.
          SELECT SINGLE carrname
            FROM scarr
            INTO lv_name
           WHERE carrid = gs_flt-carrid.
          IF sy-subrc = 0.
            MESSAGE i000(zmcsa01) WITH 'Airline name: ' lv_name.
          ELSE.
            MESSAGE i000(zmcsa01) WITH 'Not Found!'.
            EXIT.
          ENDIF.
        ELSE.
          MESSAGE i075(bc405_408).
          EXIT.
        ENDIF.
    ENDCASE.

  ENDMETHOD.

  METHOD on_toolbar.

    DATA ls_button TYPE stb_button. "타입 찾는건 toolbar -> mt_button 의 data element 확인

    CLEAR ls_button.
    ls_button-function = 'PERCENTAGE'.
*    ls_button-icon     = ?.
    ls_button-quickinfo = 'Percentage'.
    ls_button-butn_type = '0'. "Normal Type Button
    ls_button-text      = 'Percentage'.
    INSERT ls_button INTO TABLE e_object->mt_toolbar.

    CLEAR ls_button.
    ls_button-butn_type = '3'. "구분하는 줄 생성
    INSERT ls_button INTO TABLE e_object->mt_toolbar.

    CLEAR ls_button.
    ls_button-function = 'PERCENTAGE_TOTAL'.
*    ls_button-icon     = ?.
    ls_button-quickinfo = 'Occupied Total Percentage'.
    ls_button-butn_type = '0'. "Normal Type Button
    ls_button-text      = 'Total Percentage'.
    INSERT ls_button INTO TABLE e_object->mt_toolbar.

    CLEAR ls_button.
    ls_button-butn_type = '3'. "구분하는 줄 생성
    INSERT ls_button INTO TABLE e_object->mt_toolbar.

    CLEAR ls_button.
    ls_button-function = 'PERCENTAGE_MARKED'.
*    ls_button-icon     = ?.
    ls_button-quickinfo = 'Occupied Marked Percentage'.
    ls_button-butn_type = '0'. "Normal Type Button
    ls_button-text      = 'Marked Percentage'.
    INSERT ls_button INTO TABLE e_object->mt_toolbar.

    CLEAR ls_button.
    ls_button-function = 'GET_CARR'.
    ls_button-quickinfo = 'Display'.
    ls_button-icon      = icon_ws_plane.
    ls_button-butn_type = '0'.
    ls_button-text      = 'Display Airline'.
    INSERT ls_button INTO TABLE e_object->mt_toolbar.

  ENDMETHOD.

  METHOD on_user_command.
    DATA: lv_occupied TYPE i,
          lv_capacity TYPE i,
          lv_percent  TYPE p LENGTH 8 DECIMALS 1,
          lv_text(20),
          lv_name     TYPE scarr-carrname.

    DATA: lt_rows TYPE lvc_t_roid,
          ls_rows TYPE lvc_s_roid.

    DATA: lv_col_id TYPE lvc_s_col,
          lv_row_id TYPE lvc_s_row.

    CALL METHOD go_alv_grid->get_current_cell
      IMPORTING
*       e_row     = ls_rows
*       e_value   =
*       e_col     = ls_col
        es_row_id = lv_row_id
        es_col_id = lv_col_id.

    CASE e_ucomm.
      WHEN 'PERCENTAGE'.
      WHEN 'PERCENTAGE_TOTAL'.

        CLEAR: lv_occupied, lv_capacity, lv_percent, lv_text.
        LOOP AT gt_flt INTO gs_flt.
          lv_occupied = lv_occupied + gs_flt-seatsocc.
          lv_capacity = lv_capacity + gs_flt-seatsmax.
        ENDLOOP.

        lv_percent = lv_occupied / lv_capacity * 100.
        lv_text = lv_percent.
        CONDENSE lv_text.

        MESSAGE i000(zmcsa01) WITH 'Total Percentage of occupied: ' lv_percent '%'.

      WHEN 'PERCENTAGE_MARKED'.
        "사용자가 선택한 행의 정보 가져오기

        CLEAR: lv_occupied, lv_capacity, lv_percent, lv_text.
        CALL METHOD go_alv_grid->get_selected_rows
          IMPORTING
*           et_index_rows =
            et_row_no = lt_rows.
        IF lines( lt_rows ) > 0.
          LOOP AT lt_rows INTO ls_rows.

            READ TABLE gt_flt INTO gs_flt INDEX ls_rows-row_id.
            "성공하면 밑에 계산
            IF sy-subrc = 0.
              lv_occupied = lv_occupied + gs_flt-seatsocc.
              lv_capacity = lv_capacity + gs_flt-seatsmax.
            ENDIF.
          ENDLOOP.

          lv_percent = lv_occupied / lv_capacity * 100.
          lv_text = lv_percent.
          CONDENSE lv_text.

          MESSAGE i000(zmcsa01) WITH 'Selected Rows Percentage of Occupied: ' lv_percent '%'.

        ELSE.
          MESSAGE i000(zmcsa01) WITH 'No Line Selected. Select Line '.
*
        ENDIF.

      WHEN 'SCHE'.      "goto flight schedule report.
        READ TABLE gt_flt INTO gs_flt INDEX lv_row_id-index.
        IF sy-subrc EQ 0.
          SUBMIT bc405_event_d4 AND RETURN
                     " VIA SELECTION-SCREEN "Selection Screen에서 멈췄다가 실행한다.
                WITH so_car EQ gs_flt-carrid "검색 조건을 걸어주는 것
                WITH so_con EQ gs_flt-connid.
        ENDIF.

      WHEN 'GET_CARR'.
        IF lv_col_id-fieldname = 'CARRID'.
          READ TABLE gt_flt INTO gs_flt INDEX lv_row_id-index.
          IF sy-subrc = 0.
            CLEAR: lv_text.
            SELECT SINGLE carrname
              FROM scarr
              INTO lv_text
             WHERE carrid = gs_flt-carrid.
            IF sy-subrc = 0.
              MESSAGE i000(zmcsa01) WITH 'Air Line Name : ' lv_text.
            ELSE.
              MESSAGE i000(zmcsa01) WITH 'Airline Not Found!'.
            ENDIF.
          ENDIF.
        ELSE.
          MESSAGE i000(zmcsa01) WITH 'Choose Airline'.
          EXIT.

        ENDIF.

    ENDCASE.
  ENDMETHOD.

  METHOD on_button_click.

    READ TABLE gt_flt INTO gs_flt INDEX es_row_no-row_id.
    IF ( gs_flt-seatsmax NE gs_flt-seatsocc ) OR ( gs_flt-seatsmax_f NE gs_flt-seatsocc_f ).
      MESSAGE i000(zmcsa01) WITH 'Economy or First Class is Available.'.
    ELSE.
      MESSAGE i000(zmcsa01) WITH 'ALL Seats Fully Booked, Sorry'.
    ENDIF.
  ENDMETHOD.

  METHOD on_context_menu_request.

    DATA: ls_col_id TYPE lvc_s_col,
          ls_row_id TYPE lvc_s_row.

    CALL METHOD e_object->add_separator.

    CALL METHOD cl_ctmenu=>load_gui_status
      EXPORTING
        program    = sy-cprog
        status     = 'CT_MENU'
*       disable    =
        menu       = e_object
      EXCEPTIONS
        read_error = 1
        OTHERS     = 2.
    IF sy-subrc <> 0.
*     Implement suitable error handling here
    ENDIF.

    CALL METHOD e_object->add_separator.

    CALL METHOD go_alv_grid->get_current_cell
      IMPORTING
*       e_row     =
*       e_value   =
*       e_col     =
        es_row_id = ls_row_id
        es_col_id = ls_col_id.


    IF ls_col_id-fieldname = 'CARRID'.
      e_object->add_function(
      EXPORTING
        fcode             = 'GET_CARR'
        text              = 'Display Airline Con'
*        icon              = ICON_WS_PLANE
*        ftype             =
*        disabled          =
*        hidden            =
*        checked           =
*        accelerator       =
*        insert_at_the_top = SPACE
        ).
    ENDIF.


  ENDMETHOD.

  METHOD on_before_user_comm.

    CASE e_ucomm.
      WHEN cl_gui_alv_grid=>mc_fc_detail.
        CALL METHOD go_alv_grid->set_user_command
          EXPORTING
            i_ucomm = 'SCHE'.        "Flight Schedule

    ENDCASE.
  ENDMETHOD.

ENDCLASS.

*&---------------------------------------------------------------------*
*& Include          ZBC405_ALV_CLI_A01_CLASS
*&---------------------------------------------------------------------*

CLASS lcl_handler DEFINITION.
  PUBLIC SECTION.

    CLASS-METHODS:
      on_doubleclick FOR EVENT double_click OF cl_gui_alv_grid
        IMPORTING e_row e_column es_row_no,

      on_toolbar FOR EVENT toolbar OF cl_gui_alv_grid
        IMPORTING e_object,

      on_user_command FOR EVENT user_command OF cl_gui_alv_grid
        IMPORTING e_ucomm,
      "사용자가 alv에서 데이터를 변경하는 메서드
      on_data_changed FOR EVENT data_changed OF cl_gui_alv_grid
        IMPORTING er_data_changed,

      on_data_changed_finished FOR EVENT data_changed_finished OF cl_gui_alv_grid
        IMPORTING e_modified et_good_cells.


ENDCLASS.


CLASS lcl_handler IMPLEMENTATION.

  METHOD on_data_changed_finished. "전체 권한이 없는 일부 사용자가 사용할 수 있는 로직.
    DATA : ls_mod_cells TYPE lvc_s_modi. " et_good_cells를 사용하기 위한 work area 선언
    CHECK e_modified = 'X'. "CHECK 뒤의 조건이 성립할때만 다음 로직으로 진행.거짓이면 메서드 탈출
    "변경된 로직이 들어 가는 FIELD가 있어야한다.
    LOOP AT et_good_cells INTO ls_mod_cells.

      PERFORM modify_check USING ls_mod_cells.

    ENDLOOP.

  ENDMETHOD.

  METHOD on_data_changed. "EDIT 모드에서 데이터 수정을 가능하게 한다.
    "Insert하기 위한 symbol 선언
    FIELD-SYMBOLS: <fs> LIKE gt_book.

    DATA: ls_mod_cells TYPE lvc_s_modi,
          "이 밑 data 선언은 insert를 하기위한 데이터 선언
          ls_ins_cells TYPE lvc_s_moce,
          ls_del_cells  TYPE lvc_s_moce.

    "데이터 변경 로직
    LOOP AT er_data_changed->mt_good_cells INTO ls_mod_cells.

      CASE ls_mod_cells-fieldname.
        WHEN 'CUSTOMID'.
          PERFORM customer_change_part USING er_data_changed
                                             ls_mod_cells.
        WHEN 'CANCELLED'.

      ENDCASE.
    ENDLOOP.

    "Insert
    IF er_data_changed->mt_inserted_rows IS NOT INITIAL.
      ASSIGN er_data_changed->mp_mod_rows->* TO <fs>.

      IF sy-subrc = 0.
        APPEND LINES OF <fs> TO gt_book.
        LOOP AT er_data_changed->mt_inserted_rows INTO ls_ins_cells.

          READ TABLE gt_book INTO gs_book INDEX ls_ins_cells-row_id.
          IF sy-subrc = 0.

            PERFORM insert_parts USING er_data_changed
                                       ls_ins_cells.

          ENDIF.
        ENDLOOP.

      ENDIF.
    ENDIF.

    "Delete Data
    IF er_data_changed->mt_deleted_rows IS NOT INITIAL.
      LOOP AT er_data_changed->mt_deleted_rows INTO ls_del_cells.

        READ TABLE gt_book INTO gs_book INDEX ls_del_cells-row_id.
        IF sy-subrc = 0.
          MOVE-CORRESPONDING gs_book TO dw_book.
          APPEND dw_book TO dl_book. "지울 내용을 dl_book 인터널 테이블에 집어 넣는다.
        ENDIF.

      ENDLOOP.
    ENDIF.

  ENDMETHOD.

  METHOD on_user_command.
    "현재 누르고 있는 CELL의 정보를 취득해야함. Using: get_current_cell
    DATA: ls_col  TYPE lvc_s_col,
          ls_roid TYPE lvc_s_roid.

    CALL METHOD go_alv->get_current_cell
      IMPORTING
        es_col_id = ls_col
        es_row_no = ls_roid.

    CASE e_ucomm.
        "MEMORY를 SET하고 화면을 전환해라 다른 프로그램으로 이동 하는 방법.
      WHEN 'GOTOFL'.
        READ TABLE gt_book INTO gs_book INDEX ls_roid-row_id.
        IF sy-subrc = 0.
          SET PARAMETER ID 'CAR' FIELD gs_book-carrid.
          SET PARAMETER ID 'CON' FIELD gs_book-connid.

          CALL TRANSACTION 'SAPBC405CAL'.

        ENDIF.


    ENDCASE.


  ENDMETHOD.

  METHOD on_toolbar.
    DATA: wa_button TYPE stb_button.

    wa_button-butn_type = '3'."Seprator buttontype
    INSERT wa_button INTO TABLE e_object->mt_toolbar.

    CLEAR wa_button.
    wa_button-butn_type = '0'. "Normal type button
    wa_button-function  = 'GOTOFL'. "Call transaction / Flight connection
    wa_button-icon      = ICON_Flight.
    wa_button-quickinfo = 'Go To Flight Connection!'.
    wa_button-text      = 'Flight'.
    INSERT wa_button INTO TABLE e_object->mt_toolbar.

  ENDMETHOD.

  METHOD on_doubleclick.
    DATA carrname TYPE scarr-carrname.

    CASE e_column-fieldname.
      WHEN 'CARRID'.
        READ TABLE gt_book INTO gs_book
            INDEX e_row-index.

        IF sy-subrc = 0.
          SELECT SINGLE carrname
            FROM scarr
            INTO carrname
           WHERE carrid = gs_book-carrid.
          IF sy-subrc = 0.
            MESSAGE i000(zmcsa01) WITH 'Airline Name' carrname.
          ENDIF.
        ENDIF.
    ENDCASE.

  ENDMETHOD.

ENDCLASS.

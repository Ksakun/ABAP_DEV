*&---------------------------------------------------------------------*
*& Include          ZC1R010008_F01
*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*& Form get_data
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM get_data .
  _clear gs_data gt_data.

  SELECT pernr ename entdt gender edept carrid
    FROM ztsa0103
    INTO CORRESPONDING FIELDS OF TABLE gt_data
   WHERE pernr IN so_pernr.

*  IF sy-subrc <> 0.
*    MESSAGE i001.
*    LEAVE LIST-PROCESSING.
*
*  ENDIF.


ENDFORM.
*&---------------------------------------------------------------------*
*& Form set_fcat_layout
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM set_fcat_layout .

  gs_layout-zebra      = 'X'.
*  gs_layout-cwidth_opt = 'X'.
  gs_layout-sel_mode   = 'D'.
  gs_layout-stylefname = 'STYLE'.

  IF gt_fcat IS INITIAL.

    PERFORM set_fact USING:
      'X'     'PERNR'       ' '       'ZTSA0103'    'PERNR'     'X'   10,
      ' '     'ENAME'       ' '       'ZTSA0103'    'ENAME'     'X'   20,
      ' '     'ENTDT'       ' '       'ZTSA0103'    'ENTDT'     'X'   10,
      ' '     'GENDER'      ' '       'ZTSA0103'    'GENDER'    'X'    5,
      ' '     'EDEPT'       ' '       'ZTSA0103'    'EDEPT'     'X'    8,
      ' '     'CARRID'      ' '       'ZTSA0103'    'CARRID'    'X'   10,
      ' '     'CARRNAME'    ' '       'SCARR'       'CARRNAME'  ' '   20.


  ENDIF.
ENDFORM.
*&---------------------------------------------------------------------*
*& Form set_fact
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*&      --> P_
*&      --> P_
*&      --> P_
*&      --> P_
*&      --> P_
*&---------------------------------------------------------------------*
FORM set_fact  USING pv_key pv_field pv_text pv_ref_table pv_ref_field pv_edit pv_length.

  gt_fcat = VALUE #( BASE gt_fcat
                     (
                       key       = pv_key
                       fieldname = pv_field
                       coltext   = pv_text
                       ref_table = pv_ref_table
                       ref_field = pv_ref_field
                       edit      = pv_edit
                       outputlen = pv_length
                      )
                    ).


ENDFORM.
*&---------------------------------------------------------------------*
*& Form display_screen
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM display_screen .
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

    SET HANDLER: lcl_event_handler=>handle_data_changed    FOR gcl_grid,
                 lcl_event_handler=>handle_change_finished FOR gcl_grid.

    "ENTER 먹게 하는 이벤트
    CALL METHOD gcl_grid->register_edit_event
      EXPORTING
        i_event_id = cl_gui_alv_grid=>mc_evt_modified
      EXCEPTIONS
        error      = 1
        OTHERS     = 2.



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

ENDFORM.
*&---------------------------------------------------------------------*
*& Form save_data
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM save_data .

  DATA: lt_save  TYPE TABLE OF ztsa0103,
        lt_del   TYPE TABLE OF ztsa0103,
        lv_cnt   TYPE i, "commit을 한번만 하기위해서
        lv_dml,
        lv_error.

  REFRESH: lt_save. CLEAR:lv_cnt, lv_dml.

  CALL METHOD gcl_grid->check_changed_data.

  CLEAR lv_error.
  LOOP AT gt_data INTO gs_data.

    IF gs_data-pernr IS INITIAL.
      MESSAGE s000 WITH TEXT-e01 DISPLAY LIKE 'E'.
      lv_error = 'X'. "에러가 발생했을 경우 저장 플로우 수행방지 위해서 값을 세팅한다.
      EXIT.           "여기를 만나면 루프만 빠져나간다.
    ENDIF.
    "에러없는 데이터는 바로바로 itab에 반영

    lt_save = VALUE #( BASE lt_save
                  (
                    pernr  = gs_data-pernr
                    ename  = gs_data-ename
                    entdt  = gs_data-entdt
                    gender = gs_data-gender
                    edept  = gs_data-edept
                    carrid = gs_data-carrid
                   )
                  ).

  ENDLOOP.

  CHECK lv_error IS INITIAL. "에러가 없으면 아래로 바로 진행
  "위와 같은 말
*  IF lv_erro IS NOT INITIAL.
*    EXIT.
*  ENDIF.

  IF gt_data_del IS NOT INITIAL.

    LOOP AT gt_data_del INTO DATA(ls_del).

      lt_del = VALUE #( BASE lt_del
                        ( pernr = ls_del-pernr )
                       ).

    ENDLOOP.

    DELETE ztsa0103 FROM TABLE lt_del.

    IF sy-dbcnt > 0.
      lv_cnt = lv_cnt + 1.
*     lv_cnt = lv_cnt + sy-dbcnt.
*      COMMIT WORK AND WAIT. "여기에 있어도 되긴하지만 한 프로그램에 commit은 하나만 있어야한다.
    ENDIF.

  ENDIF.

  IF lt_save IS NOT INITIAL.

    MODIFY ztsa0103 FROM TABLE lt_save.

    IF sy-dbcnt > 0.
*      COMMIT WORK AND WAIT.
*      MESSAGE i002. "data 저장 성공 메시지
      lv_cnt += sy-dbcnt.
    ENDIF.

  ENDIF.

  IF lv_cnt > 0.
    COMMIT WORK AND WAIT.
    MESSAGE i002.
  ENDIF.


ENDFORM.
*&---------------------------------------------------------------------*
*& Form refresh_grid
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM refresh_grid .


  gs_stable-row = 'X'.
  gs_stable-col = 'X'.

  CALL METHOD gcl_grid->refresh_table_display
    EXPORTING
      is_stable      = gs_stable
      i_soft_refresh = space.




ENDFORM.
*&---------------------------------------------------------------------*
*& Form create_row
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM create_row .

  CLEAR gs_data.

  APPEND gs_data TO gt_data.

  PERFORM refresh_grid.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form delete_row
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM delete_row .

  REFRESH gt_rows.

  CALL METHOD gcl_grid->get_selected_rows
    IMPORTING
      et_index_rows = gt_rows.

  IF gt_rows IS INITIAL.
    MESSAGE s000 WITH TEXT-e02 DISPLAY LIKE 'E'.
    EXIT.
  ENDIF.

**********************************************************************
  "방법#2 : 방법#1이 PERFORMANCE가 더 좋다
*  LOOP AT gt_rows INTO gs_row.
*
*    READ TABLE gt_data INTO gs_data INDEX gs_row-index.
*
*    IF sy-subrc = 0.
*       gs_data-mark = 'X'.
*       MODIFY gt_data FROM gs_data INDEX gs_row-index TRANSPORTING mark.
*    ENDIF.
*
*  ENDLOOP.
*
*  DELETE gt_data WHERE mark IS NOT INITIAL.


**********************************************************************
  "방법 #1
  SORT gt_rows BY index DESCENDING.

  LOOP AT gt_rows INTO gs_row.
    "ITAB에서 삭제하기 전에 db table에서도 삭제해야 하므로 삭제대상을 따로 보관한다.
    READ TABLE gt_data INTO gs_data INDEX gs_row-index. "선택한 행의 정보 조히
    IF sy-subrc = 0.

      APPEND gs_data TO gt_data_del. "삭제 대상을 work area에 보관

    ENDIF.
    "alv grid에서 보여지는 itab에서 정보 삭제/ 아직 db 테이블은 삭제 되지 않음.
    DELETE gt_data INDEX gs_row-index.

  ENDLOOP.

  PERFORM refresh_grid.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form set_style
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM set_style . "Structure로 선언했을 때

  DATA: lv_tabix TYPE sy-tabix,
        ls_style TYPE lvc_s_styl.

*  ls_style-fieldname = 'PERNR'.
*  ls_style-style     = cl_gui_alv_grid=>mc_style_disabled.

  ls_style = VALUE #( fieldname = 'PERNR'
                      style     = cl_gui_alv_grid=>mc_style_disabled ).

  "Table에서 가지고 온 데이터의 PK는 변경 불가하게 하기 위해 편집 금지모드로 만들기
  LOOP AT gt_data INTO gs_data.
    lv_tabix = sy-tabix.

    REFRESH gs_data-style.

    APPEND ls_style TO gs_data-style.

    MODIFY gt_data FROM gs_data INDEX lv_tabix TRANSPORTING style.

  ENDLOOP.

ENDFORM.

FORM set_style_table . "Table로 선언했을 때

  DATA: lv_tabix TYPE sy-tabix,
        ls_style TYPE lvc_s_styl,
        lt_style TYPE lvc_t_styl.


  lt_style = VALUE #(
                      (
                        fieldname = 'PERNR'
                        style     = cl_gui_alv_grid=>mc_style_disabled
                       )
                     ).


  LOOP AT gt_data INTO gs_data.
    lv_tabix = sy-tabix.

    REFRESH gs_data-style.
    "#1
*    APPEND LINES OF lt_style TO gs_data-style.
    "#2
*    gs_data-style = lt_style.
    "#3
    MOVE-CORRESPONDING lt_style TO gs_data-style.

    MODIFY gt_data FROM gs_data INDEX lv_tabix TRANSPORTING style.

  ENDLOOP.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form handle_data_changed
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*&      --> ER_DATA_CHANGED
*&---------------------------------------------------------------------*
FORM handle_data_changed  USING pcl_data_changed TYPE REF TO
                                cl_alv_changed_data_protocol.

  LOOP AT pcl_data_changed->mt_mod_cells INTO DATA(ls_modi).

    READ TABLE gt_data INTO gs_data INDEX ls_modi-row_id.

    IF sy-subrc <> 0.
      CONTINUE.
    ENDIF.

    SELECT SINGLE carrname
      INTO gs_data-carrname
      FROM scarr
     WHERE carrid = ls_modi-value.

*    select single carrname
*      INTO gs_emp-carrname
*      FROM scarr
*     WHERE carrid = ls_modi-value. "New Value

    IF sy-subrc <> 0.
      CLEAR gs_data-carrname.
    ENDIF.


    MODIFY gt_data FROM gs_data INDEX ls_modi-row_id TRANSPORTING carrname.


  ENDLOOP.

  PERFORM refresh_grid.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form handle_change_finished
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*&      --> E_MODIFIED
*&      --> ET_GOOD_CELLS
*&---------------------------------------------------------------------*
FORM handle_change_finished  USING    pv_modified
                                      pt_good_cells TYPE lvc_t_modi.

  LOOP AT pt_good_cells INTO DATA(ls_modi).

  ENDLOOP.

ENDFORM.

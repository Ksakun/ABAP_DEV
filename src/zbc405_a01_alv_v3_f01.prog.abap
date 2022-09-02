*&---------------------------------------------------------------------*
*& Include          ZBC405_A01_ALV_V3_F01
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

  SELECT *
    FROM ztsbook_a01
    INTO CORRESPONDING FIELDS OF TABLE gt_book
    WHERE carrid   IN so_car
      AND connid   IN so_con
      AND fldate   IN so_fld
      AND customid IN so_cus.

  IF sy-subrc = 0. "ZTSBOOK_A01뒤에 해당하는 고객정보를 가져오기 위해 / INNER JOIN 가능할까?

    gt_temp = gt_book.
    DELETE gt_temp WHERE customid = space.

    SORT gt_temp BY customid.
    DELETE ADJACENT DUPLICATES FROM gt_temp COMPARING customid.

    SELECT *
      FROM ztscustom_a01
      INTO TABLE gt_custom
      FOR ALL ENTRIES IN gt_temp
     WHERE id = gt_temp-customid.
  ENDIF.


  "Exception Handling - 신호등  / luggage 무게가 25 이상이면 빨강
  LOOP AT gt_book INTO gs_book.
    IF gs_book-luggweight > 25.
      gs_book-light = 1. "빨간불
    ELSEIF gs_book-luggweight > 15.
      gs_book-light = 2. "노랑
    ELSE.
      gs_book-light = 3. "초록
    ENDIF.

    "Color Setting : First class면 row 컬러를 변경하겠다.
    IF gs_book-class = 'F'.
      gs_book-row_color = 'C710'.
    ENDIF.

    "Color Setting : Smoker면 빨간색으로 표현한다.
    IF gs_book-smoker = 'X'.

      gs_color-fname = 'SMOKER'.
      gs_color-color-col = '6'. "col_negative ==> type-pool col 확인해보기.
      gs_color-color-int = '1'.
      gs_color-color-inv = '0'.
      APPEND gs_color TO gs_book-it_color.

    ENDIF.

    "APPEND new Catalog
    READ TABLE gt_custom INTO gs_custom WITH KEY id = gs_book-customid.
    IF sy-subrc = 0.
      gs_book-telephone = gs_custom-telephone.
      gs_book-email     = gs_custom-email.
    ENDIF.

    MODIFY gt_book FROM gs_book.
    CLEAR gs_book.
  ENDLOOP.
ENDFORM.
*&---------------------------------------------------------------------*
*& Form set_setting
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM set_setting .

  PERFORM set_variant.
  PERFORM set_layout.
  PERFORM set_sort.
  PERFORM make_fieldcatalog.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form set_variant
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM set_variant .

  "Variant '입력시' 도 가능하게 밑에 줄 없으면 f4기능으로만 가능, 직접 입력해서는 반영안됨
  gs_variant-variant = p_layout.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form set_layout
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM set_layout .

  "sel mode 설정
  gs_layout-sel_mode = 'D'. "A,B,C,D

  "Exception Handling 신호등 설정
  gs_layout-excp_fname = 'LIGHT'.
  gs_layout-excp_led   = 'X'. "한구 짜리 신호등으로 바꾸겠다
  gs_layout-zebra      = 'X'.
  gs_layout-cwidth_opt = 'X'. "컬럼 압축시키기

  "Row Color 설정
  gs_layout-info_fname = 'ROW_COLOR'. "row Color 필드 설정 -> 구현 logic은 get data
  "Cell Color 설정
  gs_layout-ctab_fname = 'IT_COLOR'.
  "Style name 활용 (type에 선언해놓은것)
  gs_layout-stylefname = 'BT'.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form set_sort
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM set_sort .

  "Sort Condition #1
  CLEAR gs_sort.
  gs_sort-fieldname = 'CARRID'.
  gs_sort-up        = 'X'.
  gs_sort-spos      = '1'.
  APPEND gs_sort TO gt_sort.

  "Sort Condition #2
  CLEAR gs_sort.
  gs_sort-fieldname = 'CONNID'.
  gs_sort-up        = 'X'.
  gs_sort-spos      = '2'.
  APPEND gs_sort TO gt_sort.

  "Sort Condition #3
  CLEAR gs_sort.
  gs_sort-fieldname = 'FLDATE'.
  gs_sort-down        = 'X'.
  gs_sort-spos      = '3'.
  APPEND gs_sort TO gt_sort.
ENDFORM.
*&---------------------------------------------------------------------*
*& Form make_fieldcatalog
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM make_fieldcatalog .

*********기존에 있는 FIELD에 내용 추가하는 CATALOG*********
  CLEAR gs_fcat.
  gs_fcat-fieldname = 'LIGHT'. "gs_book에 있는 fieldname이어야함.
  gs_fcat-coltext   = 'Info'.
  APPEND gs_fcat TO gt_fcat.

  CLEAR gs_fcat.
  gs_fcat-fieldname = 'SMOKER'.
  gs_fcat-checkbox  = 'X'.
  APPEND gs_fcat TO gt_fcat.

  CLEAR gs_fcat.
  gs_fcat-fieldname = 'INVOICE'.
  gs_fcat-checkbox  = 'X'.
  APPEND gs_fcat TO gt_fcat.

  CLEAR gs_fcat.
  gs_fcat-fieldname = 'CANCELLED'.
  gs_fcat-checkbox  = 'X'.
  "수정 가능 기능 추가
  gs_fcat-edit     = p_edit.
  APPEND gs_fcat TO gt_fcat.

  CLEAR gs_fcat.
  gs_fcat-fieldname = 'PASSNAME'.
  gs_fcat-emphasize = 'C510'.
  APPEND gs_fcat TO gt_fcat.

*********새로운 FIELD를 추가하는  CATALOG*********
  CLEAR gs_fcat.
  gs_fcat-fieldname = 'TELEPHONE'.
  gs_fcat-ref_table = 'ZTSCUSTOM_A01'.
  gs_fcat-ref_field = 'TELEPHONE'.
  gs_fcat-emphasize = 'C510'.
  gs_fcat-col_pos   = '30'.
  APPEND gs_fcat TO gt_fcat.

  CLEAR gs_fcat.
  gs_fcat-fieldname = 'EMAIL'.
  gs_fcat-ref_table = 'ZTSCUSTOM_A01'.
  gs_fcat-ref_field = 'EMAIL'.
  gs_fcat-emphasize = 'C510'.
  gs_fcat-col_pos   = '31'.
  APPEND gs_fcat TO gt_fcat.

*********Column에 색을 추가하는  CATALOG*********
  CLEAR gs_fcat.
  gs_fcat-fieldname = 'CUSTOMID'.
  "수정 가능 기능 추가
  gs_fcat-edit     = p_edit.
  APPEND gs_fcat TO gt_fcat.
ENDFORM.
*&---------------------------------------------------------------------*
*& Form customer_change_part
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*&      --> ER_DATA_CHANGED
*&      --> LS_MOD_CELLS
*&---------------------------------------------------------------------*
FORM customer_change_part  USING    p_change TYPE REF TO cl_alv_changed_data_protocol "er_data_changed
                                    p_cells  TYPE lvc_s_modi.                         "ls_mod_cell

  DATA: l_customid TYPE ztsbook_a01-customid,
        l_phone    TYPE ztscustom_a01-telephone,
        l_email    TYPE ztscustom_a01-email,
        l_name     TYPE ztscustom_a01-name.

  READ TABLE gt_book INTO gs_book INDEX p_cells-row_id.

  CALL METHOD p_change->get_cell_value
    EXPORTING
      i_row_id    = p_cells-row_id   "ls_mod_cell에서 내가 찍은 cell의 id를 가져와라
*     i_tabix     =
      i_fieldname = 'CUSTOMID'
    IMPORTING
      e_value     = l_customid.


  IF l_customid IS NOT INITIAL.

    READ TABLE gt_custom INTO gs_custom WITH KEY id = l_customid.

    IF sy-subrc = 0. "id가 있다면 그냥 읽고 없으면 DB TABLE에서 읽어와야한다.

      l_phone = gs_custom-telephone.
      l_email = gs_custom-email.
      l_name  = gs_custom-name.

    ELSE. "정보가 없기 때문에 DB에서 읽어와라

      SELECT SINGLE telephone email name
        FROM ztscustom_a01
        INTO (l_phone, l_email, l_name)
       WHERE id = l_customid.

    ENDIF.
  ELSE.
    CLEAR: l_phone, l_email, l_name.
  ENDIF.
  "CALL Method modify cell - Telephone
  CALL METHOD p_change->modify_cell
    EXPORTING
      i_row_id    = p_cells-row_id
      i_fieldname = 'TELEPHONE'
      i_value     = l_phone.


  "Call Method modify cell - email
  CALL METHOD p_change->modify_cell
    EXPORTING
      i_row_id    = p_cells-row_id
      i_fieldname = 'EMAIL'
      i_value     = l_email.

  CALL METHOD p_change->modify_cell
    EXPORTING
      i_row_id    = p_cells-row_id
      i_fieldname = 'PASSNAME'
      i_value     = l_name.

  gs_book-email = l_email.
  gs_book-telephone = l_phone.
  gs_book-passname = l_name.

  MODIFY gt_book FROM gs_book INDEX p_cells-row_id.

ENDFORM.

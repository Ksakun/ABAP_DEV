*&---------------------------------------------------------------------*
*& Report ZBC405_A01_0M
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zbc405_a01_0m.

TABLES spfli.

SELECT-OPTIONS: so_car FOR spfli-carrid MEMORY ID car,
                so_con FOR spfli-connid MEMORY ID con.

DATA: gt_spfli TYPE TABLE OF spfli,
      gs_spfli TYPE spfli.

DATA: go_alv     TYPE REF TO cl_salv_table,
      go_func    TYPE REF TO cl_salv_functions_list,
      go_disp    TYPE REF TO cl_salv_display_settings,
      go_columns TYPE REF TO cl_salv_columns_table,
      go_column  TYPE REF TO cl_salv_column_table,
      go_cols    TYPE REF TO cl_salv_column,
      go_layout  TYPE REF TO cl_salv_layout,
      go_selc    TYPE REF TO cl_salv_selections.


START-OF-SELECTION.

  SELECT *
    FROM spfli
    INTO TABLE gt_spfli
    WHERE carrid IN so_car
      AND connid IN so_con.

  TRY.
      CALL METHOD cl_salv_table=>factory
        EXPORTING
          list_display = ' ' "if_salv_c_bool_sap=>false
*         r_container  =
*         container_name =
        IMPORTING
          r_salv_table = go_alv
        CHANGING
          t_table      = gt_spfli.
    CATCH cx_salv_msg.
  ENDTRY.

  "Toolbar Button 만들기
  CALL METHOD go_alv->get_functions
    RECEIVING
      value = go_func.

*  CALL METHOD go_func->set_sort_asc.
*  CALL METHOD go_func->set_sort_desc.


  CALL METHOD go_func->set_all.

*  -- Display Setting
  CALL METHOD go_alv->get_display_settings
    RECEIVING
      value = go_disp.

*  -- SALV Title
  CALL METHOD go_disp->set_list_header
    EXPORTING
      value = 'Demo Text Title'.

*  -- Zebra Pattern
  CALL METHOD go_disp->set_striped_pattern
    EXPORTING
      value = 'X'.


*  -- Get_columns ===> Field Catalog
  CALL METHOD go_alv->get_columns
    RECEIVING
      value = go_columns.

*  -- col_opt 기능과 같은 것 ( 컬럼 압축하기 )
  CALL METHOD go_columns->set_optimize
*  EXPORTING
*    value  = IF_SALV_C_BOOL_SAP~TRUE
    .

  TRY.
      CALL METHOD go_columns->get_column
        EXPORTING
          columnname = 'MANDT'
        RECEIVING
          value      = go_cols.
    CATCH cx_salv_not_found.
  ENDTRY.

  go_column ?= go_cols.   "Casting: Type이 달라도 구문오류 없이 인정하기 위해 선언.



  CALL METHOD go_column->set_technical.

  TRY.
      CALL METHOD go_columns->get_column
        EXPORTING
          columnname = 'FLTIME'
        RECEIVING
          value      = go_cols.
    CATCH cx_salv_not_found.
  ENDTRY.

  go_column ?= go_cols.   "Set Color가 go_column에 없기 때문에 같은 superclass를 갖는 go_cols에서 casting

  "Change Color
  DATA g_color TYPE lvc_s_colo.

  g_color-col = '5'.
  g_color-int = '1'.
  g_color-inv = '0'.

  CALL METHOD go_column->set_color
    EXPORTING
      value = g_color.

  "Layout Setting => LAYOUT VARIANT 만들게 하기
  DATA : p_program TYPE salv_s_layout_key.
  CALL METHOD go_alv->get_layout
    RECEIVING
      value = go_layout.

  p_program-report = sy-cprog.

  CALL METHOD go_layout->set_key
    EXPORTING
      value = p_program.

  CALL METHOD go_layout->set_save_restriction
    EXPORTING
      value = if_salv_c_layout=>restrict_none.


  CALL METHOD go_layout->set_default
    EXPORTING
      value = 'X'.

  "ALV 앞에 SELECTION BUTTON 만들기 / layout selections
  CALL METHOD go_alv->get_selections
    RECEIVING
      value = go_selc.

  CALL METHOD go_selc->set_selection_mode
    EXPORTING
      value = if_salv_c_selection_mode=>row_column. "if_salv_c_selection_mode의 값을 찾아봐라.

  "Cell 도 여러개 선택하고 싶다면 selection mode method를 한번 더 호출.
  CALL METHOD go_selc->set_selection_mode
    EXPORTING
      value = if_salv_c_selection_mode=>cell. "multiple이랑 single은 개인이 알아보기.

  "Multiple : select 버튼 없이 여러 row 선택 가능
  "Single   : select 버튼 없이 한개의 row 선택 가능
  "Cell     : select 버튼 있이 여러개의 cell 선택 가능
  "ROW_COLUMN : select 버튼 있이 여러개의 row 선택 가능.


  CALL METHOD go_alv->display. "화면에 go_alv 보이기

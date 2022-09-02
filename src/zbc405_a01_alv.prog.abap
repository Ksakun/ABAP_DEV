*&---------------------------------------------------------------------*
*& Report ZBC405_A01_ALV
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zbc405_a01_alv.

TYPES : BEGIN OF typ_flt.
          INCLUDE TYPE sflight.
TYPES :   changes_possible TYPE icon-id.
TYPES : btn_text TYPE c LENGTH 10.
TYPES : tankcap  TYPE saplane-tankcap,
        cap_unit TYPE saplane-cap_unit,
        weight   TYPE saplane-weight,
        wei_unit TYPE saplane-wei_unit.

TYPES :   light TYPE c LENGTH 1.
TYPES : row_color TYPE c LENGTH 4.
TYPES : it_color    TYPE lvc_t_scol.
TYPES : it_styl     TYPE lvc_t_styl.
TYPES : END OF typ_flt.


DATA: gt_flt  TYPE TABLE OF typ_flt,
      gs_flt  TYPE typ_flt,
      ok_code TYPE sy-ucomm.
"ALV DATA 선언
DATA: go_container TYPE REF TO cl_gui_custom_container, "Container 클래스 참조하는 변수 선언
      go_alv_grid  TYPE REF TO cl_gui_alv_grid,         "ALV grid 클래스를 참조하는 변수 선언
      gv_variant   TYPE disvariant,                     "Variant 설정을 위한 변수 선언
      gv_save,                                          "Variant를 저장할 수 있는 변수 선언
      gs_layout    TYPE lvc_s_layo,
      gt_sort      TYPE lvc_t_sort,
      gs_sort      TYPE lvc_s_sort,
      gs_color     TYPE lvc_s_scol,
      gt_exct      TYPE ui_functions,                   "For Toolbar Excluding
      gt_fcat      TYPE lvc_t_fcat,
      gs_fcat      TYPE lvc_s_fcat, "Field Catalog 용 workarea 선언
      gs_styl      TYPE lvc_s_styl. "Style 쓰는 work area 설정

DATA: gs_stable       TYPE lvc_s_stbl,
      gv_soft_refresh TYPE abap_bool.

"Event Handling Class
INCLUDE zbc405_a01_alv_class.

*----------Select-options

SELECT-OPTIONS: so_car FOR gs_flt-carrid MEMORY ID car,
                so_con FOR gs_flt-connid MEMORY ID con,
                so_dat FOR gs_flt-fldate.

SELECTION-SCREEN SKIP 3.

"새로운 Field catalog 추가 방법
PARAMETERS pa_date TYPE sy-datum DEFAULT '20211001'.
"사용자의 Variant에 따라 Variant모양의 layout을 보이게 하자
PARAMETERS pa_var TYPE disvariant-variant.

AT SELECTION-SCREEN ON VALUE-REQUEST FOR pa_var.

  gv_variant-report = sy-cprog.

  CALL FUNCTION 'LVC_VARIANT_SAVE_LOAD'
    EXPORTING
      i_save_load     = 'L' "S,F,L
    CHANGING
      cs_variant      = gv_variant
    EXCEPTIONS
      not_found       = 1
      wrong_input     = 2
      fc_not_complete = 3
      OTHERS          = 4.
  IF sy-subrc = 0.
    pa_var = gv_variant-variant.
  ENDIF.

START-OF-SELECTION.

  PERFORM get_data.

  CALL SCREEN 100.
*cl_demo_output=>display_data( gt_flt ).
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
*&      Module  USER_COMMAND_0100  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE user_command_0100 INPUT.
  CASE ok_code.
    WHEN 'BACK' OR 'CANC'.
      CALL METHOD go_alv_grid->free.
      CALL METHOD go_container->free.
      FREE: go_alv_grid, go_container.
      LEAVE TO SCREEN 0.
    WHEN 'EXIT'.
      LEAVE PROGRAM.
  ENDCASE.
ENDMODULE.
*&---------------------------------------------------------------------*
*& Module INIT_CONTROL_PROCESSING OUTPUT
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
MODULE init_control_processing OUTPUT.
  IF go_container IS INITIAL.
    "Container 생성
    CREATE OBJECT go_container
      EXPORTING
*       parent         =
        container_name = 'MY_CON_AREA'.
    IF sy-subrc <> 0.
      MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
                 WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
    ENDIF.
    "ALV GRID 생성
    CREATE OBJECT go_alv_grid
      EXPORTING
        i_parent = go_container "ALV Grid가 얹혀지는 Container의 이름
      EXCEPTIONS
        OTHERS   = 5.
    IF sy-subrc <> 0.
      MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
                 WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
    ENDIF.

    "Subroutines
    PERFORM make_variant.
    PERFORM make_layout.
    PERFORM make_sort.
    PERFORM make_fieldcatalog.
    "Toolbar Excluding
    APPEND cl_gui_alv_grid=>mc_fc_filter TO gt_exct.
    APPEND cl_gui_alv_grid=>mc_fc_info TO gt_exct.

*    APPEND cl_gui_alv_grid=>mc_fc_excl_all TO gt_exct. "Toolbar 전체 사라지게하는 것.

    "Event Handling 하기위한 trigger (220804 오전)

    SET HANDLER lcl_handler=>on_doubleclick FOR go_alv_grid.
    SET HANDLER lcl_handler=>on_hotspot     FOR go_alv_grid.
    SET HANDLER lcl_handler=>on_toolbar     FOR go_alv_grid.
    SET HANDLER lcl_handler=>on_user_command FOR go_alv_grid.
    SET HANDLER lcl_handler=>on_button_click FOR go_alv_grid.
    SET HANDLER lcl_handler=>on_context_menu_request FOR go_alv_grid.
    SET HANDLER lcl_handler=>on_before_user_comm     FOR go_alv_grid.
    "GRID를 띄우기 위한 METHOD
    CALL METHOD go_alv_grid->set_table_for_first_display
      EXPORTING
*       i_buffer_active      =
*       i_bypassing_buffer   =
*       i_consistency_check  =
        i_structure_name     = 'SFLIGHT'
        is_variant           = gv_variant
        i_save               = gv_save
        i_default            = 'X'
        is_layout            = gs_layout
*       is_print             =
*       it_special_groups    =
        it_toolbar_excluding = gt_exct
*       it_hyperlink         =
*       it_alv_graphics      =
*       it_except_qinfo      =
*       ir_salv_adapter      =
      CHANGING
        it_outtab            = gt_flt
        it_fieldcatalog      = gt_fcat
        it_sort              = gt_sort
*       it_filter            =
*    EXCEPTIONS
*       invalid_parameter_combination = 1
*       program_error        = 2
*       too_many_lines       = 3
*       others               = 4
      .
    IF sy-subrc <> 0.
*   Implement suitable error handling here
    ENDIF.
  ELSE.

*    ON CHANGE OF gt_flt.
    gv_soft_refresh = 'X'.
    gs_stable-row = 'X'.
    gs_stable-col = 'X'.

    CALL METHOD go_alv_grid->refresh_table_display
      EXPORTING
        is_stable      = gs_stable
        i_soft_refresh = gv_soft_refresh
      EXCEPTIONS
        finished       = 1
        OTHERS         = 2.
    IF sy-subrc <> 0.
*     Implement suitable error handling here
    ENDIF.


  ENDIF.





ENDMODULE.
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
    FROM sflight
    INTO CORRESPONDING FIELDS OF TABLE gt_flt
   WHERE carrid IN so_car
     AND connid IN so_con
     AND fldate IN so_dat.

  LOOP AT gt_flt INTO gs_flt.
    IF gs_flt-seatsocc < 5 .
      gs_flt-light = 1. " Red Light
    ELSEIF gs_flt-seatsocc < 100.
      gs_flt-light = 2.
    ELSE.
      gs_flt-light = 3.
    ENDIF.

    IF gs_flt-fldate+4(2) = sy-datum+4(2). "FLDATE의 월이 오늘의 월과 같다면 색을 달리해라
      gs_flt-row_color = 'C511'.
    ENDIF.

    "비행기 기종이 747-400인 것만 색깔을 넣어줘라
    IF gs_flt-planetype = '747-400'.
      CLEAR gs_color.
      gs_color-fname = 'PLANETYPE'.
      gs_color-color-col = col_total.
      gs_color-color-int = '1'.
      gs_color-color-inv = '0'.
      APPEND gs_color TO gs_flt-it_color.
    ENDIF.

    IF gs_flt-seatsocc_b = 0.
      CLEAR gs_color.
      gs_color-fname = 'SEATSOCC_B'.
      gs_color-color-col = col_negative.
      gs_color-color-int = '1'.
      gs_color-color-inv = '0'.
      APPEND gs_color TO gs_flt-it_color.
    ENDIF.

    "Changes Possible
    IF gs_flt-fldate < pa_date.
      gs_flt-changes_possible = icon_space.
    ELSE.
      gs_flt-changes_possible = icon_okay.
    ENDIF.

    "추가 버튼 만들기 (occ_b = max_b )인 것들만 버튼 보이게
    IF gs_flt-seatsmax_b = gs_flt-seatsocc_b.
      gs_flt-btn_text = 'Full Booked'.


      gs_styl-fieldname   = 'BTN_TEXT'.
      gs_styl-style       = cl_gui_alv_grid=>mc_style_button.
      APPEND gs_styl TO gs_flt-it_styl.
    ENDIF.

    SELECT SINGLE tankcap cap_unit weight wei_unit
      FROM saplane
      INTO ( gs_flt-tankcap, gs_flt-cap_unit, gs_flt-weight, gs_flt-wei_unit )
     WHERE planetype = gs_flt-planetype.

  modify gt_flt FROM gs_flt.
  ENDLOOP.



ENDFORM.
*&---------------------------------------------------------------------*
*& Form make_variant
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM make_variant .
  gv_variant-report = sy-cprog."sy-repid
  gv_variant = pa_var.
  gv_save = 'A'.
*    gv_save = 'U'.
*    gv_save = 'X'.
ENDFORM.
*&---------------------------------------------------------------------*
*& Form make_layout
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM make_layout .
  "Layout's Option
  gs_layout-zebra = 'X'. "얼룩무늬
  gs_layout-cwidth_opt = 'X'. "Field 크기를 압축
  gs_layout-sel_mode = 'D'. "보여지는 grid 선택하는 부분 만드는 것 ' ',A,B,C,D

  "Exception Handling Field 설정
  gs_layout-excp_fname = 'LIGHT'. "Grid에 신호등 나오게 하는 아이
  gs_layout-excp_led   = 'X'. "신호등 3개에서 하나로 바꾸기

  "Layout Row Color Setting
  gs_layout-info_fname = 'ROW_COLOR'. "Record(Row) 별로 색을 지정하기 위해

  "Layout Color Setting lvc_t_scol에 관련된 것.
  gs_layout-ctab_fname = 'IT_COL'. "Cell 단위로 색을 주고 싶을 때 logic은 get_data에

  "Make Style Layout
  gs_layout-stylefname = 'IT_STYL'.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form make_sort
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM make_sort .

  CLEAR gs_sort.
  gs_sort-fieldname = 'CARRID'.
  gs_sort-up = 'X'.
  gs_sort-spos = 1. "Sort의 순서
  APPEND gs_sort TO gt_sort.

  CLEAR gs_sort.
  gs_sort-fieldname = 'CONNID'.
  gs_sort-up = 'X'.
  gs_sort-spos = 2.
  APPEND gs_sort TO gt_sort.


  gs_sort-fieldname = 'FLDATE'.
  gs_sort-down = 'X'.
  gs_sort-spos = 3.
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

  CLEAR gs_fcat.
  gs_fcat-fieldname = 'CARRID'.
*  gs_fcat-hotspot   = 'X'.
  APPEND gs_fcat TO gt_fcat.

  CLEAR gs_fcat.
  gs_fcat-fieldname = 'LIGHT'.
  gs_fcat-coltext   = 'Info'.
  APPEND gs_fcat TO gt_fcat.

  CLEAR gs_fcat.
  gs_fcat-fieldname = 'PRICE'.
*  gs_fcat-no_out = 'X'.
*  gs_fcat-hotspot = 'X'. "Hot Spot Event와 연결된다.
  gs_fcat-col_opt = 'X'.
  gs_fcat-emphasize = 'C710'.
  APPEND gs_fcat TO gt_fcat.

  CLEAR gs_fcat.
  gs_fcat-fieldname = 'CHANGES_POSSIBLE'.
  gs_fcat-col_pos   = 5.
  gs_fcat-col_opt = 'X'. "새로 선언한 CATALOG FIELD SIZE 압축
  gs_fcat-coltext   = 'Changes'.
*  gs_fcat-tooltip   = 'Flight Changes Possible?'.
  APPEND gs_fcat TO gt_fcat.

  CLEAR gs_fcat.
  gs_fcat-fieldname = 'BTN_TEXT'.
  gs_fcat-coltext = 'Status'.
  gs_fcat-col_pos = 12.
  APPEND gs_fcat TO gt_fcat.

  CLEAR : gs_fcat.
  gs_fcat-fieldname = 'TANKCAP'.
  gs_fcat-ref_table = 'SAPLANE'.
  gs_fcat-ref_field = 'TANKCAP'.
  gs_fcat-col_pos = 20.
  APPEND gs_fcat TO gt_fcat.

  CLEAR : gs_fcat.
  gs_fcat-fieldname = 'CAP_UNIT'.
  gs_fcat-ref_table = 'SAPLANE'.
  gs_fcat-ref_field = 'CAP_UNIT'.
  gs_fcat-col_pos = 21.
  APPEND gs_fcat TO gt_fcat.


  CLEAR : gs_fcat.
  gs_fcat-fieldname = 'WEIGHT'.
  gs_fcat-ref_table = 'SAPLANE'.
  gs_fcat-ref_field = 'WEIGHT'.
  gs_fcat-col_pos = 22.
  APPEND gs_fcat TO gt_fcat.


  CLEAR : gs_fcat.
  gs_fcat-fieldname = 'WEI_UNIT'.
  gs_fcat-ref_table = 'SAPLANE'.
  gs_fcat-ref_field = 'WEI_UNIT'.
  gs_fcat-col_pos = 23.
  APPEND gs_fcat TO gt_fcat.

ENDFORM.

*&---------------------------------------------------------------------*
*& Include          YCL101_001_F01
*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*& Form select_data
*&---------------------------------------------------------------------*

FORM select_data .

  REFRESH gt_scarr.

*  SELECT carrid carrname currcode url
*    FROM scarr
*    INTO CORRESPONDING FIELDS OF TABLE gt_scarr
*   WHERE carrid   IN s_carr
*     AND carrname IN s_name.

  "강사님
  SELECT *
    FROM scarr
   WHERE carrid   IN @s_carr
     AND carrname IN @s_name
    INTO TABLE @gt_scarr.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form set_fcat_layout
*&---------------------------------------------------------------------*
FORM set_fcat_layout.

  CLEAR gs_layout.

  gs_layout-zebra      = 'X'. "ABAP_ON
  gs_layout-cwidth_opt = 'X'. "ABAP_ON
  gs_layout-sel_mode   = 'D'. "A: 행,열 선택 B: 단일행 C:복수행 D:셀단위


ENDFORM.
*&---------------------------------------------------------------------*
*& Form create_object_0100
*&---------------------------------------------------------------------*

FORM create_object_0100 .

  CREATE OBJECT gr_con
    EXPORTING
      repid                       = sy-repid                 " Report to Which This Docking Control is Linked
      dynnr                       = sy-dynnr                 " Screen to Which This Docking Control is Linked
      side                        = gr_con->dock_at_left     " Side to Which Control is Docked
      extension                   = 2000                     " Control Extension
    EXCEPTIONS
      cntl_error                  = 1                        " Invalid Parent Control
      cntl_system_error           = 2                        " System Error
      create_error                = 3                        " Create Error
      lifetime_error              = 4                        " Lifetime Error
      lifetime_dynpro_dynpro_link = 5                        " LIFETIME_DYNPRO_DYNPRO_LINK
      OTHERS                      = 6.

  CREATE OBJECT gr_split
    EXPORTING
      parent            = gr_con              " Parent Container
      rows              = 2                   " Number of Rows to be displayed
      columns           = 1                   " Number of Columns to be Displayed
    EXCEPTIONS
      cntl_error        = 1                   " See Superclass
      cntl_system_error = 2                   " See Superclass
      OTHERS            = 3.

  "방법#1
*  gr_split->get_container(
*    EXPORTING
*      row       = 1                          " Row
*      column    = 1                          " Column
*    RECEIVING                                " receiving은 단 하나의 변수만 받을 수 있다.
*                                             " ==> gr_con_top = gr_split->get_container 라는 것과 동일
*      container = gr_con_top                 " Container
*  ).

  gr_split->set_row_height(
  EXPORTING
    id                = 1                " Row ID
    height            = 10               " Height
  EXCEPTIONS
    cntl_error        = 1                " See CL_GUI_CONTROL
    cntl_system_error = 2                " See CL_GUI_CONTROL
    OTHERS            = 3
).



  "방법#2

  gr_con_top = gr_split->get_container( row = 1 column = 1 ).
  gr_con_alv = gr_split->get_container( row = 2 column = 1 ).

  "Object 생성 방법#1
*  gr_alv = NEW cl_gui_alv_grid(
**    i_shellstyle            = 0
**    i_lifetime              =
*    i_parent                =
**    i_appl_events           = space
**    i_parentdbg             =
**    i_applogparent          =
**    i_graphicsparent        =
**    i_name                  =
**    i_fcat_complete         = space
**    o_previous_sral_handler =
*  )
  "Object 생성 방법#2
  CREATE OBJECT gr_alv
    EXPORTING
      i_parent          = gr_con_alv       " Parent Container
    EXCEPTIONS
      error_cntl_create = 1                " Error when creating the control
      error_cntl_init   = 2                " Error While Initializing Control
      error_cntl_link   = 3                " Error While Linking Control
      error_dp_create   = 4                " Error While Creating DataProvider Control
      OTHERS            = 5.

*  "Object 생성 방법#3
*  gr_alv = NEW cl_gui_alv_grid( i_parent = gr_con_alv ).
*
*  "Object 생성 방법#4
*  gr_alv = NEW #( i_parent = gr_con_alv ).

ENDFORM.
*&---------------------------------------------------------------------*
*& Form set_alv_fcat_0100
*&---------------------------------------------------------------------*
FORM set_alv_fcat_0100 .

  DATA: lt_fcat TYPE kkblo_t_fieldcat.


  CALL FUNCTION 'K_KKB_FIELDCAT_MERGE'
    EXPORTING
      i_callback_program     = sy-repid                 " Internal table declaration program
*     i_tabname              = 'GS_SACRR'               " Name of table to be displayed
      i_strucname            = 'SCARR'
      i_inclname             = sy-repid
      i_bypassing_buffer     = abap_on                 " Ignore buffer while reading
      i_buffer_active        = abap_off
    CHANGING
      ct_fieldcat            = lt_fcat           " Field Catalog with Field Descriptions
    EXCEPTIONS
      inconsistent_interface = 1
      OTHERS                 = 2.


  IF lt_fcat IS NOT INITIAL.
    CALL FUNCTION 'LVC_TRANSFER_FROM_KKBLO'
      EXPORTING
        it_fieldcat_kkblo = lt_fcat
      IMPORTING
        et_fieldcat_lvc   = gt_fcat
      EXCEPTIONS
        it_data_missing   = 1
        OTHERS            = 2.
  ELSE.
    MESSAGE i000 WITH 'Making Field Catalog Error'.
  ENDIF.


ENDFORM.
*&---------------------------------------------------------------------*
*& Form display_alv_0100
*&---------------------------------------------------------------------*
FORM display_alv_0100 .

  CALL METHOD gr_alv->set_table_for_first_display
    EXPORTING
      is_layout                     = gs_layout        " Layout
    CHANGING
      it_outtab                     = gt_scarr         " Output Table
      it_fieldcatalog               = gt_fcat          " Field Catalog
    EXCEPTIONS
      invalid_parameter_combination = 1                " Wrong Parameter
      program_error                 = 2                " Program Errors
      too_many_lines                = 3                " Too many Rows in Ready for Input Grid
      OTHERS                        = 4.

ENDFORM.

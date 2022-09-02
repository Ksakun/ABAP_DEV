*&---------------------------------------------------------------------*
*& Include          YCL101_002_F01
*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*& Form init_alv
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM init_alv .
  IF gcl_container IS NOT BOUND.

    PERFORM create_object.
    PERFORM set_layout.
    PERFORM set_fcat.
    PERFORM display_screen.

  ELSE.

    PERFORM refresh_grid.

  ENDIF.
ENDFORM.
*&---------------------------------------------------------------------*
*& Form refresh_grid
*&---------------------------------------------------------------------*
FORM refresh_grid .

  DATA: ls_stable TYPE lvc_s_stbl.
  ls_stable-row = ' '.
  ls_stable-col = 'X'.

  CHECK gcl_grid IS BOUND.

  CALL METHOD gcl_grid->refresh_table_display
    EXPORTING
      is_stable      = ls_stable
      i_soft_refresh = space                    "SPACE:설정된  필터나, 정렬정보를 초기화한다.
      "X:설정된  필터나, 정렬정보를 유지한다.
    EXCEPTIONS
      finished       = 1
      OTHERS         = 2.


ENDFORM.
*&---------------------------------------------------------------------*
*& Form create_object
*&---------------------------------------------------------------------*
FORM create_object .
  CREATE OBJECT gcl_container
    EXPORTING
      container_name              = 'MY_CONTAINER'
    EXCEPTIONS
      cntl_error                  = 1
      cntl_system_error           = 2
      create_error                = 3
      lifetime_error              = 4
      lifetime_dynpro_dynpro_link = 5
      OTHERS                      = 6.

  gcl_grid = NEW cl_gui_alv_grid( i_parent = gcl_container ).




ENDFORM.
*&---------------------------------------------------------------------*
*& Form select_data
*&---------------------------------------------------------------------*
FORM select_data .

  REFRESH gt_data.


  RANGES: lr_carrid   FOR scarr-carrid,    "HEADER LINE을 갖는 인터널 테이블로 선언된다.
          lr_carrname FOR scarr-carrname.

  IF scarr-carrid IS INITIAL AND scarr-carrname IS INITIAL.
    "둘다 공백
  ELSEIF scarr-carrid IS INITIAL.

    "ID만 공백, 이름 입력
    lr_carrname-sign   = 'I'.
    lr_carrname-option = 'EQ'.
    lr_carrname-low    = scarr-carrname.
    APPEND lr_carrname.
    CLEAR lr_carrname.
  ELSEIF scarr-carrname IS INITIAL.

    "ID만 입력, 이름 공백
    lr_carrid-sign   = 'I'.
    lr_carrid-option = 'EQ'.
    lr_carrid-low    = scarr-carrid.
    APPEND lr_carrid.
    CLEAR  lr_carrid.

  ENDIF.

  SELECT *
    FROM scarr
    INTO CORRESPONDING FIELDS OF TABLE gt_data
   WHERE carrid   IN so_carr
     AND carrname IN so_name.



ENDFORM.
*&---------------------------------------------------------------------*
*& Form set_layout
*&---------------------------------------------------------------------*
FORM set_layout .

  CLEAR : gs_layout.

  gs_layout-zebra      = 'X'.
  gs_layout-sel_mode   = 'X'.
*  gs_layout-cwidth_opt = 'X'.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form set_fcat
*&---------------------------------------------------------------------*
FORM set_fcat .

  REFRESH gt_fcat.
  DATA lt_fcat TYPE kkblo_t_fieldcat.

  CALL FUNCTION 'K_KKB_FIELDCAT_MERGE'
    EXPORTING
      i_callback_program     = sy-repid
*     i_tabname              =
      i_strucname            = 'SCARR'
      i_inclname             = sy-repid
      i_bypassing_buffer     = 'X'
      i_buffer_active        = ' '
    CHANGING
      ct_fieldcat            = lt_fcat
    EXCEPTIONS
      inconsistent_interface = 1
      OTHERS                 = 2.

  IF lt_fcat IS INITIAL.
    MESSAGE i000 WITH 'Getting Field Catalog Failed'.

  ELSE.
    CALL FUNCTION 'LVC_TRANSFER_FROM_KKBLO'
      EXPORTING
        it_fieldcat_kkblo = lt_fcat
      IMPORTING
        et_fieldcat_lvc   = gt_fcat
      EXCEPTIONS
        it_data_missing   = 1
        OTHERS            = 2.
  ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form display_screen
*&---------------------------------------------------------------------*
FORM display_screen .

  CALL METHOD gcl_grid->set_table_for_first_display
    EXPORTING
      i_save                        = 'A'
      i_default                     = 'X'
      is_layout                     = gs_layout
    CHANGING
      it_outtab                     = gt_data
      it_fieldcatalog               = gt_fcat
    EXCEPTIONS
      invalid_parameter_combination = 1
      program_error                 = 2
      too_many_lines                = 3
      OTHERS                        = 4.

ENDFORM.

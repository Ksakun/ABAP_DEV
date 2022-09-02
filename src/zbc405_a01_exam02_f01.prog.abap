*&---------------------------------------------------------------------*
*& Include          ZBC405_A01_EXAM01_F01
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
    FROM ztspfli_a01
    INTO CORRESPONDING FIELDS OF TABLE gt_flight
   WHERE carrid IN so_car
     AND connid IN so_con.

  PERFORM get_grid_data.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form set_alv_setting
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM set_alv_setting.
  PERFORM set_variant.
  PERFORM set_layout.
  PERFORM make_fieldcatalog.
  PERFORM set_sort.
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

  gs_layout-sel_mode = 'D'.
  gs_layout-zebra    = 'X'.
  gs_layout-cwidth_opt = 'X'.
  gs_layout-excp_fname = 'LIGHT'.
  gs_layout-excp_led   = 'X'.
  gs_layout-ctab_fname = 'IT_COLOR'.
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
  CLEAR gs_sort.
  gs_sort-fieldname = 'CARRID'.
  gs_sort-up        = 'X'.
  gs_sort-spos      = '1'.
  APPEND gs_sort TO gt_sort.

  CLEAR gs_sort.
  gs_sort-fieldname = 'CONNID'.
  gs_sort-up        = 'X'.
  gs_sort-spos      = '2'.
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
  "Flight Time 에디팅 모드 변경 (기존 필드 변경)
  CLEAR gs_fcat.
  gs_fcat-fieldname = 'FLTIME'.
  gs_fcat-edit      = p_edit.
  APPEND gs_fcat TO gt_fcat.
  "Departure Time 에디팅 모드 변경
  CLEAR gs_fcat.
  gs_fcat-fieldname = 'DEPTIME'.
  gs_fcat-edit      = p_edit.
  APPEND gs_fcat TO gt_fcat.

  "ARRIVAL TIME, PERIOD 색추가
  CLEAR gs_fcat.
  gs_fcat-fieldname = 'ARRTIME'.
  gs_fcat-emphasize = 'C710'.
  APPEND gs_fcat TO gt_fcat.

  CLEAR gs_fcat.
  gs_fcat-fieldname = 'PERIOD'.
  gs_fcat-emphasize = 'C710'.
  APPEND gs_fcat TO gt_fcat.

  "FLTYPE 안보이게 하기
  CLEAR gs_fcat.
  gs_fcat-fieldname = 'FLTYPE'.
  gs_fcat-no_out    = 'X'.
  APPEND gs_fcat TO gt_fcat.

  "I&D Field 추가 pos = 5 (새 필드 추가)
  CLEAR gs_fcat.
  gs_fcat-fieldname = 'CHECKID'.
  gs_fcat-coltext   = 'I&D'.
  gs_fcat-col_pos   = '5'.
  APPEND gs_fcat TO gt_fcat.

  "Flight 아이콘 필드 추가 9
  CLEAR gs_fcat.
  gs_fcat-fieldname = 'FLIGHT'.
  gs_fcat-coltext   = 'FLIGHT'.
  gs_fcat-col_pos   = '9'.
  APPEND gs_fcat TO gt_fcat.
  "From Tzone :에디팅 모드 추가 17
  CLEAR gs_fcat.
  gs_fcat-fieldname = 'FTZONE'.
  gs_fcat-coltext   = 'FROM TZONE'.
  gs_fcat-col_pos   = '17'.
  APPEND gs_fcat TO gt_fcat.
  "To Tzone : 에디팅 모드 추가 18
  CLEAR gs_fcat.
  gs_fcat-fieldname = 'TTZONE'.
  gs_fcat-coltext   = 'TO TZONE'.
  gs_fcat-col_pos   = '18'.
  APPEND gs_fcat TO gt_fcat.
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
  gs_variant-variant = p_layout.
ENDFORM.
*&---------------------------------------------------------------------*
*& Form data_save
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM data_save .

  DATA: wt_flight TYPE TABLE OF ztspfli_a01,
        wa_flight TYPE ztspfli_a01.

  "Update
  LOOP AT gt_flight INTO gs_flight WHERE modified = 'X'.

    UPDATE ztspfli_a01
       SET fltime = gs_flight-fltime
           deptime = gs_flight-deptime
           arrtime = gs_flight-arrtime
           period  = gs_flight-period
     WHERE carrid  = gs_flight-carrid
       AND connid  = gs_flight-connid.

  ENDLOOP.
ENDFORM.
*&---------------------------------------------------------------------*
*& Form check_modified
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM check_modified USING p_cells TYPE lvc_s_modi.
  READ TABLE gt_flight INTO gs_flight INDEX p_cells-row_id.
  IF sy-subrc = 0.
    gs_flight-modified = 'X'.

    MODIFY gt_flight FROM gs_flight INDEX p_cells-row_id.
  ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form get_grid_data
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM get_grid_data .
  LOOP AT gt_flight INTO gs_flight.
    "Exception Hndling
    IF gs_flight-period GE 2.
      gs_flight-light = 1.
    ELSEIF gs_flight-period EQ 1.
      gs_flight-light = 2.
    ELSE.
      gs_flight-light = 3.
    ENDIF.

    "Check I&D field
    IF gs_flight-countryfr EQ gs_flight-countryto.
      gs_flight-checkid = 'D'.
      gs_color-fname     = 'CHECKID'.
      gs_color-color-col = '5'.
      gs_color-color-int = '1'.
      gs_color-color-inv = '0'.
      APPEND gs_color TO gs_flight-it_color.
      CLEAR gs_color.
    ELSE.
      gs_flight-checkid = 'I'.
      gs_color-fname     = 'CHECKID'.
      gs_color-color-col = '3'.
      gs_color-color-int = '1'.
      gs_color-color-inv = '0'.
      APPEND gs_color TO gs_flight-it_color.
      CLEAR gs_color.
    ENDIF.


    "FLTYPE 전세기 확인 전세기면 아이콘.
    IF gs_flight-fltype = 'X'.
      gs_flight-flight = icon_ws_plane.
    ENDIF.

    "Time zone
    SELECT SINGLE time_zone
      FROM sairport
      INTO gs_flight-ftzone
     WHERE id = gs_flight-airpfrom.

    SELECT SINGLE time_zone
      FROM sairport
      INTO gs_flight-ttzone
     WHERE id = gs_flight-airpto.

    MODIFY gt_flight FROM gs_flight.
  ENDLOOP.
ENDFORM.

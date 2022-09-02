*&---------------------------------------------------------------------*
*& Include          SAPMZC1010001_F01
*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*& Form f4_werks
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM f4_werks .

  SELECT werks, name1, ekorg, land1
    INTO TABLE @DATA(lt_werks)
    FROM t001w.

  IF sy-subrc <> 0.
    MESSAGE s001.
    EXIT.
  ENDIF.

  CALL FUNCTION 'F4IF_INT_TABLE_VALUE_REQUEST'
    EXPORTING
      retfield     = 'WERKS'
      dynpprog     = sy-repid
      dynpnr       = sy-dynnr
      dynprofield  = 'GS_DATA-WERKS'
      window_title = TEXT-t01
      value_org    = 'S'
    TABLES
      value_tab    = lt_werks.



ENDFORM.
*&---------------------------------------------------------------------*
*& Form get_data
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM get_data .

  SELECT matnr werks mtart matkl menge meins
         dmbtr waers
    FROM ztsa01mm
    INTO CORRESPONDING FIELDS OF TABLE gt_data.

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
  gs_layout-cwidth_opt = 'X'.
  gs_layout-sel_mode   = 'D'.

  IF gt_fcat IS INITIAL.
    PERFORM set_fcat USING:
          'X'     'MATNR'      ' '      'ZTSA01MM'    'MATNR'   ' '         ' ',
          ' '     'WERKS'      ' '      'ZTSA01MM'    'WERKS'   ' '         ' ',
          ' '     'MTART'      ' '      'ZTSA01MM'    'MTART'   ' '         ' ',
          ' '     'MATKL'      ' '      'ZTSA01MM'    'MATKL'   ' '         ' ',
          ' '     'MENGE'      ' '      'ZTSA01MM'    'MENGE'   'MEINS'     ' ',
          ' '     'MEINS'      ' '      'ZTSA01MM'    'MEINS'   ' '         ' ',
          ' '     'DMBTR'      ' '      'ZTSA01MM'    'DMBTR'   ' '         'WAERS',
          ' '     'WAERS'      ' '      'ZTSA01MM'    'WAERS'   ' '         ' '.




  ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form set_fcat
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*&      --> P_
*&      --> P_
*&      --> P_
*&      --> P_
*&      --> P_
*&---------------------------------------------------------------------*
FORM set_fcat  USING pv_key
                     pv_field
                     pv_text
                     pv_ref_table
                     pv_ref_field
                     pv_qfield
                     pv_cfield.

  gt_fcat = VALUE #( BASE gt_fcat
                    (
                      key        = pv_key
                      fieldname  = pv_field
                      coltext    = pv_text
                      ref_table  = pv_ref_table
                      ref_field  = pv_ref_field
                      qfieldname = pv_qfield
                      cfieldname = pv_cfield
                     )
                    ).

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

  DATA: ls_save TYPE ztsa01mm.
*        lt_save TYPE TABLE OF ztsa01mm.

  CLEAR: ls_save. "REFRESH lt_save.

  IF gs_data-matnr IS INITIAL OR gs_data-werks IS INITIAL.

    MESSAGE i000 WITH TEXT-e01 DISPLAY LIKE 'E'.

  ENDIF.

  ls_save = CORRESPONDING #( gs_data ).

*  APPEND ls_save TO lt_save. "하나를 넣는 거니까 굳이 테이블에 안들어가도됨

  MODIFY ztsa01mm FROM ls_save. "SUBRC가 무조건 0이다.

  IF sy-dbcnt > 0. "db테이블이 '한번이라도' crud가 된다면
    COMMIT WORK AND WAIT.
    MESSAGE i002.
  ELSE.
    ROLLBACK WORK.
    MESSAGE s000 WITH TEXT-m01 DISPLAY LIKE 'W'.
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

  DATA: ls_stable TYPE lvc_s_stbl.

  ls_stable-row = 'X'.
  ls_stable-col = 'X'.

  CALL METHOD gcl_grid->refresh_table_display
    EXPORTING
      is_stable      = ls_stable
      i_soft_refresh = space.

ENDFORM.

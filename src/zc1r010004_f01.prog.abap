*&---------------------------------------------------------------------*
*& Form set_param
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM set_param .
  pa_werks = '1010'.
ENDFORM.
*&---------------------------------------------------------------------*
*& Include          ZC1R010004_F01
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

*  CLEAR gs_data. REFRESH gt_data.
  CLEAR gs_data.
  _clear gt_data.

*  SELECT a~matnr b~maktx a~stlan a~stlnr a~stlal c~mtart c~matkl
*    FROM mast AS a INNER JOIN makt AS b
*    ON a~matnr  EQ b~matnr
*    AND b~spras EQ sy-langu
*                   INNER JOIN mara AS c
*    ON a~matnr EQ c~matnr
*    INTO CORRESPONDING FIELDS OF TABLE gt_data
*   WHERE a~werks = pa_werks
*     AND a~matnr IN so_matnr.
  "강사님

  SELECT a~matnr a~stlan a~stlnr a~stlal
         b~mtart b~matkl
*         c~maktx
    FROM mast AS a
   INNER JOIN mara AS b
      ON a~matnr = b~matnr
*    LEFT OUTER JOIN makt AS c
*      ON a~matnr  = c~matnr
*     AND c~spras  = sy-langu
    INTO CORRESPONDING FIELDS OF TABLE gt_data
   WHERE a~werks  = pa_werks
     AND b~matnr IN so_matnr.


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

  gs_layout-zebra      = 'X'.
  gs_layout-cwidth_opt = 'X'.
  gs_layout-sel_mode   = 'D'.

  IF gt_fcat IS INITIAL.
    PERFORM set_fcat USING:
          'X'   'MATNR'   ' '   'MAST'    'MATNR',
          ' '   'MAKTX'   ' '   'MAKT'    'MAKTX',
          ' '   'STLAN'   ' '   'MAST'    'STLAN',
          ' '   'STLNR'   ' '   'MAST'    'STLNR',
          ' '   'STLAL'   ' '   'MAST'    'STLAL',
          ' '   'MTART'   ' '   'MARA'    'MTART',
          ' '   'MATKL'   ' '   'MARA'    'MATKL'.
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
FORM set_fcat  USING pv_key pv_field pv_text pv_ref_table pv_ref_field.

*  gt_fcat = VALUE #( BASE gt_fcat
*                      ( key       = pv_key
*                        fieldname = pv_field
*                        coltext   = pv_text
*                        ref_table = pv_ref_table
*                        ref_field = pv_ref_field
*                        )
*                      ).

  gs_fcat = VALUE #(
                      key       = pv_key
                      fieldname = pv_field
                      coltext   = pv_text
                      ref_table = pv_ref_table
                      ref_field = pv_ref_field
                      ).

  CASE pv_field.
    WHEN 'STLNR'.
      gs_fcat-hotspot = 'X'.
  ENDCASE.


  APPEND gs_fcat TO gt_fcat.
ENDFORM.
*&---------------------------------------------------------------------*
*& Form set_handler
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM set_handler .

  SET HANDLER gcl_handler->on_doubleclick FOR gcl_grid.
  SET HANDLER gcl_handler->on_hotspot     FOR gcl_grid.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form get_mm03
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*&      --> E_COLUMN
*&      --> ES_ROW_NO
*&---------------------------------------------------------------------*
FORM get_mm03  USING  VALUE(p_column)
                      VALUE(p_row_no).

  CASE p_column.
    WHEN 'MATNR'.
      READ TABLE gt_data INTO gs_data INDEX p_row_no.
      IF sy-subrc = 0.

        SET PARAMETER ID: 'MAT' FIELD gs_data-matnr.
        CALL TRANSACTION 'MM03'.
      ENDIF.
  ENDCASE.
ENDFORM.
*&---------------------------------------------------------------------*
*& Form set_maktx
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM set_maktx .
  DATA: lv_tabix    TYPE sy-tabix,
        lv_code, lv_msg(100).

  IF gcl_maktx IS NOT BOUND.
    CREATE OBJECT gcl_maktx.
  ENDIF.

  LOOP AT gt_data INTO gs_data.
    lv_tabix = sy-tabix.

    CLEAR: lv_code, lv_msg.

    CALL METHOD gcl_maktx->get_material_name
      EXPORTING
        pi_matnr = gs_data-matnr
      IMPORTING
        pe_maktx = gs_data-maktx
        pe_code  = lv_code
        pe_msg   = lv_msg.

    IF lv_code = 'S'.
      MODIFY gt_data FROM gs_data INDEX lv_tabix TRANSPORTING maktx.
      CLEAR: gs_data.
    ENDIF.


  ENDLOOP.

ENDFORM.

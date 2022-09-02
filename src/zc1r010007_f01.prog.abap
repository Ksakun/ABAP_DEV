*&---------------------------------------------------------------------*
*& Include          ZC1R010007_F01
*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*& Form init_param
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM init_param .
  pa_bukrs = '1010'.
  pa_gjahr = sy-datum(4) - 1.
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

  _clear gs_data gt_data.

  SELECT b~belnr b~buzei b~shkzg b~dmbtr b~hkont
         a~blart a~budat a~waers
    FROM bkpf AS a INNER JOIN bseg AS b
      ON a~bukrs = b~bukrs
     AND a~belnr = b~belnr
     AND a~gjahr = b~gjahr
    INTO CORRESPONDING FIELDS OF TABLE gt_data
   WHERE a~bukrs = pa_bukrs
     AND a~gjahr = pa_gjahr
     AND a~belnr IN so_belnr
     AND a~blart IN so_blart.

  IF sy-subrc <> 0.
    MESSAGE i001.
    LEAVE LIST-PROCESSING.
  ENDIF.


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
  gs_layout-sel_mode   = 'D'.
  gs_layout-cwidth_opt = 'X'.

  IF gt_fcat IS INITIAL .

    PERFORM set_fcat USING:
          'X'   'BELNR'   ' '   'BSEG'  'BELNR',
          'X'   'BUZEI'   ' '   'BSEG'  'BUZEI',
          ' '   'BLART'   ' '   'BKPF'  'BLART',
          ' '   'BUDAT'   ' '   'BKPF'  'BUDAT',
          ' '   'SHKZG'   ' '   'BSEG'  'SHKZG',
          ' '   'DMBTR'   ' '   'BSEG'  'DMBTR',
          ' '   'WAERS'   ' '   'BKPF'  'WAERS',
          ' '   'HKONT'   ' '   'BSEG'  'HKONT'.

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

  gs_fcat = VALUE #(
                      key = pv_key
                      fieldname = pv_field
                      coltext  = pv_text
                      ref_table = pv_ref_table
                      ref_field = pv_ref_field ).

  CASE pv_field.
    WHEN 'DMBTR'.
      gs_fcat-cfieldname = 'WAERS'.
    WHEN 'BELNR'.
      gs_fcat-hotspot    = 'X'.

  ENDCASE.

  APPEND gs_fcat TO gt_fcat.

ENDFORM.

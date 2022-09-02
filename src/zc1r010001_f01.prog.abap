*&---------------------------------------------------------------------*
*& Include          ZC1R010001_F01
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

  pa_carr = 'KA'.

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
  CLEAR gs_data. REFRESH gt_data.

  SELECT carrid connid fldate price currency planetype
    FROM sflight
    INTO CORRESPONDING FIELDS OF TABLE gt_data
   WHERE carrid =  pa_carr
     AND connid IN so_conn.

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

  IF gt_fcat IS INITIAL.

    PERFORM set_fcat USING :
    'X'   'CARRID'         ' '   'SFLIGHT'  'CARRID',
    'X'   'CONNID'         ' '   'SFLIGHT'  'CARRID',
    'X'   'FLDATE'         ' '   'SFLIGHT'  'CARRID',
    ' '   'PRICE'          ' '   'SFLIGHT'  'CARRID',
    ' '   'CURRENCY'       ' '   'SFLIGHT'  'CARRID',
    ' '   'PLANETYPE'      ' '   'SFLIGHT'  'CARRID'.


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
FORM set_fcat  USING pv_key pv_field pv_text pv_ref_tabl pv_ref_field.

  gt_fcat = VALUE #( BASE gt_fcat
                     ( key = pv_key
                       fieldname = pv_field
                       coltext = pv_text
                       ref_table = pv_ref_tabl
                       ref_field = pv_ref_field
                       )
                     ).

  CASE pv_field.
    WHEN 'PRICE'.
      gs_fcat-cfieldname = 'CURRENCY'.
  ENDCASE.


  "위와 같은 내용의 구문법
*  gs_fcat-key = pv_key.
*  gs_fcat-fieldname = pv_field.
*  gs_fcat-coltext = pv_text.
*  gs_fcat-ref_table = pv_ref_tabl.
*  gs_fcat-ref_field = pv_ref_field.
*
  APPEND gs_fcat TO gt_fcat.
  CLEAR gs_fcat.

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
*       side      = dock_at_left
        extension = 3000.


    CREATE OBJECT gcl_grid
      EXPORTING
        i_parent = gcl_container.

    gs_variant-report = sy-repid.

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

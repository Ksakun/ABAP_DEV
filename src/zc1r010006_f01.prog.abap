*&---------------------------------------------------------------------*
*& Include          ZC1R010006_F01
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

  _clear gs_data gt_data.

  SELECT a~carrid a~carrname a~url
         b~connid b~fldate b~planetype b~price b~currency
    FROM scarr AS a INNER JOIN sflight AS b
      ON a~carrid = b~carrid
    INTO CORRESPONDING FIELDS OF TABLE gt_data
   WHERE a~carrid    IN so_carr
     AND b~connid    IN so_conn
     AND b~planetype IN so_pltp.


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
  gs_layout-sel_mode   = 'X'.

  PERFORM set_fcat USING:
        'X'   'CARRID'    ' '     'SCARR'     'CARRID',
        ' '   'CARRNAME'  ' '     'SCARR'     'CARRNAME',
        'X'   'CONNID'    ' '     'SFLIGHT'   'CONNID',
        'X'   'FLDATE'    ' '     'SFLIGHT'   'FLDATE',
        ' '   'PLANETYPE' ' '     'SFLIGHT'   'PLANETYPE',
        ' '   'PRICE'     ' '     'SFLIGHT'   'PRICE',
        ' '   'CURRENCY'  ' '     'SFLIGHT'   'CURRENCY',
        ' '   'URL'       ' '     'SCARR'     'URL'.


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
                     key   = pv_key
                     fieldname = pv_field
                     coltext   = pv_text
                     ref_table = pv_ref_table
                     ref_field = pv_ref_field
                     ).

  CASE pv_field.
    WHEN 'PRICE'.
      gs_fcat = VALUE #( BASE gs_fcat
                            cfieldname = 'CURRENCY').
    WHEN 'PLANETYPE'.
      gs_fcat = VALUE #( BASE gs_fcat
                            hotspot = 'X').
  ENDCASE.

  APPEND gs_fcat TO gt_fcat.
ENDFORM.
*&---------------------------------------------------------------------*
*& Form handle_hotspot
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*&      --> E_ROW_ID
*&      --> E_COLUMN_ID
*&---------------------------------------------------------------------*
FORM handle_hotspot  USING  ps_row_id    TYPE lvc_s_row
                            ps_column_id TYPE lvc_s_col.

  READ TABLE gt_data INTO gs_data INDEX ps_row_id-index.

  IF sy-subrc <> 0.
    MESSAGE i001.
    EXIT.
  ENDIF.

  CASE ps_column_id-fieldname.
    WHEN 'PLANETYPE'.
      IF gs_data-planetype IS INITIAL.
        MESSAGE i001.
        EXIT.
      ENDIF.

      PERFORM get_planetype_info USING gs_data-planetype.
  ENDCASE.



ENDFORM.
*&---------------------------------------------------------------------*
*& Form get_planetype_info
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*&      --> GS_DATA_PLANETYPE
*&---------------------------------------------------------------------*
FORM get_planetype_info  USING    pv_planetype TYPE saplane-planetype.

  _clear gs_plane gt_plane.

  SELECT planetype seatsmax seatsmax_b seatsmax_f producer
    FROM saplane
    INTO CORRESPONDING FIELDS OF TABLE gt_plane
   WHERE planetype = pv_planetype.

  IF gt_plane IS INITIAL.
    MESSAGE i001.
    EXIT.
  ENDIF.

  CALL SCREEN '0101' STARTING AT 20 3.


ENDFORM.
*&---------------------------------------------------------------------*
*& Form set_fcat_layout_pop1
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM set_fcat_layout_pop1 .

  gs_layout_pop1-zebra      = 'X'.
  gs_layout_pop1-cwidth_opt = 'X'.
  gs_layout_pop1-sel_mode   = 'D'.
  gs_layout_pop1-no_toolbar = 'X'.

  PERFORM set_fcat_pop1 USING:
        'X'   'PLANETYPE'   ' '   'SAPLANE'     'PLANETYPE',
        ' '   'SEATSMAX'    ' '   'SAPLANE'     'SEATSMAX',
        ' '   'SEATSMAX_B'  ' '   'SAPLANE'     'SEATSMAX_B',
        ' '   'SEATSMAX_F'  ' '   'SAPLANE'     'SEATSMAX_F',
        ' '   'PRODUCER'    ' '   'SAPLANE'     'PRODUCER'.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form set_fcat_pop1
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*&      --> P_
*&      --> P_
*&      --> P_
*&      --> P_
*&      --> P_
*&---------------------------------------------------------------------*
FORM set_fcat_pop1  USING pv_key pv_field pv_text pv_ref_table pv_ref_field.

  gt_fcat_pop1 = VALUE #( BASE gt_fcat_pop1
                          (
                            key       = pv_key
                            fieldname = pv_field
                            coltext   = pv_text
                            ref_table = pv_ref_table
                            ref_field = pv_ref_field
                           )
                         ).

ENDFORM.
*&---------------------------------------------------------------------*
*& Form display_screen_pop1
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM display_screen_pop1 .
  IF gcl_container_pop1 IS NOT BOUND.

    CREATE OBJECT gcl_container_pop1
      EXPORTING
        container_name = 'GCL_CONTAINER_POP1'.

    CREATE OBJECT gcl_grid_pop1
      EXPORTING
        i_parent = gcl_container_pop1.



    CALL METHOD gcl_grid_pop1->set_table_for_first_display
      EXPORTING
        i_save          = 'A'
        i_default       = 'X'
        is_layout       = gs_layout_pop1
      CHANGING
        it_outtab       = gt_plane
        it_fieldcatalog = gt_fcat_pop1.
  ENDIF.
ENDFORM.

*&---------------------------------------------------------------------*
*& Include          ZC1R010002_F01
*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*& Form set_init
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM set_init .
  pa_werks = '1010'.
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

  SELECT a~matnr a~mtart a~matkl a~meins a~tragr
         c~pstat c~dismm c~ekgrp
    FROM mara AS a INNER JOIN marc AS c
      ON a~matnr = c~matnr
    INTO CORRESPONDING FIELDS OF TABLE gt_data
   WHERE c~werks = pa_werks
     AND a~matnr IN so_matnr
     AND a~mtart IN so_mtart
     AND c~ekgrp IN so_ekgrp.

  IF sy-subrc <> 0.
    MESSAGE i001(zmcsa01).
    LEAVE LIST-PROCESSING.
  ENDIF.

*  cl_demo_output=>display( gt_data ).

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

  "layout
  gs_layout-zebra      = 'X'.
  gs_layout-cwidth_opt = 'X'.
  gs_layout-sel_mode   = 'D'.

  PERFORM set_fcat USING :
        'X'     'MATNR'     ' '    'MARA'   'MATNR',
        ' '     'MTART'     ' '    'MARA'   'MATNR',
        ' '     'MATKL'     ' '    'MARA'   'MATNR',
        ' '     'MEINS'     ' '    'MARA'   'MATNR',
        ' '     'PSTAT'     ' '    'MARC'   'MATNR',
        ' '     'DISMM'     ' '    'MARC'   'MATNR',
        ' '     'EKGRP'     ' '    'MARC'   'MATNR'.


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

  gt_fcat = VALUE #( BASE gt_fcat
                     ( key       = pv_key
                       fieldname = pv_field
                       coltext   = pv_text
                       ref_table = pv_ref_table
                       ref_field = pv_ref_field
                       )
                      ).


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
  IF gcl_container IS INITIAL.

    CREATE OBJECT gcl_container
      EXPORTING
        repid     = sy-repid
        dynnr     = sy-dynnr
*       side      = DOCK_AT_LEFT
        extension = 3000.

    CREATE OBJECT gcl_grid
      EXPORTING
        i_parent = gcl_container.

    gs_variant-report = sy-repid.

    CALL METHOD gcl_grid->set_table_for_first_display
      EXPORTING
        is_variant       = gs_variant
        i_save           = 'A'
        i_default        = 'X'
        is_layout        = gs_layout
      CHANGING
        it_outtab        = gt_data
        it_fieldcatalog  = gt_fcat.









  ENDIF.
ENDFORM.

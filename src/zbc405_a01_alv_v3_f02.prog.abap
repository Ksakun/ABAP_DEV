*&---------------------------------------------------------------------*
*& Include          ZBC405_A01_ALV_V3_F02
*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*& Form insert_parts
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*&      --> ER_DATA_CHANGED
*&      --> LS_INS_CELLS
*&---------------------------------------------------------------------*
FORM insert_parts  USING    p_changed TYPE REF TO cl_alv_changed_data_protocol
                            p_cells TYPE lvc_s_moce.

  READ TABLE gt_book INTO gs_book INDEX p_cells-row_id.
  gs_book-carrid = so_car-low.
  gs_book-connid = so_con-low.
  gs_book-fldate = so_fld-low.

  CALL METHOD p_changed->modify_cell
    EXPORTING
      i_row_id    = p_cells-row_id
      i_fieldname = 'CARRID'
      i_value     = gs_book-carrid.


  CALL METHOD p_changed->modify_cell
    EXPORTING
      i_row_id    = p_cells-row_id
      i_fieldname = 'CONNID'
      i_value     = gs_book-connid.


  CALL METHOD p_changed->modify_cell
    EXPORTING
      i_row_id    = p_cells-row_id
      i_fieldname = 'FLDATE'
      i_value     = gs_book-fldate.

  CALL METHOD p_changed->modify_cell
    EXPORTING
      i_row_id    = p_cells-row_id
      i_fieldname = 'ORDER_DATE'
      i_value     = sy-datum.

  CALL METHOD p_changed->modify_cell
    EXPORTING
      i_row_id    = p_cells-row_id
      i_fieldname = 'CUSTTYPE'
      i_value     = 'P'.

  CALL METHOD p_changed->modify_cell
    EXPORTING
      i_row_id    = p_cells-row_id
      i_fieldname = 'CLASS'
      i_value     = 'C'.

  PERFORM modify_style USING p_changed
                             p_cells
                             'CONNID'.
  PERFORM modify_style USING p_changed
                             p_cells
                             'FLDATE'.


  PERFORM modify_style USING p_changed
                             p_cells
                             'CUSTTYPE'.
  PERFORM modify_style USING p_changed
                             p_cells
                             'CLASS'.
  PERFORM modify_style USING p_changed
                             p_cells
                             'DISCOUNT'.
  PERFORM modify_style USING p_changed
                             p_cells
                             'SMOKER'.
  PERFORM modify_style USING p_changed
                             p_cells
                             'LUGGWEIGHT'.
  PERFORM modify_style USING p_changed
                             p_cells
                             'WUNIT'.
  PERFORM modify_style USING p_changed
                             p_cells
                             'INVOICE'.
  PERFORM modify_style USING p_changed
                             p_cells
                             'FORCURAM'.
  PERFORM modify_style USING p_changed
                             p_cells
                             'FORCURKEY'.
  PERFORM modify_style USING p_changed
                             p_cells
                             'LOCCURAM'.
  PERFORM modify_style USING p_changed
                             p_cells
                             'LOCCURKEY'.
  PERFORM modify_style USING p_changed
                             p_cells
                             'ORDER_DATE'.
  PERFORM modify_style USING p_changed
                             p_cells
                             'AGENCYNUM'.




  MODIFY gt_book FROM gs_book INDEX p_cells-row_id .
ENDFORM.

*&---------------------------------------------------------------------*
*& Form modify_style
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM modify_style  USING  p_changed  TYPE REF TO
                             cl_alv_changed_data_protocol
                            p_cells TYPE lvc_s_moce
                            VALUE(p_val).

  CALL METHOD p_changed->modify_style
    EXPORTING
      i_row_id    = p_cells-row_id
      i_fieldname = p_val
      i_style     = cl_gui_alv_grid=>mc_style_enabled.


ENDFORM.
*&---------------------------------------------------------------------*
*& Form modify_check
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*&      --> LS_MOD_CELLS
*&---------------------------------------------------------------------*
FORM modify_check  USING    p_cells TYPE lvc_s_modi.

  READ TABLE gt_book INTO gs_book INDEX p_cells-row_id.
  IF sy-subrc = 0.
    gs_book-modified = 'X'.

    MODIFY gt_book FROM gs_book INDEX p_cells-row_id.
  ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form data_save
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
"Data를 DB에 실제로 저장하는 부분
FORM data_save .

  DATA: ins_book TYPE TABLE OF ztsbook_a01,
        wa_book  TYPE ztsbook_a01.
  "Update 대상
  LOOP AT gt_book INTO gs_book WHERE modified = 'X'.

    UPDATE ztsbook_a01
       SET customid = gs_book-customid
           cancelled = gs_book-cancelled
           passname  = gs_book-passname
     WHERE carrid = gs_book-carrid
       AND connid = gs_book-connid
       AND fldate = gs_book-fldate
       AND bookid = gs_book-bookid.
  ENDLOOP.

*  "Insert
*  DATA: next_number TYPE s_book_id,
*        ret_code    TYPE inri-returncode,
*        l_tabix     LIKE sy-tabix.
*
*  LOOP AT gt_book INTO gs_book WHERE bookid IS INITIAL.
*
*    l_tabix = sy-tabix.
*
*    CALL FUNCTION 'NUMBER_GET_NEXT'
*      EXPORTING
*        nr_range_nr             = '01'
*        object                  = 'ZBOOKID_A0'
*        subobject               = gs_book-carrid
*        ignore_buffer           = ' '
*      IMPORTING
*        number                  = next_number
*        returncode              = ret_code
*      EXCEPTIONS
*        interval_not_found      = 1
*        number_range_not_intern = 2
*        object_not_found        = 3
*        quantity_is_0           = 4
*        quantity_is_not_1       = 5
*        interval_overflow       = 6
*        buffer_overflow         = 7
*        OTHERS                  = 8.
*    IF sy-subrc <> 0.
** Implement suitable error handling here
*    ELSE.
*
*      IF next_number IS NOT INITIAL.
*        gs_book-bookid = next_number.
*
*        MOVE-CORRESPONDING gs_book TO wa_book .
*        APPEND wa_book TO ins_book.
*
*        "internal table 변경
*        MODIFY gt_book FROM gs_book INDEX l_tabix TRANSPORTING bookid.
*      ENDIF.
*    ENDIF.
*  ENDLOOP.
*
*  IF ins_book IS NOT INITIAL.
*    INSERT ztsbook_a01 FROM TABLE ins_book.
*  ENDIF.

*  "Delete
*  IF dl_book IS NOT INITIAL.
*    DELETE ztsbook_a01 FROM TABLE dl_book.
*    CLEAR: dl_book. REFRESH: dl_book.

*  ENDIF.
ENDFORM.

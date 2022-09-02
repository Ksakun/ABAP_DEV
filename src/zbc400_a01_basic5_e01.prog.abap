*&---------------------------------------------------------------------*
*& Include          ZBC400_A01_BASIC5_E01
*&---------------------------------------------------------------------*


START-OF-SELECTION.

  SELECT carrid connid fldate bookid  customid custtype invoice class
    FROM sbook
    INTO CORRESPONDING FIELDS OF TABLE gt_book
   WHERE carrid   = pa_carr
     AND connid   IN so_con
     AND fldate   IN so_dat
     AND custtype = pa_cust
     AND bookid   IN so_bid
     AND customid IN so_cid.

  IF sy-subrc <> 0.
    MESSAGE i001(zmcsa01).
    RETURN.
  ENDIF.

  LOOP AT gt_book INTO gs_book.
    lv_tabix = sy-tabix.

*    IF gs_book-invoice = 'X'.
*      gs_book-class = 'F'.
*    ENDIF.

    CASE 'X'.
      WHEN gs_book-invoice.
        gs_book-class = 'F'.
        MODIFY gt_book FROM gs_book INDEX lv_tabix TRANSPORTING class.
    ENDCASE.

    CLEAR gs_book.

  ENDLOOP.

  cl_demo_output=>display_data( gt_book ).

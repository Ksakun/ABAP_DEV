*&---------------------------------------------------------------------*
*& Include ZBC400_A01_BASIC5_TOP                    - Report ZBC400_A01_BASIC5
*&---------------------------------------------------------------------*
REPORT zbc400_a01_basic5.

TABLES sbook.

DATA: BEGIN OF gs_book,
        carrid   TYPE sbook-carrid,
        connid   TYPE sbook-connid,
        fldate   TYPE sbook-fldate,
        bookid   TYPE sbook-bookid,
        customid TYPE sbook-customid,
        custtype TYPE sbook-custtype,
        invoice  TYPE sbook-invoice,
        class    TYPE sbook-class,
      END OF gs_book.


DATA: gt_book LIKE TABLE OF gs_book,
      lv_tabix TYPE sy-tabix.

CLEAR gs_book. REFRESH gt_book.


SELECTION-SCREEN BEGIN OF BLOCK b1 WITH FRAME TITLE TEXT-001.

  PARAMETERS pa_carr TYPE sbook-carrid OBLIGATORY DEFAULT 'AA'.

  SELECT-OPTIONS so_con FOR sbook-connid OBLIGATORY.

  PARAMETERS pa_cust TYPE sbook-custtype AS LISTBOX VISIBLE LENGTH 15 OBLIGATORY DEFAULT 'B'.

  SELECT-OPTIONS: so_dat FOR sbook-fldate DEFAULT sy-datum,
                  so_bid FOR sbook-bookid,
                  so_cid FOR sbook-customid NO INTERVALS NO-EXTENSION.

SELECTION-SCREEN END OF BLOCK b1.

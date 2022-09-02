*&---------------------------------------------------------------------*
*& Include          ZBC400_A01_BASIC6_E01
*&---------------------------------------------------------------------*

  AT SELECTION-SCREEN ON VALUE-REQUEST FOR p_carr.
    PERFORM f4_carrid.

  START-OF-SELECTION.

    SELECT f~carrid f~connid f~fldate planetype currency
           b~bookid b~customid b~custtype b~class b~agencynum
      FROM sflight AS f INNER JOIN sbook AS b
        ON f~carrid = b~carrid
       AND f~connid = b~connid
       AND f~fldate = b~fldate
      INTO CORRESPONDING FIELDS OF TABLE gt_data1
     WHERE f~carrid    = pa_carr
       AND f~connid  IN so_con
       AND f~planetype = pa_pltp
       AND b~bookid  IN so_bid.

    IF sy-subrc <> 0.
      MESSAGE i001(zmcsa01).
      RETURN.
    ENDIF.


    LOOP AT gt_data1 INTO gs_data1.
*    lv_tabix = sy-tabix.

      CASE gs_data1-custtype.
        WHEN 'B'.
*        gs_data2-carrid    = gs_data1-carrid.
*        gs_data2-connid    = gs_data1-connid.
*        gs_data2-fldate    = gs_data1-fldate.
*        gs_data2-bookid    = gs_data1-bookid.
*        gs_data2-customid  = gs_data1-customid.
*        gs_data2-custtype  = gs_data1-custtype.
*        gs_data2-agencynum = gs_data1-agencynum.
          MOVE-CORRESPONDING gs_data1 TO gs_data2.
          APPEND gs_data2 TO gt_data2.
      ENDCASE.
      CLEAR gs_data1.
    ENDLOOP.

    SORT gt_data2 ASCENDING BY carrid connid fldate bookid.
    DELETE ADJACENT DUPLICATES FROM gt_data2 COMPARING carrid connid fldate.

    IF sy-subrc = 0.
      cl_demo_output=>display_data( gt_data2 ).
    ELSE.
      MESSAGE i005(zmcsa01).
      LEAVE LIST-PROCESSING.
    ENDIF.

*&---------------------------------------------------------------------*
*& Include          ZC1R010004_F02
*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*& Form handle_double_click
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*&      --> E_ROW
*&      --> E_COLUMN
*&---------------------------------------------------------------------*
FORM handle_double_click  USING    p_row    TYPE lvc_s_row
                                   p_column TYPE lvc_s_col.

  READ TABLE gt_data INTO gs_data INDEX p_row-index.
  IF sy-subrc <> 0.
    EXIT.
  ENDIF.

  CASE p_column-fieldname.
    WHEN 'MATNR'.
      IF gs_data-matnr IS INITIAL.
        EXIT.
      ENDIF.

      SET PARAMETER ID : 'MAT' FIELD gs_data-matnr.

      CALL TRANSACTION 'MM03' AND SKIP FIRST SCREEN.
  ENDCASE.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form handle_hotspot
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*&      --> E_ROW_ID
*&      --> E_COLUMN_ID
*&---------------------------------------------------------------------*
FORM handle_hotspot  USING    ps_row_id     TYPE lvc_s_row
                              ps_column_id  TYPE lvc_s_col.

  READ TABLE gt_data INTO gs_data INDEX ps_row_id-index.

  IF sy-subrc <> 0.
    EXIT.
  ENDIF.

  CASE ps_column_id-fieldname.
    WHEN 'STLNR'.
      IF gs_data-stlnr IS INITIAL.
        EXIT.
      ENDIF.

      SET PARAMETER ID: 'MAT' FIELD gs_data-matnr,
                        'WRK' FIELD pa_werks,
                        'CSV' FIELD gs_data-stlan.

      CALL TRANSACTION 'CS03' AND SKIP FIRST SCREEN.
  ENDCASE.

ENDFORM.

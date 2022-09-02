*&---------------------------------------------------------------------*
*& Report ZBC401_A01_CLASS_02
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zbc401_a01_class_02.

DATA: go_airplane TYPE REF TO zcl_airplane_a01,
      gt_airplane TYPE TABLE OF REF TO zcl_airplane_a01,
      gv_count    TYPE i.


START-OF-SELECTION.

  CALL METHOD zcl_airplane_a01=>dispaly_n_o_airplanes.

  CREATE OBJECT go_airplane
    EXPORTING
      iv_name         = 'AA New York'
      iv_planetype    = '747-400'
    EXCEPTIONS
      wrong_planetype = 1.

  IF sy-subrc = 0.
    APPEND go_airplane TO gt_airplane.
  ELSE.
    WRITE: / 'No Airplane Name Exist'.
  ENDIF.

  CREATE OBJECT go_airplane
    EXPORTING
      iv_name         = 'LH Berline'
      iv_planetype    = 'A321'
    EXCEPTIONS
      wrong_planetype = 1
      OTHERS          = 2.

  IF sy-subrc = 0.
    APPEND go_airplane TO gt_airplane.
  ELSE.
    WRITE: / 'No Airplane Name Exist'.
  ENDIF.


  CREATE OBJECT go_airplane
    EXPORTING
      iv_name         = 'US Hercules'
      iv_planetype    = '747-200F'
    EXCEPTIONS
      wrong_planetype = 1
      OTHERS          = 2.

  IF sy-subrc = 0.
    APPEND go_airplane TO gt_airplane.
  ELSE.
    WRITE: / 'No Airplane Name Exist'.
  ENDIF.

  LOOP AT gt_airplane INTO go_airplane.
    go_airplane->display_attribute( ).
  ENDLOOP.

  SKIP 3.

  zcl_airplane_a01=>dispaly_n_o_airplanes( ).

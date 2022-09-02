*&---------------------------------------------------------------------*
*& Include          ZBC401_A01_CLASS_E01
*&---------------------------------------------------------------------*
CLASS lcl_airplane DEFINITION.

  PUBLIC SECTION. "airplane을 관리하는 것
    METHODS: constructor IMPORTING  iv_name      TYPE string
                                    iv_planetype TYPE saplane-planetype
                         EXCEPTIONS wrong_planetype.

    METHODS: set_attributes
      IMPORTING iv_name      TYPE string
                iv_planetype TYPE saplane-planetype,
      display_attributes.

    CLASS-METHODS: display_n_o_airplanes,
      get_n_o_airplanes RETURNING VALUE(rv_count) TYPE i.

    CLASS-METHODS: class_constructor.

  PRIVATE SECTION.

    TYPES ty_planetype TYPE TABLE OF saplane.

    DATA: mv_name      TYPE string,
          mv_planetype TYPE saplane-planetype,
          mv_weight    TYPE saplane-weight,
          mv_tankcap   TYPE saplane-tankcap.

    CLASS-DATA: gv_n_o_airplanes TYPE i.
    CLASS-DATA: gv_planetype TYPE ty_planetype.

    CLASS-METHODS: get_technical_attribute IMPORTING  iv_type    TYPE saplane-planetype
                                           EXPORTING  ev_weight  TYPE saplane-weight
                                                      ev_tankcap TYPE saplane-tankcap
                                           EXCEPTIONS wrong_planetype.
    CONSTANTS c_pos_i TYPE i VALUE 30.

ENDCLASS.


CLASS lcl_airplane IMPLEMENTATION.

  METHOD get_technical_attribute.

    DATA : ls_planetype TYPE saplane.

    READ TABLE gv_planetype INTO ls_planetype
                WITH KEY planetype = iv_type.

    IF sy-subrc EQ 0.

      ev_weight = ls_planetype-weight.
      ev_tankcap = ls_planetype-tankcap.
    ELSE.
      RAISE wrong_planetype.
    ENDIF.

  ENDMETHOD.



  METHOD class_constructor.
    SELECT *
      FROM saplane
      INTO TABLE gv_planetype.

  ENDMETHOD.


  METHOD constructor.
    DATA ls_planetype TYPE saplane.
    mv_name = iv_name.
    mv_planetype = iv_planetype.

    "여기를 get_technical attribute로 구현
*    SELECT SINGLE *
*      FROM saplane
*      INTO ls_planetype
*     WHERE planetype = iv_planetype.
*
*    IF sy-subrc NE 0.
*      RAISE wrong_planetype.
*    ELSE.
*      mv_weight = ls_planetype-weight.
*      mv_tankcap = ls_planetype-tankcap.
*
*      gv_n_o_airplanes = gv_n_o_airplanes + 1.
*
*    ENDIF.

    CALL METHOD get_technical_attribute
      EXPORTING
        iv_type = iv_planetype
      IMPORTING
        ev_weight = mv_weight
        ev_tankcap = mv_tankcap
      EXCEPTIONS
        wrong_planetype = 1.

    IF sy-subrc = 0.
      gv_n_o_airplanes = gv_n_o_airplanes + 1.
    ELSE.
      RAISE wrong_planetype.
    ENDIF.

  ENDMETHOD.

  METHOD set_attributes.
    mv_name = iv_name.
    mv_planetype = iv_planetype.
    gv_n_o_airplanes = gv_n_o_airplanes + 1.

  ENDMETHOD.

  METHOD display_attributes.
    WRITE: / icon_ws_plane AS ICON,
           / 'Airplane Name:', AT c_pos_i mv_name,
           / 'Type of Plane: ', AT c_pos_i mv_planetype,
           / 'Weight/Tank capacity: ', AT 20 mv_weight,  mv_tankcap.

  ENDMETHOD.

  METHOD display_n_o_airplanes."Static Method
    WRITE: / 'Number of Airplanes: ', AT c_pos_i gv_n_o_airplanes.

  ENDMETHOD.

  METHOD get_n_o_airplanes.
    rv_count = gv_n_o_airplanes.
  ENDMETHOD.

ENDCLASS.

DATA: go_airplane TYPE REF TO lcl_airplane,
      gt_airplane TYPE TABLE OF REF TO lcl_airplane,
      gv_count    TYPE i.

START-OF-SELECTION.

  lcl_airplane=>display_n_o_airplanes( ). "1번째 방법
*  CALL METHOD lcl_airplane=>display_n_o_airplanes. "2번째 방법

  "Constructor 없이 사용하는 방법
*  CREATE OBJECT go_airplane.
*  go_airplane->set_attributes( iv_name = 'LH Berline'
*                               iv_planetype = 'A321' ).
*  APPEND go_airplane TO gt_airplane.
*
*  CREATE OBJECT go_airplane.
*  APPEND go_airplane TO gt_airplane.
*  CALL METHOD go_airplane->set_attributes EXPORTING iv_name = 'AA New York'
*                                                    iv_planetype = '747-400'.
*
*  CREATE OBJECT go_airplane.
*  APPEND go_airplane TO gt_airplane.
*  go_airplane->set_attributes( iv_name = 'US Hercules'
*                               iv_planetype = '747-5645' ).
*
*  gv_count = lcl_airplane=>get_n_o_airplanes( ).


  "Constructor 사용하는 방법
  CREATE OBJECT go_airplane
    EXPORTING
      iv_name         = 'LH Berlin'
      iv_planetype    = 'A320-20'
    EXCEPTIONS
      wrong_planetype = 1.
  IF sy-subrc = 0.
    APPEND go_airplane TO gt_airplane.
  ELSE.
    WRITE: / 'Wrong Airplane Info'.
  ENDIF.

  CREATE OBJECT go_airplane
    EXPORTING
      iv_name         = 'AA New York'
      iv_planetype    = '747-400'
    EXCEPTIONS
      wrong_planetype = 1.
  IF sy-subrc = 0.
    APPEND go_airplane TO gt_airplane.
  ELSE.
    WRITE: / 'Wrong Airplane Info'.
  ENDIF.


  CREATE OBJECT go_airplane
    EXPORTING
      iv_name         = 'US Hercules'
      iv_planetype    = '747-200F'
    EXCEPTIONS
      wrong_planetype = 1.
  IF sy-subrc = 0.
    APPEND go_airplane TO gt_airplane.
  ELSE.
    WRITE: / 'Wrong Airplane Info'.
  ENDIF.


  LOOP AT gt_airplane INTO go_airplane.
    go_airplane->display_attributes( ).
  ENDLOOP.

*  lcl_airplane=>display_n_o_airplanes( ).
  SKIP 3.

  gv_count = lcl_airplane=>get_n_o_airplanes( ).
  WRITE:/ 'Total Number of Airplane: ', gv_count.

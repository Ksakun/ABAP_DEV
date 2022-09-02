*&---------------------------------------------------------------------*
*& Include          ZC1R010004_C01
*&---------------------------------------------------------------------*

CLASS lcl_handler DEFINITION FINAL."상속하지 않겠다.
  "Inheritance  : 상속성
  "Encapsulation: 캡슐화
  "Polymorphism : 다형성


  PUBLIC SECTION.

    CLASS-METHODS:

      on_doubleclick FOR EVENT double_click OF cl_gui_alv_grid
        IMPORTING
          e_row
          e_column
          es_row_no,

      on_hotspot     FOR EVENT hotspot_click OF cl_gui_alv_grid
        IMPORTING
          e_row_id
          e_column_id
          es_row_no.




ENDCLASS.



CLASS lcl_handler IMPLEMENTATION.

  METHOD on_doubleclick.
    "My Code
*    PERFORM get_mm03 USING e_column-fieldname
*                           es_row_no-row_id.

    "강사님 code
    PERFORM handle_double_click USING e_row e_column.
  ENDMETHOD.

  METHOD on_hotspot.

    PERFORM handle_hotspot USING e_row_id e_column_id.

  ENDMETHOD.


ENDCLASS.

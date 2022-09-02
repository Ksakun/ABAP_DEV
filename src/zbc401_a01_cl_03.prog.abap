*&---------------------------------------------------------------------*
*& Report ZBC401_T03_CL_03
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zbc401_a01_cl_03.

CLASS cl_1 DEFINITION.
  PUBLIC SECTION.
    DATA: num1 TYPE i.
    METHODS: pro IMPORTING num2 TYPE i.
    EVENTS: cutoff,
            show_other.
ENDCLASS.



CLASS cl_1 IMPLEMENTATION.
  METHOD pro.
    num1 = num2.
    IF num2 >= 2.
      RAISE EVENT cutoff.
    ELSE.
      RAISE EVENT show_other.
    ENDIF.
  ENDMETHOD.
ENDCLASS.


CLASS CL_event DEFINITION.
  PUBLIC SECTION.
    METHODS: handling_CUTOFF FOR EVENT cutoff OF cl_1,
      handling_show_other FOR EVENT show_other OF cl_1.
ENDCLASS.


CLASS CL_event IMPLEMENTATION.
  METHOD handling_show_other.
    WRITE: 'Handling zero'.
    WRITE: / 'Event has been processed'.
  ENDMETHOD.

  METHOD handling_CUTOFF.
    WRITE: 'Handling the CutOff'.
    WRITE: / 'Event has been processed'.
  ENDMETHOD.
ENDCLASS.


START-OF-SELECTION.

  parameters : p_int type i.

  DATA: main1 TYPE REF TO cl_1.
  DATA: eventh1 TYPE REF TO CL_event.

  CREATE OBJECT main1.
  CREATE OBJECT eventh1.

  SET HANDLER eventh1->handling_CUTOFF FOR main1.
  SET HANDLER eventh1->handling_show_other FOR main1.
  main1->pro( p_int ).

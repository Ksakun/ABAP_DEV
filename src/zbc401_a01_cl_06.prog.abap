*&---------------------------------------------------------------------*
*& Report ZBC401_T03_CL_06
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zbc401_a01_cl_06.


DATA : go_obj TYPE REF TO zcl_sflight_t03.

parameters : p_car type sflight-carrid.

START-OF-SELECTION.

  CREATE OBJECT go_obj.

  SET HANDLER go_obj->no_data FOR go_obj.

  CALL METHOD go_obj->get_data exporting
                             carrid = p_car.

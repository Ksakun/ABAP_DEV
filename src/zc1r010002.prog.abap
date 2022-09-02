*&---------------------------------------------------------------------*
*& Report ZC1R010002
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*

INCLUDE zc1r010002_top                          .  " Global Data
INCLUDE zc1r010002_s01                          .  " Selection Screen
INCLUDE zc1r010002_o01                          .  " PBO-Modules
INCLUDE zc1r010002_i01                          .  " PAI-Modules
INCLUDE zc1r010002_f01                          .  " FORM-Routines


INITIALIZATION.
  PERFORM set_init.


START-OF-SELECTION.

  PERFORM get_data.

  IF gt_data IS NOT INITIAL.
    CALL SCREEN 0100.
  ELSE.
    MESSAGE i001(zmcsa01).
    RETURN.
  ENDIF.

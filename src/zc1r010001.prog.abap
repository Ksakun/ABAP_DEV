*&---------------------------------------------------------------------*
*& Report ZC1R010001
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*

INCLUDE zc1r010001_top                          .  " Global Data

INCLUDE ZC1R010001_s01                          .  " Selection Screen
INCLUDE zc1r010001_o01                          .  " PBO-Modules
INCLUDE zc1r010001_i01                          .  " PAI-Modules
INCLUDE zc1r010001_f01                          .  " FORM-Routines


INITIALIZATION.
  PERFORM init_param.

START-OF-SELECTION.
  PERFORM get_data.

  IF gt_data IS NOT INITIAL.
    CALL SCREEN 100.
  ELSE.
    MESSAGE i001.
    STOP.
  ENDIF.

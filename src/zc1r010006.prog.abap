*&---------------------------------------------------------------------*
*& Report ZC1R010006
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*

INCLUDE zc1r010006_top                          .  " Global Data
INCLUDE zc1r010006_s01                          .  " Selection-screen
INCLUDE zc1r010006_c01                          .  " Local Class
INCLUDE zc1r010006_o01                          .  " PBO-Modules
INCLUDE zc1r010006_i01                          .  " PAI-Modules
INCLUDE zc1r010006_f01                          .  " FORM-Routines


START-OF-SELECTION.

  PERFORM get_data.

  IF gt_data IS NOT INITIAL.
    CALL SCREEN '0100'.
  ENDIF.

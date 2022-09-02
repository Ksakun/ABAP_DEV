*&---------------------------------------------------------------------*
*& Report ZC1R010004
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*

INCLUDE zc1r010004_top                          .  " Global Data
INCLUDE zc1r010004_s01                          .  " Selection Screen
INCLUDE zc1r010004_c01                          .  " Local Class-function
INCLUDE zc1r010004_o01                          .  " PBO-Modules
INCLUDE zc1r010004_i01                          .  " PAI-Modules
INCLUDE zc1r010004_f01                          .  " FORM-Routines
INCLUDE zc1r010004_f02                          .  " Teacher's Form

INITIALIZATION.

  PERFORM set_param.


START-OF-SELECTION.

  PERFORM get_data.
  PERFORM set_maktx.

  IF gt_data IS NOT INITIAL.
    CALL SCREEN '0100'.
  ELSE.
    MESSAGE i001.
    RETURN.
  ENDIF.

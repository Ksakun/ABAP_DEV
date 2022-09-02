*&---------------------------------------------------------------------*
*& Report ZC1R010008
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*

INCLUDE zc1r010008_top                          .    " Global Data
INCLUDE zc1r010008_s01                          .  " Selection Screen
INCLUDE zc1r010008_c01                          .  " Local Class
INCLUDE zc1r010008_o01                          .  " PBO-Modules
INCLUDE zc1r010008_i01                          .  " PAI-Modules
INCLUDE zc1r010008_f01                          .  " FORM-Routines


START-OF-SELECTION.
  PERFORM get_data.
  PERFORM set_style.

  CALL SCREEN '0100'.

*&---------------------------------------------------------------------*
*& Module Pool      SAPMZSA0104
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*

INCLUDE MZSA0106_TOP.
*INCLUDE mzsa0104_top                            .    " Global Data

INCLUDE MZSA0106_O01.
*INCLUDE mzsa0104_o01                            .  " PBO-Modules
INCLUDE MZSA0106_I01.
*INCLUDE mzsa0104_i01                            .  " PAI-Modules
INCLUDE MZSA0106_F01.
*INCLUDE mzsa0104_f01                            .  " FORM-Routines


LOAD-OF-PROGRAM.
  PERFORM set_default CHANGING zssa0073.
  Clear: gv_r1, gv_r2, gv_r3.
  gv_r2 = 'X'.

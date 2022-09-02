*&---------------------------------------------------------------------*
*& Module Pool      SAPMZSA0104
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*

INCLUDE MZSA0105_TOP.
*INCLUDE mzsa0104_top                            .    " Global Data

INCLUDE MZSA0105_O01.
*INCLUDE mzsa0104_o01                            .  " PBO-Modules
INCLUDE MZSA0105_I01.
*INCLUDE mzsa0104_i01                            .  " PAI-Modules
INCLUDE MZSA0105_F01.
*INCLUDE mzsa0104_f01                            .  " FORM-Routines


LOAD-OF-PROGRAM.
  PERFORM set_default CHANGING zssa0073.

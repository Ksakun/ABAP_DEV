*&---------------------------------------------------------------------*
*& Module Pool      SAPMZSA0104
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*

INCLUDE mzsa0104_top                            .    " Global Data

INCLUDE mzsa0104_o01                            .  " PBO-Modules
INCLUDE mzsa0104_i01                            .  " PAI-Modules
INCLUDE mzsa0104_f01                            .  " FORM-Routines


LOAD-OF-PROGRAM.
  PERFORM set_default CHANGING zssa0073.

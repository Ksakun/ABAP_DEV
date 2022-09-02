*&---------------------------------------------------------------------*
*& Module Pool      SAPMZSA0101_V2
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*

INCLUDE mzsa0101_v2_top                         .    " Global Data

INCLUDE mzsa0101_v2_o01                         .  " PBO-Modules
INCLUDE mzsa0101_v2_i01                         .  " PAI-Modules
INCLUDE mzsa0101_v2_f01                         .  " FORM-Routines

LOAD-OF-PROGRAM.
  PERFORM set_default.

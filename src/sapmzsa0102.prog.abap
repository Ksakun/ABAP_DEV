*&---------------------------------------------------------------------*
*& Module Pool      SAPMZSA0102
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*

INCLUDE mzsa0102_top                            .    " Global Data

INCLUDE mzsa0102_o01                            .  " PBO-Modules
INCLUDE mzsa0102_i01                            .  " PAI-Modules
INCLUDE mzsa0102_f01                            .  " FORM-Routines


LOAD-OF-PROGRAM.
 PERFORM set_default. "CHANGING zssa0160.

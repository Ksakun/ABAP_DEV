*&---------------------------------------------------------------------*
*& Module Pool      SAPMZSA0150
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*

INCLUDE mzsa0150_top                            .    " Global Data

INCLUDE mzsa0150_o01                            .  " PBO-Modules
INCLUDE mzsa0150_i01                            .  " PAI-Modules
INCLUDE mzsa0150_f01                            .  " FORM-Routines


LOAD-OF-PROGRAM.
  SELECT SINGLE carrid mealno
    FROM ztsa01ven
    INTO (zssa0150-carrid, zssa0150-mealnumber)
    WHERE lifnr = 'VENSA01'.

  gv_r1 = 'X'.

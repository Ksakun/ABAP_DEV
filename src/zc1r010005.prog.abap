*&---------------------------------------------------------------------*
*& Report ZC1R010005
*&---------------------------------------------------------------------*
*& SFLIGHT를 ALV로 나타내고 CARRID 필드를 더블클릭하면 SCARR의 CARRID 정보를 팝업으로
*& 나타낸다.
*&---------------------------------------------------------------------*

INCLUDE zc1r010005_top                          .  " Global Data
INCLUDE zc1r010005_s01                          .  " Selection Screen
INCLUDE zc1r010005_c01                          .  " Local Class
INCLUDE zc1r010005_o01                          .  " PBO-Modules
INCLUDE zc1r010005_i01                          .  " PAI-Modules
INCLUDE zc1r010005_f01                          .  " FORM-Routines


START-OF-SELECTION.
  PERFORM get_list.
  PERFORM set_carrname.

  IF gt_list IS NOT INITIAL.
    CALL SCREEN '0100'.
  ENDIF.

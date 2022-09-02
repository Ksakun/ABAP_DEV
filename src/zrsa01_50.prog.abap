*&---------------------------------------------------------------------*
*& Report ZRSA01_50
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*

INCLUDE zrsa01_50_top                           .    " Global Data

INCLUDE zrsa01_50_o01                           .  " PBO-Modules
INCLUDE zrsa01_50_i01                           .  " PAI-Modules
INCLUDE zrsa01_50_f01                           .  " FORM-Routines

* INITIALIZATION -> SELECTION SCREEN PBO, PAI -> PAI 끝나면 Selection screen 사라짐 -> Start of selection시작(event)

INITIALIZATION.
  PERFORM set_init.

AT SELECTION-SCREEN OUTPUT. "PBO
  MESSAGE s000(zmcsa01) WITH 'PBO'.
AT SELECTION-SCREEN. "PAI

START-OF-SELECTION. "많이 안씀. END-OF-SELECTION 같은 소리입니다. 지금은 둘다 잘 안쓴다.
  SELECT single *
    FROM sflight
*    INTO sflight "TOP에서 TABLES를 선언했으면 INTO를 생략가능하다.
    WHERE carrid = pa_car
    AND  connid = pa_con
    AND fldate IN so_dat[].
  CALL  SCREEN 100.
  MESSAGE s000(zmcsa01) WITH 'After call screen'.

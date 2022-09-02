*&---------------------------------------------------------------------*
*& Report ZRSA01_23
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*

INCLUDE zrsa01_23_top                           .    " Global Data

* INCLUDE ZRSA01_23_O01                           .  " PBO-Modules
* INCLUDE ZRSA01_23_I01                           .  " PAI-Modules
INCLUDE zrsa01_23_f01                           .  " FORM-Routines

*Event
*LOAD-OF-PROGRAM. "얘도 딱한번 실행된다.
INITIALIZATION. "최초의 딱 한번 실행되는 것 (TYPE '1'= Executable program)일때만 사용가능
*  SELECT SINGLE carrid connid
*    FROM spfli
*    INTO ( pa_car, pa_con ).

  IF sy-uname = 'KD-A-01'.
    pa_car = 'AA'.
    pa_con = '0017'.
  ENDIF.
  "Return을 하게 되면 여기서부터 다시 시작.

AT SELECTION-SCREEN OUTPUT. "A-S-S0 혹은 PBO ////1000번 화면이 나오기전에 실행해라

AT SELECTION-SCREEN. "PAI
  IF pa_con IS INITIAL.
    "E/W
    MESSAGE w016(pn) WITH 'Check'.
  ELSE.
  ENDIF.

START-OF-SELECTION.

  PERFORM get_info.
  WRITE 'Test'.
*  IF gt_info IS NOT INITIAL.
*    cl_demo_output=>display_data( gt_info ).
*  ELSE.
*  ENDIF.

  IF gt_info IS INITIAL.
    "S, I
    MESSAGE i016(pn) WITH 'Data is not found!'.
    RETURN.
  ENDIF.

  cl_demo_output=>display_data( gt_info ).

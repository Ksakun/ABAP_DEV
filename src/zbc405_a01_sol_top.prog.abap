*&---------------------------------------------------------------------*
*& Include ZBC405_A01_SOL_TOP                       - Report ZBC405_A01_SOL
*&---------------------------------------------------------------------*
REPORT zbc405_a01_sol.

DATA gs_flight TYPE dv_flights.

SELECTION-SCREEN BEGIN OF BLOCK a1 WITH FRAME TITLE TEXT-a01.
  PARAMETERS: pa_car TYPE s_carr_id "scarr-carrid
                      MEMORY ID car, "Memory id = Parameter Id
              pa_con TYPE s_conn_id
                      MEMORY ID con.
  SELECT-OPTIONS so_date FOR gs_flight-fldate.
SELECTION-SCREEN END OF BLOCK a1.
*            pa_date TYPE s_date OBLIGATORY,
*            pa_cntfr TYPE spfli-cityfrom DEFAULT 'KR' VALUE CHECK,
PARAMETERS: pa_check AS CHECKBOX DEFAULT 'X' MODIF ID mod,
            pa_lim_1 RADIOBUTTON GROUP lim DEFAULT 'X',
            pa_lim_2 RADIOBUTTON GROUP lim,
            pa_lim_3 RADIOBUTTON GROUP lim.



*SAP Memory handling 방법 1. set, 2: get
**SET PARAMETER ID 'Z01' FIELD pa_car.
**GET PARAMETER ID 'Z01' FIELD pa_car.

"Radio 버튼을 사용하면 case 문을 통해서 각각 선택했을 때의 행동동작을 정의.

CASE 'X'.
  WHEN pa_lim_1.
  WHEN pa_lim_2.
  WHEN pa_lim_3.
ENDCASE.

"Modif id -> 입력 handling

*INITIALIZATION.
*
*LOOP AT SCREEN.
*  IF screen-group1 = 'MOD'.
*    screen-input = 0.
*    screen-output = 1.
*
*  ENDIF.
*
*  MODIFY SCREEN.
*ENDLOOP.

"Selct-options 강제로 값을 입력하게 하는법

*INITIALIZATION.

*  so_date-low = sy-datum.
*  so_date-high = sy-datum + 30.
*  so_date-option = 'BT'.
*  so_date-sign = 'I'.

*  APPEND so_date.

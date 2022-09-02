*&---------------------------------------------------------------------*
*& Report YCL101_001
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*

INCLUDE ycl101_001_top                          .  " Global Data
INCLUDE ycl101_001_s01                          .  " Selection Screen
INCLUDE ycl101_001_c01                          .  " local Screen
INCLUDE ycl101_001_o01                          .  " PBO-Modules
INCLUDE ycl101_001_i01                          .  " PAI-Modules
INCLUDE ycl101_001_f01                          .  " FORM-Routines




INITIALIZATION.
  "프로그램 실행 시 가장 처음 1회만 수행되는 구간

AT SELECTION-SCREEN OUTPUT.
  "검색화면에서 화면이 출력되기 직전에 수해오디는 구간
  "주 용도는 검색화면에 대한 제어 (특정필드 숨김 혹은 읽기 전용)

AT SELECTION-SCREEN.
  "검색화면에서 사용자가 특정 이벤트를 발생시켰을 때 수해오디는 구간
  "상단의 Function key 이벤트, 특정필드 클릭, 엔터 등의 이벤트에서 입력값에 대한 점검

START-OF-SELECTION.
  "검색화면에서 실행버튼 눌렀을 때 수행되는 구간
  "데이터 조회 & 검색
  PERFORM select_data.

END-OF-SELECTION.

  IF gt_scarr IS INITIAL.
    MESSAGE 'NO DATA' TYPE 'S' DISPLAY LIKE 'W'.
    "프로그램을 계속 이어서 진행되도록 만드는 타입
    "S, I
    "프로그램을 중단 시키는 타입
    "W, E, X
  ELSE.
    CALL SCREEN '0100'.
  ENDIF.

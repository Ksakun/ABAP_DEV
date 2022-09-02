*&---------------------------------------------------------------------*
*& Report ZRSA01_CLASS
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zrsa01_class.

"자동차 CLASS 정의 (Method & Attributes) Attribute : 브랜드, 모델,
"                                     Method    : 가속, 정지하기.
CLASS lcl_vehicle DEFINITION.

  PUBLIC SECTION. "외부에서 접근 가능!
    "constructor 선언
    METHODS constructor IMPORTING iv_brand TYPE char32
                                  iv_model TYPE char16.

    DATA pnumber TYPE n LENGTH 8. "자동차 번호판 --> 외부에서 자동차 번호판을 바꿀 수 있기때문 PUBLIC.
    "Instance M
    "정의부: run 이라는 메서드는 iv_speed를 importing 받는다.
    METHODS run IMPORTING iv_speed TYPE i. "달리는 기능
    METHODS stop."정지하는 기능

    "자동차 제작 정의
    METHODS set_car IMPORTING iv_brand TYPE char32
                              iv_model TYPE char16.


    "Static M
    "자동차가 총 몇대 생산되었는지 확인하는 기능 / i 타입을 갖는 r_total 반환하는 method.
    CLASS-METHODS get_n_of_veh RETURNING VALUE(r_total) TYPE i.

  PRIVATE SECTION. "외부에서 접근 불가!
    "Instance A
    DATA: mv_brand  TYPE char32, "현대 / 기아 /,,,
          mv_model  TYPE char16, "소나타, 아반떼 ,...
          mv_engine TYPE i,
          mv_speed  TYPE i VALUE 0. "차의 기본 속도.

    "Static A
    CLASS-DATA: gv_n_of_veh TYPE i. "해당 자동차 클래스를 통해 총 몇대 생산되었느지를 관리하는 변수.
ENDCLASS.


"Class 구현부
CLASS lcl_vehicle IMPLEMENTATION.

  METHOD constructor.
    mv_brand = iv_brand.
    mv_model = iv_model.
*    me->mv_model = iv_model.

    "Object 생성 될 때마 숫자가 증가!
    gv_n_of_veh = gv_n_of_veh + 1.
  ENDMETHOD.

  "CLASS-METHODS get_n_of_veh RETURNING VALUE(r_total) TYPE i.
  METHOD get_n_of_veh.

    r_total = gv_n_of_veh. "r_total은 현재 생산된 차량의 총 대수

  ENDMETHOD.

  METHOD set_car. "2개의 파라미터 (iv_brand, iv_model)를 사용!
    mv_brand = iv_brand.
    mv_model = iv_model.
  ENDMETHOD.



  METHOD run.
    "구현부: run 이라는 메서드는 현재 속도에 받은 iv_speed만큼 가속시킨다.
    mv_speed = mv_speed + iv_speed.

  ENDMETHOD.

  METHOD stop.

  ENDMETHOD.
ENDCLASS.

"차후(start-of-selection 에서 ) 자동차를 2대 만들고 싶다!!!(just 생각만)
"아직 r_car1, r_car2는 실제 자동차가 아닙니다. '생각'만한 상태.
DATA r_car1 TYPE REF TO lcl_vehicle.
DATA r_car2 LIKE r_car1.

"주차장을 생성하는 것을 생각! (여러개의 자동차를 관리하고자 할 때)
DATA gt_parking_lot TYPE TABLE OF REF TO lcl_vehicle. "gt_airplanes

*DATA gw_parking_lot TYPE lcl_vechicle. "1번방법
DATA gw_parking_lot LIKE LINE OF gt_parking_lot. "go_airplane

DATA gv_total   TYPE i. "총 몇대 생산되었는지 저장하는 변수.


START-OF-SELECTION.

*Constructor가 없을때 object 생성 방법!
  "실제 자동차를 만든것!
*  CREATE OBJECT r_car1.
*  "#1방법
*  r_car1->set_car( iv_brand = '현대'
*                   iv_model = 'GENESIS' ).
*  "#2방법
*  CALL METHOD r_car1->set_car
*    EXPORTING
*      iv_brand = '현대'
*      iv_model = 'GENESIS'.
*
**  r_car1: mv_brand = '현대' mv_model = 'GENESIS'.

*Constructor로 만들 때!
  CREATE OBJECT r_car1 EXPORTING iv_brand = '현대'
                                 iv_model = 'GENESIS'.

*  차의 달리는 기능 구현#1
  r_car1->run( EXPORTING iv_speed = 100 ). "100으로 차를 가속시켜라

* 차의 달리는 기능 구현#2
*  CALL METHOD r_car1->run
*       EXPORTING
*         iv_speed = 150.

* 차의 멈추는 기능
  r_car1->stop( ).

  "번호판은 PUBLIC SECTION에 있는 Instance A.
  r_car1->pnumber = '20허7777'. "r_car1의 번호판은 ' '.
  "브랜드는 PRIVATE SECTION에 있는 Instance A.
*  r_car1->mv_brand = '벤츠'. "불가

  APPEND r_car1 TO gt_parking_lot.


*  gv_total = lcl_vehicle=>get_n_of_veh().

*  lcl_vehicle=>get_n_of_veh( RECEIVING r_total = gv_total ).
*
*  CALL METHOD lcl_vehicle=>get_n_of_veh
*        RECEIVING r_total = gv_total.

*  CREATE OBJECT r_car2.
*  APPEND r_car2 TO gt_parking_lot.

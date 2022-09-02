*&---------------------------------------------------------------------*
*& Report ZBC401_A01_MENTOR
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zbc401_a01_mentor.

* 자동차 CLASS 정의 (많은 Attributes와 Method로 구성) -> 외부에서 접근? Public 외부에서 접근 불가? Private
CLASS lcl_vehicle DEFINITION.
*  무조건 PUBLIC SECTION 만들고 PRIVATE SECTION 만든다. 이 구조는 외워야함.
  "여기에 선언하면 외부에서 접근 가능
  PUBLIC SECTION.
    METHODS constructor IMPORTING iv_brand TYPE char32
                                  iv_model TYPE char16.

    DATA pnumber TYPE n LENGTH 8. "자동차 번호판 ==> 외부사람이 자동차 번호판을 바꿀 수 있다!

    METHODS: run IMPORTING iv_speed TYPE i. "달리는 기능 with speed를 입력받아서 달리기
    METHODS: stop. "정지하는 기능.

    "자동차 제작 정의! 구현은 implementation에서
    METHODS set_car IMPORTING iv_brand TYPE char32
                              iv_model TYPE char16.

    "총 몇대 생산되었는지 확인하는 기능
    CLASS-METHODS get_n_of_veh RETURNING VALUE(r_total) TYPE i.

    "여기에 선언하면 외부에서 접근 불가
  PRIVATE SECTION.
    "Instance Attribute
    DATA mv_brand  TYPE char32. "현대/기아/벤츠/포르쉐... ==> 외부사람이 내 자동차 모델을 바꿀 수 없다!
    DATA mv_model  TYPE char16. "소나타,아반떼,타이칸...
    DATA mv_engine TYPE i.
    DATA mv_speed  TYPE i VALUE 0.
    "Static Attribute
    CLASS-DATA: gv_n_of_veh TYPE i. "해당 클래스를 통해 자동차가 총 몇대 생산되었는지 관리 변수.
ENDCLASS.

* 자동차 구현부.
CLASS lcl_vehicle IMPLEMENTATION.
  METHOD constructor.
    mv_brand = iv_brand.
    mv_model = iv_model.
*    me->model = iv_model. 도 가능하다.

    "객체가 생성되어질 때마다 숫자 증가
    gv_n_of_veh = gv_n_of_veh + 1.
  ENDMETHOD.

  METHOD get_n_of_veh.
    "엔진이 200마력.
*    engine = 200. "Engine은 instance attri
    r_total = gv_n_of_veh.
  ENDMETHOD.


  METHOD set_car. "파라미터로 받은 2개의 값을 본인의 속성에 정의.
    mv_brand = iv_brand.
    mv_model = iv_model.

  ENDMETHOD.

  METHOD run. "달리는 기능 구현
    mv_speed = mv_speed + iv_speed. "현재 자동차 속도에 가속.
  ENDMETHOD.

  METHOD stop. "멈추는 기능 구현

  ENDMETHOD.
ENDCLASS.

"차후에 자동차를 생성 후 가르키게 되는 포인터 변수 (Reference 변수)
"우리는 자동차를 2대 만들고 싶다!
"r_car1, r_car2는 아직은 '자동차'가 아니다! 지금은 r_car1, r_car2를 만들겠다고 '생각'만 한 상태
DATA r_car1 TYPE REF TO lcl_vehicle.
DATA r_car2 LIKE r_car1.

"주차장을 생성하고자 함. (여러개의 자동차를 관리하고자 할 때 )
DATA gt_parking_lot TYPE TABLE OF REF TO lcl_vehicle.
DATA gw_parking_lot LIKE LINE OF gt_parking_lot. "Work area 설정  "gw_parkin_lot TYPE lcl_vehicle이랑 같음
DATA gv_total TYPE i. "총 생산된 자동차 대수 보관 변수.

START-OF-SELECTION.

  "실제 2대의 자동차를 만듦
  CREATE OBJECT r_car1 EXPORTING iv_brand = '현대'
                                 iv_model = '제네시스'.

  "car1의 달리는 기능 구현 방법 #1
  r_car1->run( EXPORTING iv_speed = 100 ).

  "car1의 달리는 기능 구현 방법 #2
  CALL METHOD r_car1->run
    EXPORTING
        iv_speed = 100.

  "car1의 멈추는 기능.
  r_car1->stop( ).

  "Public attribute에 접근방법
  r_car1->pnumber = '10가7777'. "가능
*  r_car1->mv_brand = '벤츠'. "?

  "주차장에 car1 넣기
  APPEND r_car1 TO gt_parking_lot.




 "클래스에게 총 생산된 자동차 갯수 호풀하여 취득하기
  gv_total = lcl_vehicle=>get_n_of_veh( ). "리터닝 파라미터를 갖는 메서드만 가능한 문법이다.
*   lcl_vehicle=>get_n_of_veh( RECEIVING r_total = gv_total ).
*   CALL METHOD lcl_vehicle=>get_n_of_veh
*        RECEIVING r_total = gv_total

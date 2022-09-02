*&---------------------------------------------------------------------*
*& Report ZBC400_A01_BASIC
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zbc400_a01_basic2.

****문제#5
*다음 구조를 가진 로컬 스트럭쳐/itab 선언
*gt_mara = mara-matnr / makt-maktx / mara-mtart / mara-matkl
*gt_makt = makt-matnr / makt-maktx

"mara와 makt의 데이터를 모두 읽어서 각가 gt_mara와 grmakt에 데이털르 적재
*makt를 읽을 때 언어키는 로그인 언어 적용
*gt_mara의 자재코드에 대한 내역을 가진 gt_makt에서 각 자재에
*해당하는 내역(maktx)을 읽어서 gt_mara의 maktx에 정보를 입력

*DATA: BEGIN OF gs_mara,
*        matnr TYPE mara-matnr,
*        maktx TYPE makt-maktx,
*        mtart TYPE mara-mtart,
*        matkl TYPE mara-matkl,
*      END OF gs_mara,
*      BEGIN OF gs_makt,
*        matnr TYPE makt-matnr,
*        maktx TYPE makt-maktx,
*      END OF gs_makt.
*
*DATA: gt_mara  LIKE TABLE OF gs_mara,
*      gt_makt  LIKE TABLE OF gs_makt,
*      lv_tabix TYPE sy-tabix.
*
*CLEAR: gs_mara, gs_makt. REFRESH: gt_mara, gt_makt.
*
*SELECT matnr mtart matkl
*  FROM mara
*  INTO CORRESPONDING FIELDS OF TABLE gt_mara.
*
*SELECT matnr maktx
*  FROM makt
*  INTO CORRESPONDING FIELDS OF TABLE gt_makt
* WHERE spras = sy-langu.
*
*LOOP AT gt_mara INTO gs_mara.
*  lv_tabix = sy-tabix.
*
*  READ TABLE gt_makt INTO gs_makt WITH KEY gs_mara-matnr.
*  IF sy-subrc EQ 0.
*    gs_mara-maktx = gs_makt-maktx.
*    MODIFY gt_mara FROM gs_mara INDEX lv_tabix TRANSPORTING maktx.
*  ELSE.
*    MESSAGE i001(zmcsa01).
*    LEAVE LIST-PROCESSING.
*  ENDIF.
*
*  CLEAR: gs_mara, gs_makt.
*
*ENDLOOP.
*
*
*cl_demo_output=>display_data( gt_mara ).

****문제#6
*로컬스트럭쳐 / 인터널 테이블 선언
*spfli 에 명시된 필드를 읽어서 gt_spfli에 저장
*scarr 테이블 위에 명시된 필드를 읽어서 gt_scarr itab에 저장
*gt_scarr itab에서 carrid 값에 맞는 carrname과 url을 읽어서 gt_spfli의 carrname과 url을 채우시오

*DATA: BEGIN OF gs_spfli,
*        carrid   TYPE spfli-carrid,
*        connid   TYPE spfli-connid,
*        carrname TYPE scarr-carrname,
*        url      TYPE scarr-url,
*        airpfrom TYPE spfli-airpfrom,
*        airpto   TYPE spfli-airpto,
*        deptime  TYPE spfli-deptime,
*        arrtime  TYPE spfli-arrtime,
*      END OF gs_spfli,
*
*      BEGIN OF gs_scarr,
*        carrid   TYPE scarr-carrid,
*        carrname TYPE scarr-carrname,
*        url      TYPE scarr-url,
*      END OF gs_scarr.
*
*DATA : gt_spfli LIKE TABLE OF gs_spfli,
*       gt_scarr LIKE TABLE OF gs_scarr,
*       lv_tabix TYPE sy-tabix.
*
*CLEAR: gs_spfli, gs_scarr. REFRESH: gt_spfli, gt_scarr.
*
*SELECT carrid connid airpfrom airpto deptime arrtime
*  FROM spfli
*  INTO CORRESPONDING FIELDS OF TABLE gt_spfli.
*
*
*SELECT carrid carrname url
*  FROM scarr
*  INTO TABLE gt_scarr.
*
*LOOP AT gt_spfli INTO gs_spfli.
*  lv_tabix = sy-tabix.
*
*  READ TABLE gt_scarr INTO gs_scarr WITH KEY gs_spfli-carrid.
*  IF sy-subrc = 0.
*    gs_spfli-carrname = gs_scarr-carrname.
*    gs_spfli-url      = gs_scarr-url.
*
*    MODIFY gt_spfli FROM gs_spfli INDEX lv_tabix TRANSPORTING carrname url.
*    CLEAR: gs_spfli, gs_scarr.
*  ENDIF.
*ENDLOOP.
*
*
*
*cl_demo_output=>display_data( gt_spfli ).

****문제#7
*로컬/인터널 테이블 선언
*gt_data => mara-matnr / makt-maktx -> join으로 / mara-mtart / mtbez(mtart) / mara-mbrsh / mbbez(mbrsh) / mara-tragr / vtext (tragr)
*mara의 테이블의 데이터를 읽어서 gt_data에 적재 위의 각 필드의 내역을 찾아서 모두 세팅할 것

DATA: BEGIN OF gs_data,
        matnr TYPE mara-matnr,
        maktx TYPE makt-maktx,
        mtart TYPE mara-mtart,
        mtbez TYPE t134t-mtbez,
        mbrsh TYPE mara-mbrsh,
        mbbez TYPE t137t-mbbez,
        tragr TYPE mara-tragr,
        vtext TYPE ttgrt-vtext,
      END OF gs_data.



DATA: gt_data  LIKE TABLE OF gs_data,
      gt_t134t TYPE TABLE OF t134t,
      gs_t134t LIKE LINE OF gt_t134t,
      gt_t137t TYPE TABLE OF t137t,
      gs_t137t LIKE LINE OF gt_t137t,
      gt_ttrgt TYPE TABLE OF ttgrt,
      gs_ttrgt LIKE LINE OF gt_ttrgt,
      lv_tabix TYPE sy-tabix.

CLEAR: gs_data, gs_t134t, gs_t137t, gs_ttrgt.
REFRESH: gt_data, gt_t134t, gt_t137t, gt_ttrgt.


SELECT a~matnr b~maktx a~mtart a~mbrsh a~tragr
  FROM mara AS a INNER JOIN makt AS b
    ON a~matnr = b~matnr
  INTO CORRESPONDING FIELDS OF TABLE gt_data
 WHERE b~spras = sy-langu.

SELECT mtart mtbez
  FROM t134t
  INTO CORRESPONDING FIELDS OF TABLE gt_t134t
 WHERE spras = sy-langu.

SELECT mbrsh mbbez
  FROM t137t
  INTO CORRESPONDING FIELDS OF TABLE gt_t137t
 WHERE spras = sy-langu.

SELECT tragr vtext
  FROM ttgrt
  INTO CORRESPONDING FIELDS OF TABLE gt_ttrgt
 WHERE spras = sy-langu.


LOOP AT gt_data INTO gs_data.
  lv_tabix = sy-tabix.
*  CLEAR: gs_data, gs_t134t, gs_t137t, gs_ttrgt.

  READ TABLE gt_t134t INTO gs_t134t WITH KEY mtart = gs_data-mtart.

  IF gs_t134t IS NOT INITIAL.
    gs_data-mtbez = gs_t134t-mtbez.
  ENDIF.

  READ TABLE gt_t137t INTO gs_t137t WITH KEY mbrsh = gs_data-mbrsh.
  IF gs_t137t IS NOT INITIAL.
    gs_data-mbbez = gs_t137t-mbbez.
  ENDIF.

  READ TABLE gt_ttrgt INTO gs_ttrgt WITH KEY tragr = gs_data-tragr.
  IF gs_ttrgt IS NOT INITIAL.
    gs_data-vtext = gs_ttrgt-vtext.
  ENDIF.

  MODIFY gt_data FROM gs_data INDEX lv_tabix TRANSPORTING mtbez mbbez vtext.
  CLEAR: gs_t134t, gs_t137t, gs_ttrgt, gs_data.

ENDLOOP.
cl_demo_output=>display_data( gt_data ).

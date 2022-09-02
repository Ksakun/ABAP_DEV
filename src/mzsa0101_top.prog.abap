*&---------------------------------------------------------------------*
*& Include MZSA0101_TOP                             - Module Pool      SAPMZSA0101
*&---------------------------------------------------------------------*
PROGRAM sapmzsa0101.

*Condition

DATA gv_pernr TYPE ztsa0001-pernr.

"Employee Info
*DATA gs_info  TYPE zssa0031.
TABLES zssa0031. " TABLES 뒤에는 일반적인 (NEST/DEEP이 아닌) 스트럭쳐 타입이 올 수 있다.

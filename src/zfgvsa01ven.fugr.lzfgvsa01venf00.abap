*---------------------------------------------------------------------*
*    view related FORM routines
*---------------------------------------------------------------------*
*...processing: ZVSA01VEN.......................................*
FORM GET_DATA_ZVSA01VEN.
  PERFORM VIM_FILL_WHERETAB.
*.read data from database.............................................*
  REFRESH TOTAL.
  CLEAR   TOTAL.
  SELECT * FROM ZTSA01VEN WHERE
(VIM_WHERETAB) .
    CLEAR ZVSA01VEN .
ZVSA01VEN-MANDT =
ZTSA01VEN-MANDT .
ZVSA01VEN-LIFNR =
ZTSA01VEN-LIFNR .
ZVSA01VEN-LAND1 =
ZTSA01VEN-LAND1 .
ZVSA01VEN-NAME1 =
ZTSA01VEN-NAME1 .
ZVSA01VEN-NAME2 =
ZTSA01VEN-NAME2 .
ZVSA01VEN-VENCA =
ZTSA01VEN-VENCA .
ZVSA01VEN-CARRID =
ZTSA01VEN-CARRID .
ZVSA01VEN-MEALNO =
ZTSA01VEN-MEALNO .
ZVSA01VEN-PRICE =
ZTSA01VEN-PRICE .
ZVSA01VEN-WAERS =
ZTSA01VEN-WAERS .
<VIM_TOTAL_STRUC> = ZVSA01VEN.
    APPEND TOTAL.
  ENDSELECT.
  SORT TOTAL BY <VIM_XTOTAL_KEY>.
  <STATUS>-ALR_SORTED = 'R'.
*.check dynamic selectoptions (not in DDIC)...........................*
  IF X_HEADER-SELECTION NE SPACE.
    PERFORM CHECK_DYNAMIC_SELECT_OPTIONS.
  ELSEIF X_HEADER-DELMDTFLAG NE SPACE.
    PERFORM BUILD_MAINKEY_TAB.
  ENDIF.
  REFRESH EXTRACT.
ENDFORM.
*---------------------------------------------------------------------*
FORM DB_UPD_ZVSA01VEN .
*.process data base updates/inserts/deletes.........................*
LOOP AT TOTAL.
  CHECK <ACTION> NE ORIGINAL.
MOVE <VIM_TOTAL_STRUC> TO ZVSA01VEN.
  IF <ACTION> = UPDATE_GELOESCHT.
    <ACTION> = GELOESCHT.
  ENDIF.
  CASE <ACTION>.
   WHEN NEUER_GELOESCHT.
IF STATUS_ZVSA01VEN-ST_DELETE EQ GELOESCHT.
     READ TABLE EXTRACT WITH KEY <VIM_XTOTAL_KEY>.
     IF SY-SUBRC EQ 0.
       DELETE EXTRACT INDEX SY-TABIX.
     ENDIF.
    ENDIF.
    DELETE TOTAL.
    IF X_HEADER-DELMDTFLAG NE SPACE.
      PERFORM DELETE_FROM_MAINKEY_TAB.
    ENDIF.
   WHEN GELOESCHT.
  SELECT SINGLE FOR UPDATE * FROM ZTSA01VEN WHERE
  LIFNR = ZVSA01VEN-LIFNR .
    IF SY-SUBRC = 0.
    DELETE ZTSA01VEN .
    ENDIF.
    IF STATUS-DELETE EQ GELOESCHT.
      READ TABLE EXTRACT WITH KEY <VIM_XTOTAL_KEY> BINARY SEARCH.
      DELETE EXTRACT INDEX SY-TABIX.
    ENDIF.
    DELETE TOTAL.
    IF X_HEADER-DELMDTFLAG NE SPACE.
      PERFORM DELETE_FROM_MAINKEY_TAB.
    ENDIF.
   WHEN OTHERS.
  SELECT SINGLE FOR UPDATE * FROM ZTSA01VEN WHERE
  LIFNR = ZVSA01VEN-LIFNR .
    IF SY-SUBRC <> 0.   "insert preprocessing: init WA
      CLEAR ZTSA01VEN.
    ENDIF.
ZTSA01VEN-MANDT =
ZVSA01VEN-MANDT .
ZTSA01VEN-LIFNR =
ZVSA01VEN-LIFNR .
ZTSA01VEN-LAND1 =
ZVSA01VEN-LAND1 .
ZTSA01VEN-NAME1 =
ZVSA01VEN-NAME1 .
ZTSA01VEN-NAME2 =
ZVSA01VEN-NAME2 .
ZTSA01VEN-VENCA =
ZVSA01VEN-VENCA .
ZTSA01VEN-CARRID =
ZVSA01VEN-CARRID .
ZTSA01VEN-MEALNO =
ZVSA01VEN-MEALNO .
ZTSA01VEN-PRICE =
ZVSA01VEN-PRICE .
ZTSA01VEN-WAERS =
ZVSA01VEN-WAERS .
    IF SY-SUBRC = 0.
    UPDATE ZTSA01VEN ##WARN_OK.
    ELSE.
    INSERT ZTSA01VEN .
    ENDIF.
    READ TABLE EXTRACT WITH KEY <VIM_XTOTAL_KEY>.
    IF SY-SUBRC EQ 0.
      <XACT> = ORIGINAL.
      MODIFY EXTRACT INDEX SY-TABIX.
    ENDIF.
    <ACTION> = ORIGINAL.
    MODIFY TOTAL.
  ENDCASE.
ENDLOOP.
CLEAR: STATUS_ZVSA01VEN-UPD_FLAG,
STATUS_ZVSA01VEN-UPD_CHECKD.
MESSAGE S018(SV).
ENDFORM.
*---------------------------------------------------------------------*
FORM READ_SINGLE_ENTRY_ZVSA01VEN.
  SELECT SINGLE * FROM ZTSA01VEN WHERE
LIFNR = ZVSA01VEN-LIFNR .
ZVSA01VEN-MANDT =
ZTSA01VEN-MANDT .
ZVSA01VEN-LIFNR =
ZTSA01VEN-LIFNR .
ZVSA01VEN-LAND1 =
ZTSA01VEN-LAND1 .
ZVSA01VEN-NAME1 =
ZTSA01VEN-NAME1 .
ZVSA01VEN-NAME2 =
ZTSA01VEN-NAME2 .
ZVSA01VEN-VENCA =
ZTSA01VEN-VENCA .
ZVSA01VEN-CARRID =
ZTSA01VEN-CARRID .
ZVSA01VEN-MEALNO =
ZTSA01VEN-MEALNO .
ZVSA01VEN-PRICE =
ZTSA01VEN-PRICE .
ZVSA01VEN-WAERS =
ZTSA01VEN-WAERS .
ENDFORM.
*---------------------------------------------------------------------*
FORM CORR_MAINT_ZVSA01VEN USING VALUE(CM_ACTION) RC.
  DATA: RETCODE LIKE SY-SUBRC, COUNT TYPE I, TRSP_KEYLEN TYPE SYFLENG.
  FIELD-SYMBOLS: <TAB_KEY_X> TYPE X.
  CLEAR RC.
MOVE ZVSA01VEN-LIFNR TO
ZTSA01VEN-LIFNR .
MOVE ZVSA01VEN-MANDT TO
ZTSA01VEN-MANDT .
  CORR_KEYTAB             =  E071K.
  CORR_KEYTAB-OBJNAME     = 'ZTSA01VEN'.
  IF NOT <vim_corr_keyx> IS ASSIGNED.
    ASSIGN CORR_KEYTAB-TABKEY TO <vim_corr_keyx> CASTING.
  ENDIF.
  ASSIGN ZTSA01VEN TO <TAB_KEY_X> CASTING.
  PERFORM VIM_GET_TRSPKEYLEN
    USING 'ZTSA01VEN'
    CHANGING TRSP_KEYLEN.
  <VIM_CORR_KEYX>(TRSP_KEYLEN) = <TAB_KEY_X>(TRSP_KEYLEN).
  PERFORM UPDATE_CORR_KEYTAB USING CM_ACTION RETCODE.
  ADD: RETCODE TO RC, 1 TO COUNT.
  IF RC LT COUNT AND CM_ACTION NE PRUEFEN.
    CLEAR RC.
  ENDIF.

ENDFORM.
*---------------------------------------------------------------------*

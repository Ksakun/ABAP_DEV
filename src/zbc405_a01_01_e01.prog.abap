*&---------------------------------------------------------------------*
*& Include          ZBC405_A01_01_E01
*&---------------------------------------------------------------------*

INITIALIZATION.
  "Pre-assignment for the airline, AA-QF/ but not AZ.
  MOVE: 'I' TO so_car-sign,
        'BT' TO so_car-option,
        'AA' TO so_car-low,
        'QF' TO so_car-high.
  APPEND so_car.
*  CLEAR so,_car

  CLEAR so_car.
  MOVE: 'E' TO so_car-sign,
        'EQ' TO so_car-option,
        'AZ' TO so_car-low.
  APPEND so_car.

  "Setting text
  tab1 = 'Connections'(001).
  tab2 = 'Flight'(002).
*  tab3 = 'Booking'(003).

  "Optional Setting
  tab-activetab = 'COMM2'.
  tab-dynnr = 102.

START-OF-SELECTION.

  CASE mark.
    WHEN pa_rdb1. "Read All flights
      SELECT *
        FROM dv_flights
        INTO gs_flight
       WHERE carrid IN so_car
         AND connid IN so_con
         AND fldate IN so_dat.


      WRITE:/ gs_flight-carrid,
              gs_flight-connid,
              gs_flight-fldate,
              gs_flight-countryfr,
              gs_flight-countryto.
      ENDSELECT.
      CLEAR gs_flight.

    WHEN pa_rdb2. "Read only domestic
      SELECT *
        FROM dv_flights
        INTO gs_flight
       WHERE carrid IN so_car
         AND connid IN so_con
         AND fldate  IN so_dat
         AND countryto = dv_flights~countryfr.

        WRITE:/ gs_flight-carrid,
              gs_flight-connid,
              gs_flight-fldate,
              gs_flight-countryfr,
              gs_flight-countryto.
       ENDSELECT.
       CLEAR gs_flight.

    WHEN pa_rdb3. "Read International
      SELECT *
        FROM dv_flights
        INTO gs_flight
       WHERE carrid IN so_car
         AND connid IN so_con
         AND fldate IN so_dat
         AND countryto <> dv_flights~countryfr.

        WRITE:/ gs_flight-carrid,
              gs_flight-connid,
              gs_flight-fldate,
              gs_flight-countryfr,
              gs_flight-countryto.
       ENDSELECT.
       CLEAR gs_flight.
  ENDCASE.

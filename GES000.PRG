MEMVAR cCNormal, cCMenus, cCpanta, cCMensa, lAyuda

FUNCTION Main()
   LOCAL nMenu := 1
   LOCAL cCInicio := SETCOLOR()
   LOCAL nCol, nFil := 0
   PUBLIC cCNormal := "B/BG,N/W"
   PUBLIC cCMenus := "B/W+,N+/G+"
   PUBLIC cCPanta := "W+/B"
   PUBLIC cCMensa := "B+/W+"
   PUBLIC lAyuda := .T.

   SETCOLOR ( cCNormal )
   CLS
   SETBLINK ( .F. )
   SETCURSOR(  0  )
   SET( _SET_WRAP,    .T. )
   SET( _SET_MESSAGE, 24  )
   SET( _SET_MCENTER, .T. )
   SET( _SET_CONFIRM, .T. )
   SET( _SET_DELETED, .T. )
   SET( _SET_SOFTSEEK, .T. )
   SET( _SET_CONFIRM, .T. )
   SET( _SET_SCOREBOARD, .F. )
   SET DATE ITALIAN
   SET DELIMITERS TO "[]"
   CLS
   DISPBEGIN()
   FOR nCol := 0 TO 24
       FOR nFil := 0 TO 79
           @ nCol,nFil SAY "±"
       ENDFOR
   ENDFOR
   DISPEND()

   @ 0,0 TO 2,79 DOUBLE COLOR ( "B/W" )
   @ 1,1 SAY " Gestion para Academias   " COLOR( "B/W" )
   @ 1,27 SAY "ACA v1.00                               " COLOR( "B/W" )
   @ 1,63 SAY "Fecha: " COLOR( "B/W" )
   @ 1,70 SAY DATE() COLOR( "B/W" )
   @ 1,78 SAY " " COLOR( "B/W" )

   SETCOLOR( cCMenus )
   DO WHILE .T.
      CajaTitulo( 4,15,20,65,2," MENU PRINCIPAL ", "" )
      @ 5,17 PROMPT " 1) Mantenimiento de Maestros                  "
      @ 6,17 PROMPT " 2) Procesos Especiales                        "

      MENU TO nMenu

      DO CASE
         CASE nMenu == 1
              M_Maestros()
         CASE nMenu == 2
              M_ProcEspe()
         OTHERWISE
              Salir()
      ENDCASE
   ENDDO

 RETURN NIL

//
STATIC FUNCTION M_Maestros()
       LOCAL nMenu := 1
       LOCAL cPantalla := SAVESCREEN( 5,14,21,66 )
       DO WHILE .T.
          CajaTitulo( 5,14,21,66,2," MANTENIMIENTO DE MAESTROS ", "" )
          @  6,16 PROMPT " 1) Mantenimiento de Alumnos                   "
          @  7,16 PROMPT " 2) Mantenimiento de Asignaturas               "
          @  8,16 PROMPT " 3) Mantenimiento de Profesores                "

          MENU TO nMenu
          DO CASE
             CASE nMenu == 1
                  M_Alumnos()
             CASE nMenu == 2
                  NoDisp()
             CASE nMenu == 3
                  NoDisp()
             OTHERWISE
                  RESTSCREEN( 5,14,21,66,cPantalla )
                  RETURN NIL
           ENDCASE
        ENDDO
 RETURN NIL

//
STATIC FUNCTION M_Alumnos()
       LOCAL nMenu := 1
       LOCAL cPantalla := SAVESCREEN( 6,13,22,67 )
       DO WHILE .T.
          CajaTitulo( 6,13,22,67,2," MANTENIMIENTO DE MAESTROS - ALUMNOS ", "" )
          @  7,15 PROMPT " 1) Altas de Alumnos                           "
          @  8,15 PROMPT " 2) Bajas de Alumnos                           "
          @  9,15 PROMPT " 3) Consultas de Alumnos                       "
          @ 10,15 PROMPT " 4) Modificaciones de Alumnos                  "
          @ 11,15 PROMPT " A) Listado de Alumnos por Código              "
          @ 12,15 PROMPT " B) Listado de Alumnos por Nombre              "

          MENU TO nMenu
          DO CASE
             CASE nMenu == 1
                  AltasAlu()
             CASE nMenu == 2
                  BajasAlu()
             CASE nMenu == 3
                  ConsulAlu()
             CASE nMenu == 4
                  ModifAlu()
             CASE nMenu == 5
                  LAlu_Cod()
             CASE nMenu == 6
                  LAlu_Nom()
             OTHERWISE
                  RESTSCREEN( 6,13,22,67,cPantalla )
                  RETURN NIL
           ENDCASE
        ENDDO
 RETURN NIL

//
STATIC FUNCTION M_ProcEspe()
       LOCAL nMenu := 1
       LOCAL cPantalla := SAVESCREEN( 5,14,21,66 )
       DO WHILE .T.
          CajaTitulo( 5,14,21,66,2," PROCESOS ESPECIALES ", "" )
          @  6,16 PROMPT " 1) Creacion de Ficheros de Datos              "
          @  7,16 PROMPT " 2) Creacion de Ficheros de Indices            "
          @  8,16 PROMPT " 3) Compactacion de Ficheros                   "

          MENU TO nMenu
          DO CASE
             CASE nMenu == 1
                  CrearDatos()
             CASE nMenu == 2
                  CrearIndic()
             CASE nMenu == 3
                  Compactar()
             OTHERWISE
                  RESTSCREEN( 5,14,21,66,cPantalla )
                  RETURN NIL
           ENDCASE
        ENDDO
 RETURN NIL

//
STATIC FUNCTION Salir( nMenu )
   LOCAL aOpciones := { "  Si  ","  No  " }
   LOCAL nSelec    := ALERT( " ¿Desea Realmente Salir? ", aOpciones )

   DO CASE
      CASE nSelec == 1
           SET COLOR TO
           CLS
           @ 6,20 TO 12,60 DOUBLE
           @ 8,29  SAY "Gracias por usar esta"
           @ 9,23  SAY "      Gestion para Academias       "
           @ 10,35 SAY "ACA v1.00"
           @ 15,22 SAY "    Fco. Javier Pérez - 1996"
           @ 16,22 SAY "        Elche (Alicante)"
           @ 17,22 SAY "      fjavierdev@gmail.com"
           @ 22,0 SAY " "
           QUIT
   ENDCASE
 RETURN .T.

//
FUNCTION NoDisp( nMenu )
   ALERT( "Función no disponible" )
 RETURN .T.

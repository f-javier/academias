* * * * * * * * * * *
* Programa .........: Gestion para Academias v1.00
* Subprograma ......: Mantenimiento de Alumnos.
* Programador ......: Fco. Javier Pérez.
* * * * * *
* AltasAlu()  : Funcion para las ALTAS DE ALUMNOS.
* BajasAlu()  : Funcion para las BAJAS DE ALUMNOS.
* ConsulAlu() : Funcion para las CONSULTAS DE ALUMNOS.
* ModifAlu()  : Funcion para las MODIFICACIONES DE ALUMNOS.
* LAlu_Cod()  : Funcion para LISTADO DE ALUMNOS POR CODIGO.
* LAlu_Nom()  : Funcion para LISTADO DE ALUMNOS POR NOMBRE.
* AbrirBBDD() : Funcion para abrir los ficheros.
* CerrarBBDD(): Funcion para cerrar los ficheros.
* InitVars    : Procedimiento para inicializar las varibles del fichero.
* Literales   : Procedimiento para mostrar los literales de la patalla.
* PedirDatos  : Procedimiento para pedir los datos de la pantalla.
* MostrarDatos: Procedimiento para mostrar los datos en pantalla.
* Salvar      : Procedimiento para salvar los datos de memoria en el fichero.
* Recuperar   : Procedimiento para recuperar los datos del fichero a memoria.
* Buscar()    : Funcion para busquedas. Pregunta literal a buscar.
* Visualizar(): Funcion para visualizar todo el fichero.
* Control()   : Funcion de navegacion por el fichero en modo consultas.
* * * * * *

#include "inkey.ch"

MEMVAR cRuta, cCNormal, cCpanta, cCMensa

// Definición de variables STATIC. Sólo visibles desde este programa.
   STATIC nAluCodigo
   STATIC cAluNombre
   STATIC cAluDirec
   STATIC cAluCodPos
   STATIC cAluPobla
   STATIC cAluProvin
   STATIC cAluDNINIF
   STATIC cAluTlfno1
   STATIC cAluTlfno2
   STATIC dAluFNacim
   STATIC cAluObser1
   STATIC cAluObser2

//
FUNCTION AltasAlu( )
   LOCAL cPantalla := SAVESCREEN( 3,0,24,79 )
   LOCAL GetList   := {}
   LOCAL cColorAnt := SETCOLOR( )
   LOCAL lSalir    := .T.
   LOCAL cCorrecto := " "

   SETCOLOR( cCNormal )
   @ 3,0 CLEAR TO 24,79
   SETCOLOR( cCPanta )
   SET( _SET_INTENSITY, .F. )
   SETCURSOR( 1 )
   SET KEY K_F5 TO Buscar
   SET KEY K_F9 TO Visualizar
   IF AbrirBBDD( )
      CajaTitulo( 5,8,20,70,2," Altas de Alumnos "," F5=Buscar | F9=Visualizar " )
      DO Literales
      lSalir := .T.
      DO WHILE lSalir
         DO InitVars
         DO MostrarDatos
         @ 7,23 GET nAluCodigo PICTURE "99999"
         READ
         IF !EMPTY( nAluCodigo ) .AND. LASTKEY( ) != K_ESC
            SEEK( nAluCodigo )
            IF FOUND( )
               SETCOLOR( cCMensa )
               SHOW_MSG( 0,"El registro ya existe")
               SETCOLOR( cCPanta )
            ELSE
               DBAPPEND( )
               IF NETERR( )
                  ALERT( "¡¡¡ ACCESO DENEGADO !!!;;No se puede añadir el registro" )
               ELSE
                  ALU003->Codigo := nAluCodigo
                  ALU003->( DBCOMMIT() )
                  DO PedirDatos
                  IF !EMPTY( nAluCodigo ) .AND. LASTKEY( ) != K_ESC
                     SET( _SET_CONFIRM, .F. )
                     @ 18,25 SAY "¨Confirma los datos (S/N)?" GET cCorrecto;
                             PICTURE "!" VALID( cCorrecto $ "SN" )
                     READ
                     @ 18,25 SAY "                               "
                     IF cCorrecto == "S"
                        DO Salvar
                        ALU003->( DBCOMMIT( ) )
                        UNLOCK
                        ALU003->( DBCOMMIT() )
                        SETCOLOR( cCMensa )
                        SHOW_MSG( 0,"Se ha salvado el registro" )
                        SETCOLOR( cCPanta )
                     ELSE
                        DBDELETE( )
                        ALU003->( DBCOMMIT( ) )
                     ENDIF
                     SET( _SET_CONFIRM, .T. )
                     cCorrecto := " "
                  ELSE
                     DBDELETE( )
                     ALU003->( DBCOMMIT( ) )
                  ENDIF
               ENDIF
            ENDIF
         ELSE
            lSalir := .F.
         ENDIF
      ENDDO
   ENDIF
   CerrarBBDD( )
   RESTSCREEN( 3,0,24,79,cPantalla )
   SETCOLOR( cColorAnt )
   SET( _SET_INTENSITY, .T. )
   SETCURSOR( 0 )
   SET KEY K_F5 TO
   SET KEY K_F9 TO
 RETURN .T.

//
FUNCTION BajasAlu()
   LOCAL cPantalla := SAVESCREEN( 3,0,24,79 )
   LOCAL GetList   := {}
   LOCAL cColorAnt := SETCOLOR( )
   LOCAL lSalir    := .T.
   LOCAL cCorrecto := " "

   SETCOLOR( cCNormal )
   @ 3,0 CLEAR TO 24,79
   SETCOLOR( cCPanta )
   SET( _SET_INTENSITY, .F. )
   SETCURSOR( 1 )
   SET KEY K_F5 TO Buscar
   SET KEY K_F9 TO Visualizar
   IF AbrirBBDD( )
      CajaTitulo( 5,8,20,70,2," Bajas de Alumnos "," F5=Buscar | F9=Visualizar " )
      DO Literales
      lSalir := .T.
      DO WHILE lSalir
         DO InitVars
         DO MostrarDatos
         @ 7,23 GET nAluCodigo PICTURE "99999"
         READ
         IF !EMPTY( nAluCodigo ) .AND. LASTKEY( ) != K_ESC
            SEEK( nAluCodigo )
            IF !FOUND( )
               SETCOLOR( cCMensa )
               SHOW_MSG( 0,"El registro no existe" )
               SETCOLOR( cCPanta )
            ELSE
               IF !RLOCK( )
                  ALERT( "Registro usado por otro usuario" )
               ELSE
                  DO Recuperar
                  DO MostrarDatos
                  SET( _SET_CONFIRM, .F. )
                  @ 18,25 SAY "¨Confirma la baja (S/N)?" GET cCorrecto;
                              PICTURE "!" VALID( cCorrecto $ "SN" )
                  READ
                  @ 18,25 SAY "                             "
                  IF cCorrecto == "S"
                     DBDELETE( )
                     ALU003->( DBCOMMIT() )
                     SETCOLOR( cCMensa )
                     SHOW_MSG( 0,"Se ha borrado el registro" )
                     SETCOLOR( cCPanta )
                  ELSE
                     UNLOCK
                     ALU003->( DBCOMMIT() )
                  ENDIF
                  SET( _SET_CONFIRM, .T. )
                  cCorrecto := " "
               ENDIF
            ENDIF
         ELSE
            lSalir := .F.
         ENDIF
      ENDDO
   ENDIF
   CerrarBBDD( )
   RESTSCREEN( 3,0,24,79,cPantalla )
   SETCOLOR( cColorAnt )
   SET( _SET_INTENSITY, .T. )
   SETCURSOR( 0 )
   SET KEY K_F5 TO
   SET KEY K_F9 TO
 RETURN .T.


//
FUNCTION ConsulAlu()
   LOCAL cPantalla := SAVESCREEN( 3,0,24,79 )
   LOCAL GetList   := {}
   LOCAL cColorAnt := SETCOLOR( )
   LOCAL lSalir    := .T.
   LOCAL cCorrecto := " "

   SETCOLOR( cCNormal )
   @ 3,0 CLEAR TO 24,79
   SETCOLOR( cCPanta )
   SET( _SET_INTENSITY, .F. )
   SETCURSOR( 1 )
   SET KEY K_F5 TO Buscar
   SET KEY K_F9 TO Visualizar
   IF AbrirBBDD( )
      CajaTitulo( 5,8,20,70,2," Consultas de Alumnos "," F5=Buscar | F9=Visualizar " )
      DO Literales
      lSalir := .T.
      DO WHILE lSalir
         DO InitVars
         DO MostrarDatos
         @ 7,23 GET nAluCodigo PICTURE "99999"
         READ
         IF !EMPTY( nAluCodigo ) .AND. LASTKEY( ) != K_ESC
            SEEK( nAluCodigo )
            IF !FOUND( )
               SETCOLOR( cCMensa )
               SHOW_MSG( 0,"El registro no existe" )
               SETCOLOR( cCPanta )
            ELSE
               DO Recuperar
               DO MostrarDatos
               Control()
            ENDIF
         ELSE
            lSalir := .F.
         ENDIF
      ENDDO
   ENDIF
   CerrarBBDD( )
   RESTSCREEN( 3,0,24,79,cPantalla )
   SETCOLOR( cColorAnt )
   SET( _SET_INTENSITY, .T. )
   SETCURSOR( 0 )
   SET KEY K_F5 TO
   SET KEY K_F9 TO
 RETURN .T.

//
FUNCTION ModifAlu()
   LOCAL cPantalla := SAVESCREEN( 3,0,24,79 )
   LOCAL GetList   := {}
   LOCAL cColorAnt := SETCOLOR( )
   LOCAL lSalir    := .T.
   LOCAL cCorrecto := " "

   SETCOLOR( cCNormal )
   @ 3,0 CLEAR TO 24,79
   SETCOLOR( cCPanta )
   SET( _SET_INTENSITY, .F. )
   SETCURSOR( 1 )
   SET KEY K_F5 TO Buscar
   SET KEY K_F9 TO Visualizar
   IF AbrirBBDD( )
      CajaTitulo( 5,8,20,70,2," Modificaciones de Alumnos "," F5=Buscar | F9=Visualizar " )
      DO Literales
      lSalir := .T.
      DO WHILE lSalir
         DO InitVars
         DO MostrarDatos
         @ 7,23 GET nAluCodigo PICTURE "99999"
         READ
         IF !EMPTY( nAluCodigo ) .AND. LASTKEY( ) != K_ESC
            SEEK( nAluCodigo )
            IF !FOUND( )
               SETCOLOR( cCMensa )
               SHOW_MSG( 0,"El registro no existe" )
               SETCOLOR( cCPanta )
            ELSE
               IF !RLOCK( )
                  ALERT( "Registro usado por otro usuario" )
               ELSE
                  DO Recuperar
                  DO MostrarDatos
                  DO PedirDatos
                  IF nAluCodigo != 0 .AND. LASTKEY( ) != K_ESC
                     SET( _SET_CONFIRM, .F. )
                     @ 18,25 SAY "¨Confirma los datos (S/N)?" GET cCorrecto;
                             PICTURE "!" VALID( cCorrecto $ "SN" )
                     READ
                     @ 18,25 SAY "                               "
                     IF cCorrecto == "S"
                        DO Salvar
                        ALU003->( DBCOMMIT() )
                        SETCOLOR( cCMensa )
                        SHOW_MSG( 0,"Se ha salvado el registro" )
                        SETCOLOR( cCPanta )
                     ELSE
                        UNLOCK
                        ALU003->( DBCOMMIT() )
                     ENDIF
                     SET( _SET_CONFIRM, .T. )
                     cCorrecto := " "
                  ELSE
                     UNLOCK
                     ALU003->( DBCOMMIT() )
                  ENDIF
               ENDIF
            ENDIF
         ELSE
            lSalir := .F.
         ENDIF
      ENDDO
   ENDIF
   CerrarBBDD( )
   RESTSCREEN( 3,0,24,79,cPantalla )
   SETCOLOR( cColorAnt )
   SET( _SET_INTENSITY, .T. )
   SETCURSOR( 0 )
   SET KEY K_F5 TO
   SET KEY K_F9 TO
 RETURN .T.

//
FUNCTION LAlu_Cod
   LOCAL GetList   := {}
   LOCAL cPantalla := SAVESCREEN( 3,0,24,79 )
   LOCAL nDesde    := 0
   LOCAL nHasta    := 99999
   LOCAL cDestino  := "P"
   LOCAL cCorrecto := "N"
   LOCAL cColorAnt := SETCOLOR( )
   LOCAL oListado , oCol, nTecla
   LOCAL lMas      := .T.

   SETCOLOR( cCNormal )
   @ 3,0 CLEAR TO 24,79
   SETCOLOR( cCPanta )
   SET( _SET_INTENSITY, .F. )
   SET( _SET_DELIMITERS, .T. )
   SETCURSOR( 1 )
   IF AbrirBBDD( )
      CajaTitulo( 5,15,17,65,2," Listado de Alumnos por Codigo "," ESC = Salir | 132 Columnas " )
      @  8,25 SAY "Codigo desde:" GET nDesde PICTURE "99999"
      @ 10,25 SAY "Codigo Hasta:" GET nHasta PICTURE "99999"
      @ 12,25 SAY "Destino del listado(P/I):" GET cDestino ;
              PICTURE "!" VALID( cDestino $ "PI" )
      @ 14,25 SAY "¨Confirma los datos(S/N)?" GET cCorrecto ;
              PICTURE "!" VALID( cCorrecto $ "SN" )
      READ

      IF cCorrecto == "S"
         IF cDestino == "P"
            SET FILTER TO ALU003->codigo >= nDesde .AND. ;
                          ALU003->codigo <= nHasta
            DBGOTOP( )
            CajaTitulo( 3,0,24,79,2," Listado de Alumnos por Codigo ",;
                                     " Pulse <ESC> para Salir " )
            oListado := TBrowseDB( 4,1,23,78 )
            oListado:headSep := "Í"
            oCol := TBColumnNew( "Codigo", { || ALU003->CODIGO } )
            oListado:addColumn( oCol )
            oCol := TBColumnNew( "Nombre", { || ALU003->NOMBRE } )
            oListado:addColumn( oCol )
            oCol := TBColumnNew( "Direccion", { || ALU003->DIRECCION } )
            oListado:addColumn( oCol )
            oCol := TBColumnNew( "Cod.Postal", { || ALU003->CODPOSTAL } )
            oListado:addColumn( oCol )
            oCol := TBColumnNew( "Poblacion", { || ALU003->POBLACION } )
            oListado:addColumn( oCol )
            oCol := TBColumnNew( "Provincia", { || ALU003->PROVINCIA } )
            oListado:addColumn( oCol )
            oCol := TBColumnNew( "DNI/NIF", { || ALU003->DNINIF } )
            oListado:addColumn( oCol )
            oCol := TBColumnNew( "Telefono 1", { || ALU003->TELEFONO1 } )
            oListado:addColumn( oCol )
            oCol := TBColumnNew( "Telefono 2", { || ALU003->TELEFONO2 } )
            oListado:addColumn( oCol )
            oCol := TBColumnNew( "F.Nacimiento", { || ALU003->FECNACIM } )
            oListado:addColumn( oCol )
            DO WHILE ( lMas )
               nTecla := 0
               DO WHILE nTecla == 0 .AND. .NOT. oListado:stable
                  oListado:stabilize( )
                  nTecla := INKEY( )
               ENDDO
               IF oListado:stable
                  IF oListado:hitTop .OR. oListado:hitBottom
                     TONE( 125,0 )
                  ENDIF
                  nTecla := INKEY( 0 )
                  DO CASE
                     CASE nTecla == K_ESC
                          lMas := .F.
                     CASE nTecla == K_DOWN
                          oListado:down( )
                     CASE nTecla == K_PGDN
                          oListado:pageDown( )
                     CASE nTecla == K_UP
                          oListado:up( )
                     CASE nTecla == K_PGUP
                          oListado:pageUp( )
                     CASE nTecla == K_RIGHT
                          oListado:right( )
                     CASE nTecla == K_LEFT
                          oListado:left( )
                     OTHERWISE
                          TONE( 125,0 )
                  ENDCASE
               ENDIF
            ENDDO
            SET FILTER TO
         ELSE
            REPORT FORM "reports\gesalu01.frm" ;
                   FOR ALU003->codigo >= nDesde .AND. ;
                       ALU003->codigo <= nHasta ;
                   TO PRINTER NOCONSOLE
         ENDIF
      ENDIF
   ENDIF
   CerrarBBDD( )
   RESTSCREEN( 3,0,24,79,cPantalla )
   SETCOLOR( cColorAnt )
   SET( _SET_INTENSITY, .T. )
   SET( _SET_DELIMITERS, .F. )
   SETCURSOR( 0 )
 RETURN .T.

//
FUNCTION LAlu_Nom
   LOCAL GetList   := {}
   LOCAL cPantalla := SAVESCREEN( 3,0,24,79 )
   LOCAL cDesde    := SPACE( 35 )
   LOCAL cHasta    := "ZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZ"
   LOCAL cDestino  := "P"
   LOCAL cCorrecto := "N"
   LOCAL cColorAnt := SETCOLOR( )
   LOCAL oListado, oCol, nTecla
   LOCAL lMas      := .T.

   SETCOLOR( cCNormal )
   @ 3,0 CLEAR TO 24,79
   SETCOLOR( cCPanta )
   SET( _SET_INTENSITY, .F. )
   SET( _SET_DELIMITERS, .T. )
   SETCURSOR( 1 )
   IF AbrirBBDD( )
      DBSETORDER( 2 )
      CajaTitulo( 5,10,17,70,2," Listado de Alumnos por Nombre "," ESC = Salir | 132 Columnas " )
      @  8,17 SAY "Nombre desde:" GET cDesde PICTURE "@K!"
      @ 10,17 SAY "Nombre Hasta:" GET cHasta PICTURE "@K!"
      @ 12,25 SAY "Destino del listado(P/I):" GET cDestino ;
              PICTURE "!" VALID( cDestino $ "PI" )
      @ 14,25 SAY "¨Confirma los datos(S/N)?" GET cCorrecto ;
              PICTURE "!" VALID( cCorrecto $ "SN" )
      READ

      IF cCorrecto == "S"
         IF cDestino == "P"
            SET FILTER TO ALU003->nombre >= cDesde .AND. ;
                          ALU003->nombre <= cHasta
            DBGOTOP( )
            CajaTitulo( 3,0,24,79,2," Listado de Alumnos por Nombre ",;
                                     " Pulse <ESC> para Salir " )
            oListado := TBrowseDB( 4,1,23,78 )
            oListado:headSep := "Í"
            oCol := TBColumnNew( "Nombre", { || ALU003->NOMBRE } )
            oListado:addColumn( oCol )
            oCol := TBColumnNew( "Codigo", { || ALU003->CODIGO } )
            oListado:addColumn( oCol )
            oCol := TBColumnNew( "Direccion", { || ALU003->DIRECCION } )
            oListado:addColumn( oCol )
            oCol := TBColumnNew( "Cod.Postal", { || ALU003->CODPOSTAL } )
            oListado:addColumn( oCol )
            oCol := TBColumnNew( "Poblacion", { || ALU003->POBLACION } )
            oListado:addColumn( oCol )
            oCol := TBColumnNew( "Provincia", { || ALU003->PROVINCIA } )
            oListado:addColumn( oCol )
            oCol := TBColumnNew( "DNI/NIF", { || ALU003->DNINIF } )
            oListado:addColumn( oCol )
            oCol := TBColumnNew( "Telefono 1", { || ALU003->TELEFONO1 } )
            oListado:addColumn( oCol )
            oCol := TBColumnNew( "Telefono 2", { || ALU003->TELEFONO2 } )
            oListado:addColumn( oCol )
            oCol := TBColumnNew( "F.Nacimiento", { || ALU003->FECNACIM } )
            oListado:addColumn( oCol )
            DO WHILE ( lMas )
               nTecla := 0
               DO WHILE nTecla == 0 .AND. .NOT. oListado:stable
                  oListado:stabilize( )
                  nTecla := INKEY( )
               ENDDO
               IF oListado:stable
                  IF oListado:hitTop .OR. oListado:hitBottom
                     TONE( 125,0 )
                  ENDIF
                  nTecla := INKEY( 0 )
                  DO CASE
                     CASE nTecla == K_ESC
                          lMas := .F.
                     CASE nTecla == K_DOWN
                          oListado:down( )
                     CASE nTecla == K_PGDN
                          oListado:pageDown( )
                     CASE nTecla == K_UP
                          oListado:up( )
                     CASE nTecla == K_PGUP
                          oListado:pageUp( )
                     CASE nTecla == K_RIGHT
                          oListado:right( )
                     CASE nTecla == K_LEFT
                          oListado:left( )
                     OTHERWISE
                          TONE( 125,0 )
                  ENDCASE
               ENDIF
            ENDDO
            SET FILTER TO
         ELSE
            REPORT FORM "reports\gesalu02.frm" ;
                   FOR ALU003->nombre >= cDesde .AND. ;
                       ALU003->nombre <= cHasta ;
                   TO PRINTER NOCONSOLE
         ENDIF
      ENDIF
   ENDIF
   CerrarBBDD( )
   RESTSCREEN( 3,0,24,79,cPantalla )
   SETCOLOR( cColorAnt )
   SET( _SET_INTENSITY, .T. )
   SET( _SET_DELIMITERS, .F. )
   SETCURSOR( 0 )
 RETURN .T.

//
///////////////////////////////////////////////////////////////////////////
//

//
STATIC FUNCTION AbrirBBDD()
   USE ( "DATOS\ALUMNOS.DBF" ) INDEX ( "DATOS\ALUMNOS.NT1" ) ,;
       ( "DATOS\ALUMNOS.NT2" ) SHARED ALIAS ALU003 NEW
   IF NETERR( )
      ALERT( "¡¡¡ ACCESO DENEGADO !!!;;El fichero de ALUMNOS está siendo utilizado;en modo exclusivo por otro usuario" )
      RETURN .F.
      DBSETORDER( 1 )
   ENDIF
 RETURN .T.

//
STATIC PROCEDURE CerrarBBDD
   ALU003->( DBCLOSEAREA() )

//
STATIC PROCEDURE InitVars
   nAluCodigo := 0
   cAluNombre := SPACE( 35 )
   cAluDirec  := SPACE( 35 )
   cAluCodPos := SPACE( 5 )
   cAluPobla  := SPACE( 25 )
   cAluProvin := SPACE( 25 )
   cAluDNINIF := SPACE( 12 )
   cAluTlfno1 := SPACE( 15 )
   cAluTlfno2 := SPACE( 15 )
   dAluFNacim := CTOD( "  /  /  " )
   cAluObser1 := SPACE( 40 )
   cAluObser2 := SPACE( 40 )

//
STATIC PROCEDURE Literales
   @  7,11 SAY "Codigo...: [     ]"
   @  8,11 SAY "Nombre...: [                                   ]"
   @  9,11 SAY "Direccion: [                                   ]"
   @ 10,11 SAY "Poblacion: [     ] [                         ]"
   @ 11,11 SAY "Provincia: [                         ]"
   @ 12,11 SAY "Telefonos: [               ] [               ]"
   @ 13,11 SAY "F. Nacimiento: [        ]"
   @ 14,11 SAY "DNI-NIF  : [            ]"
   @ 15,11 SAY "Observaciones: [                                        ]"
   @ 16,11 SAY "               [                                        ]"

//
STATIC PROCEDURE PedirDatos
   LOCAL getlist := {}
   @  8,23 GET cAluNombre PICTURE "@!"
   @  9,23 GET cAluDirec PICTURE "@!"
   @ 10,23 GET cAluCodPos PICTURE "99999"
   @ 10,31 GET cAluPobla  PICTURE "@!"
   @ 11,23 GET cAluProvin PICTURE "@!"
   @ 12,23 GET cAluTlfno1 PICTURE "@!"
   @ 12,41 GET cAluTlfno2 PICTURE "@!"
   @ 13,27 GET dAluFNacim PICTURE "@!"
   @ 14,23 GET cAluDNINIF PICTURE "@!"
   @ 15,27 GET cAluObser1 PICTURE "@!"
   @ 16,27 GET cAluObser2 PICTURE "@!"
   READ

//
STATIC PROCEDURE MostrarDatos
   @  7,23 SAY nAluCodigo PICTURE "99999"
   @  8,23 SAY cAluNombre
   @  9,23 SAY cAluDirec
   @ 10,23 SAY cAluCodPos
   @ 10,31 SAY cAluPobla
   @ 11,23 SAY cAluProvin
   @ 12,23 SAY cAluTlfno1
   @ 12,41 SAY cAluTlfno2
   @ 13,27 SAY dAluFNacim
   @ 14,23 SAY cAluDNINIF
   @ 15,27 SAY cAluObser1
   @ 16,27 SAY cAluObser2

//
STATIC PROCEDURE Salvar
   ALU003->Codigo := nCliCodigo
   ALU003->Nombre := cCliNombre
   ALU003->Direcion  := cCliDirec
   ALU003->CodPostal := cCliCodPos
   ALU003->Poblacion  := cCliPobla
   ALU003->Provincia := cCliProvin
   ALU003->DNINIF := cCliDNINIF
   ALU003->Telefono1 := cCliTlfno1
   ALU003->Telefono2 := cCliTlfno2
   ALU003->FecNacim := dCliFNacim
   ALU003->Obser1 := cCliObser1
   ALU003->Obser2 := cCliObser2

//
STATIC PROCEDURE Recuperar
   nAluCodigo := ALU003->Codigo
   cAluNombre := ALU003->Nombre
   cAluDirec  := ALU003->Direccion
   cAluCodPos := ALU003->CodPostal
   cAluPobla  := ALU003->Poblacion
   cAluProvin := ALU003->Provincia
   cAluDNINIF := ALU003->DNINIF
   cAluTlfno1 := ALU003->Telefono1
   cAluTlfno2 := ALU003->Telefono2
   dAluFNacim := ALU003->FecNacim
   cAluObser1 := ALU003->Obser1
   cAluObser2 := ALU003->Obser2

//
STATIC FUNCTION Buscar( cProcName, nProcLine, cReadVar )
   LOCAL areactual := SELECT( )
   LOCAL cPantalla := SAVESCREEN( 3,0,24,79 )
   LOCAL cABuscar  := SPACE( 30 )
   LOCAL GetList   := {}
   LOCAL oBuscar, oCol, nTecla
   LOCAL lMas      := .T.

   IF cReadVar == "NALUCODIGO"
      CajaTitulo( 10,20,12,60,2," Alumno a buscar: " )
      @ 11,25 GET cABuscar PICTURE "@!"
      READ
      IF LASTKEY( ) != K_ESC
         DBSETORDER( 2 )
         IF RECCOUNT( ) != 0
            SEEK( cABuscar )
         ENDIF
      ENDIF
      CajaTitulo( 3,0,24,50,2," Visualizacion de Alumnos ", " <ESC> Salir | <INTRO> Seleccionar " )
      oBuscar := TBrowseDB( 4,1,23,49 )
      oBuscar:headSep := "Í"
      oCol := TBColumnNew( "Nombre", { || ALU003->NOMBRE } )
      oBuscar:addColumn( oCol )
      oCol := TBColumnNew( "Codigo", { || ALU003->CODIGO } )
      oBuscar:addColumn( oCol )
   ENDIF

   IF cReadVar == "NALUCODIGO" .AND. LASTKEY() != K_ESC
      DO WHILE ( lMas )
         nTecla := 0
         DO WHILE nTecla == 0 .AND. .NOT. oBuscar:stable
            oBuscar:stabilize( )
            nTecla := INKEY( )
         ENDDO
         IF oBuscar:stable
            IF oBuscar:hitTop .OR. oBuscar:hitBottom
               TONE( 125,0 )
            ENDIF
            nTecla := INKEY( 0 )
            DO CASE
               CASE nTecla == K_ESC
                    lMas := .F.
               CASE nTecla == K_ENTER
                    IF cReadVar == "NALUCODIGO"
                       nAluCodigo := ALU003->Codigo
                    ENDIF
                    lMas := .F.
               CASE nTecla == K_DOWN
                    oBuscar:down( )
               CASE nTecla == K_PGDN
                    oBuscar:pageDown( )
               CASE nTecla == K_UP
                    oBuscar:up( )
               CASE nTecla == K_PGUP
                    oBuscar:pageUp( )
               CASE nTecla == K_RIGHT
                    oBuscar:right( )
               CASE nTecla == K_LEFT
                    oBuscar:left( )
               OTHERWISE
                    TONE( 125,0 )
            ENDCASE
         ENDIF
      ENDDO
   ENDIF
   DBSETORDER( 1 )
   RESTSCREEN( 3,0,24,79,cPantalla )
   SELECT( areactual )
 RETURN NIL

//
STATIC FUNCTION Visualizar( cProcName, nProcLine, cReadVar )
   LOCAL areactual := SELECT( )
   LOCAL cPantalla := SAVESCREEN( 3,0,24,50 )
   LOCAL oVisualizar, oCol, nTecla
   LOCAL lMas      := .T.

   IF cReadVar == "NALUCODIGO"
      DBSETORDER( 2 )
      IF RECCOUNT( ) != 0
         DBGOTOP( )
      ENDIF
      CajaTitulo( 3,0,24,50,2," Visualizacion de Alumnos ", " <ESC> Salir | <INTRO> Seleccionar " )
      oVisualizar := TBrowseDB( 4,1,23,49 )
      oVisualizar:headSep := "Í"
      oCol:= TBColumnNew( "Nombre", { || ALU003->NOMBRE } )
      oVisualizar:addColumn( oCol )
      oCol := TBColumnNew( "Codigo", { || ALU003->CODIGO } )
      oVisualizar:addColumn( oCol )
   ENDIF

   IF cReadVar == "NALUCODIGO"
      DO WHILE ( lMas )
         oVisualizar:forceStable()
         nTecla := 0
         DO WHILE nTecla == 0 .AND. .NOT. oVisualizar:stable
            oVisualizar:stabilize( )
            nTecla := INKEY( )
         ENDDO
         IF oVisualizar:stable
            IF oVisualizar:hitTop .OR. oVisualizar:hitBottom
               TONE( 125,0 )
            ENDIF
            nTecla := INKEY( 0 )
            DO CASE
               CASE nTecla == K_ESC
                    lMas := .F.
               CASE nTecla == K_ENTER
                    IF cReadVar == "NALUCODIGO"
                       nCliCodigo := ALU003->Codigo
                    ENDIF
                    lMas := .F.
               CASE nTecla == K_DOWN
                    oVisualizar:down( )
               CASE nTecla == K_PGDN
                    oVisualizar:pageDown( )
               CASE nTecla == K_UP
                    oVisualizar:up( )
               CASE nTecla == K_PGUP
                    oVisualizar:pageUp( )
               CASE nTecla == K_RIGHT
                    oVisualizar:right( )
               CASE nTecla == K_LEFT
                    oVisualizar:left( )
               OTHERWISE
                    TONE( 125,0 )
            ENDCASE
         ENDIF
      ENDDO
   ENDIF
   DBSETORDER( 1 )
   RESTSCREEN( 3,0,24,50,cPantalla )
   SELECT( areactual )
 RETURN NIL

//
STATIC FUNCTION Control()
   LOCAL nTecla   := 0
   LOCAL nPrimero := 0
   LOCAL nUltimo  := 0
   LOCAL nActual  := 0

   nActual := RECNO( )
   DBGOTOP( )
   nPrimero := RECNO( )
   DBGOBOTTOM( )
   nUltimo  := RECNO( )
   DBGOTO( nActual )
   SETCURSOR( 0 )
   @ 18,15 SAY "Posibilidades: (Inicio) (-) (+) (fin) (ESC=Salir)"
   DO WHILE nTecla != K_ESC
      @ 19,10 SAY SPACE( 60 )
      IF nPrimero == nUltimo
         @ 19,25 SAY "Principio/Final del fichero"
      ELSEIF RECNO( ) == nPrimero
         @ 19,28 SAY "Principio del fichero"
      ELSEIF RECNO( ) == nUltimo
         @ 19,30 SAY "Final del fichero"
      ENDIF
      nTecla := INKEY( 0 )
      IF nTecla == K_HOME
         DBGOTOP( )
      ELSEIF nTecla == K_END
         DBGOBOTTOM( )
      ELSEIF nTecla == 43
         IF RECNO( ) != nUltimo
            DBSKIP( )
         ENDIF
      ELSEIF nTecla == 45
         DBSKIP( -1 )
      ENDIF
      DO Recuperar
      DO MostrarDatos
   ENDDO
   @ 18,15 SAY "                                                 "
   @ 19,10 SAY SPACE( 60 )
   SETCURSOR( 1 )
 RETURN NIL

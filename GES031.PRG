* * * * * * * * * * *
* Programa .........: Gestion para Academias v1.00
* Subprograma ......: Creacion de Ficheros de Datos.
* Programador ......: Fco. Javier Perez.
* * * * * *
* CrearDatos() : Funcion general para la creacion de las bases de datos.
* CrearDis()   : Funcion para crear Alumnos.
* * * * *

MEMVAR cCNormal, cCMenus

//
FUNCTION CrearDatos()
   LOCAL nMenu := 1
   LOCAL cPantalla := SAVESCREEN( 6,13,22,67 )
   LOCAL cPassword := SPACE( 20 )
   LOCAL GetList := {}
   LOCAL cPantAcceso := ""

// Proceso utilizado para pedir una clave de acceso a fin de prevenir usos indebidos.
   cPantAcceso := SAVESCREEN( 7,20,16,60 )
   @ 7,20 CLEAR TO 16,60
   CajaTitulo( 7,20,16,60,2," ACCESO RESTRINGIDO ","" )
   @ 10,25 SAY "INTRODUZCA CLAVE DE ACCESO....:"
   @ 13,30 GET cPassword COLOR "B/B"
   READ
   RESTSCREEN( 7,20,16,60,cPantAcceso )
   IF !( cPassword == " ACCESO RESTRINGIDO " )
      ALERT( "¡¡¡ A T E N C I O N !!!;;PASSWORD ERRONEO;PROCESO NO AUTORIZADO" )
   ELSE
// Proceso utilizado para crear los ficheros. Se filtra anteriormente para no borrar datos.
      DO WHILE .T.
         CajaTitulo( 6,13,22,67,2," CREACION DE FICHEROS DE DATOS ", "" )
         @  7,15 PROMPT " 1) Creacion de Alumnos                            "
         @  8,15 PROMPT " 2) Creacion de Todos los Ficheros                 "

         MENU TO nMenu
         DO CASE
            CASE nMenu == 1
                 CrearAlu()
            CASE nMenu == 2
                 CrearAlu()
         ENDCASE
         RESTSCREEN( 6,13,22,67,cPantalla )
         RETURN NIL
      ENDDO
    ENDIF
 RETURN NIL

STATIC FUNCTION CrearAlu()
       LOCAL aFAlumnos[12][4]

       aFAlumnos[1][1] := "CODIGO"
       aFAlumnos[1][2] := "N"
       aFAlumnos[1][3] := 5
       aFAlumnos[1][4] := 0
       *
       aFAlumnos[2][1] := "NOMBRE"
       aFAlumnos[2][2] := "C"
       aFAlumnos[2][3] := 35
       aFAlumnos[2][4] := 0
       *
       aFAlumnos[3][1] := "DIRECCION"
       aFAlumnos[3][2] := "C"
       aFAlumnos[3][3] := 35
       aFAlumnos[3][4] := 0
       *
       aFAlumnos[4][1] := "CODPOSTAL"
       aFAlumnos[4][2] := "C"
       aFAlumnos[4][3] := 5
       aFAlumnos[4][4] := 0
       *
       aFAlumnos[5][1] := "POBLACION"
       aFAlumnos[5][2] := "C"
       aFAlumnos[5][3] := 25
       aFAlumnos[5][4] := 0
       *
       aFAlumnos[6][1] := "PROVINCIA"
       aFAlumnos[6][2] := "C"
       aFAlumnos[6][3] := 25
       aFAlumnos[6][4] := 0
       *
       aFAlumnos[7][1] := "DNINIF"
       aFAlumnos[7][2] := "C"
       aFAlumnos[7][3] := 12
       aFAlumnos[7][4] := 0
       *
       aFAlumnos[8][1] := "TELEFONO1"
       aFAlumnos[8][2] := "C"
       aFAlumnos[8][3] := 15
       aFAlumnos[8][4] := 0
       *
       aFAlumnos[9][1] := "TELEFONO2"
       aFAlumnos[9][2] := "C"
       aFAlumnos[9][3] := 15
       aFAlumnos[9][4] := 0
       *
       aFAlumnos[10][1] := "FECNACIM"
       aFAlumnos[10][2] := "D"
       aFAlumnos[10][3] := 8
       aFAlumnos[10][4] := 0
       *
       aFAlumnos[11][1] := "OBSER1"
       aFAlumnos[11][2] := "C"
       aFAlumnos[11][3] := 40
       aFAlumnos[11][4] := 0
       *
       aFAlumnos[12][1] := "OBSER2"
       aFAlumnos[12][2] := "C"
       aFAlumnos[12][3] := 40
       aFAlumnos[12][4] := 0
       *
       DBCREATE( "DATOS\ALUMNOS", aFAlumnos )
 RETURN NIL

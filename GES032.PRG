* * * * * * * * * * *
* Programa .........: Gestion para Academias v1.00
* Subprograma ......: Creacion de Ficheros de Indices.
* Programador ......: Fco. Javier Pérez.
* * * * * *
* CrearDatos() : Función general para la creacion de las bases de datos.
* CrearAlu()   : Funcion para crear Alumnos.
* * * * *

MEMVAR cCNormal, cCMenus

//
FUNCTION CrearIndic()
   LOCAL nMenu := 1
   LOCAL cPantalla := SAVESCREEN( 6,13,22,67 )
   LOCAL aFDistrib

   DO WHILE .T.
      CajaTitulo( 6,13,22,67,2," CREACION DE FICHEROS DE INDICES ", "" )
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
 RETURN NIL

//
STATIC FUNCTION CrearAlu()
   FIELD CODIGO, NOMBRE

   USE ( "DATOS\ALUMNOS.DBF" ) EXCLUSIVE ALIAS ALU032 NEW
   INDEX ON CODIGO TO ( "DATOS\ALUMNOS.NT1" )
   INDEX ON NOMBRE TO ( "DATOS\ALUMNOS.NT2" )
   ALU032->(DBCLOSEAREA() )
 RETURN NIL

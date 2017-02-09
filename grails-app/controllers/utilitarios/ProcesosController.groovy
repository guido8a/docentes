package utilitarios

import docentes.Periodo

class ProcesosController extends seguridad.Shield {
    def dbConnectionService

    def cargarDatos (){

    }

    def formato_ajax () {
        def tabla = ""
        switch (params.tipo) {
            case '1':
                tabla = "Facultades"
                break
            case '2':
                tabla = "Escuelas"
                break
            case '3':
                tabla = "Profesores"
                break
            case '4':
                tabla = "Estudiantes"
                break
            case '5':
                tabla = "Materias"
                break
            case '6':
                tabla = "Materias que se dictan"
                break
            case '7':
                tabla = "Matriculados por materia"
                break
        }
        println "tabla: $tabla"
        return [tipo: params.tipo, tabla: tabla]
    }

    def botones_ajax () {
        return [boton: params.boton]
    }

    def borrarDatos() {
        println "borrarDatos: $params"
        def cn = dbConnectionService.getConnection()
        def prdo = Periodo.get(params.id)
        def msg = "ok_Se ha borrado todos los registros de Materias dictadas y Estudiantes Matriculados del Periodo: \"${prdo.nombre}\""

        try {
            cn.execute("delete from matr where dcta__id in (select dcta__id from dcta where prdo__id = ${prdo.id})")
            cn.execute("delete from dcta where prdo__id = ${prdo.id}")
        } catch (e) {
            println "error: $e"
            msg = "error_No se pudo borrar los registros de Materias dictadas y Estudiantes Matriculados del Periodo: \"${prdo.nombre}\""
        }
/*
        flash.message = "Se ha borrado todos los regsitros de Facultades, Escuelas, Profesores, Materials, Cursos, " +
                "Materias que se dictan, Estudiantes y Estudiantes Matriculados"
        flash.tipo = "error"
*/
        render msg
    }

    def periodos_ajax() {

    }
}

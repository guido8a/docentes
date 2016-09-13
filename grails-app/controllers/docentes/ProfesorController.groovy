package docentes

import org.springframework.dao.DataIntegrityViolationException
import seguridad.Shield


/**
 * Controlador que muestra las pantallas de manejo de Profesor
 */
class ProfesorController extends Shield {

    static allowedMethods = [save_ajax: "POST", delete_ajax: "POST"]

    /**
     * Acción que redirecciona a la lista (acción "list")
     */
    def index() {
        redirect(action:"list", params: params)
    }

    /**
     * Función que saca la lista de elementos según los parámetros recibidos
     * @param params objeto que contiene los parámetros para la búsqueda:: max: el máximo de respuestas, offset: índice del primer elemento (para la paginación), search: para efectuar búsquedas
     * @param all boolean que indica si saca todos los resultados, ignorando el parámetro max (true) o no (false)
     * @return lista de los elementos encontrados
     */
    def getList(params, all) {
        params = params.clone()
        params.max = params.max ? Math.min(params.max.toInteger(), 100) : 10
        params.offset = params.offset ?: 0
        if(all) {
            params.remove("max")
            params.remove("offset")
        }
        def list
        if(params.search) {
            def c = Profesor.createCriteria()
            list = c.list(params) {
                or {
                    /* TODO: cambiar aqui segun sea necesario */

                    ilike("apellido", "%" + params.search + "%")
                    ilike("cedula", "%" + params.search + "%")
                    ilike("estado", "%" + params.search + "%")
                    ilike("evaluar", "%" + params.search + "%")
                    ilike("nombre", "%" + params.search + "%")
                    ilike("observacion", "%" + params.search + "%")
                    ilike("sexo", "%" + params.search + "%")
                    ilike("titulo", "%" + params.search + "%")
                }
            }
        } else {
            list = Profesor.list(params)
        }
        if (!all && params.offset.toInteger() > 0 && list.size() == 0) {
            params.offset = params.offset.toInteger() - 1
            list = getList(params, all)
        }
        return list
    }

    /**
     * Acción que muestra la lista de elementos
     * @return profesorInstanceList: la lista de elementos filtrados, profesorInstanceCount: la cantidad total de elementos (sin máximo)
     */
    def list() {
        def profesorInstanceList = getList(params, false)
        def profesorInstanceCount = getList(params, true).size()
        return [profesorInstanceList: profesorInstanceList, profesorInstanceCount: profesorInstanceCount]
    }

    /**
     * Acción llamada con ajax que muestra la información de un elemento particular
     * @return profesorInstance el objeto a mostrar cuando se encontró el elemento
     * @render ERROR*[mensaje] cuando no se encontró el elemento
     */
    def show_ajax() {
        if(params.id) {
            def profesorInstance = Profesor.get(params.id)
            if(!profesorInstance) {
                render "ERROR*No se encontró Profesor."
                return
            }
            return [profesorInstance: profesorInstance]
        } else {
            render "ERROR*No se encontró Profesor."
        }
    } //show para cargar con ajax en un dialog

    /**
     * Acción llamada con ajax que muestra un formaulario para crear o modificar un elemento
     * @return profesorInstance el objeto a modificar cuando se encontró el elemento
     * @render ERROR*[mensaje] cuando no se encontró el elemento
     */
    def form_ajax() {
        def profesorInstance = new Profesor()
        if(params.id) {
            profesorInstance = Profesor.get(params.id)
            if(!profesorInstance) {
                render "ERROR*No se encontró Profesor."
                return
            }
        }
        profesorInstance.properties = params
        return [profesorInstance: profesorInstance]
    } //form para cargar con ajax en un dialog

    /**
     * Acción llamada con ajax que guarda la información de un elemento
     * @render ERROR*[mensaje] cuando no se pudo grabar correctamente, SUCCESS*[mensaje] cuando se grabó correctamente
     */
    def save_ajax() {
        def profesorInstance = new Profesor()
        if(params.id) {
            profesorInstance = Profesor.get(params.id)
            if(!profesorInstance) {
                render "ERROR*No se encontró Profesor."
                return
            }
        }
        profesorInstance.properties = params
        if(!profesorInstance.save(flush: true)) {
            render "ERROR*Ha ocurrido un error al guardar Profesor: " + renderErrors(bean: profesorInstance)
            return
        }
        render "SUCCESS*${params.id ? 'Actualización' : 'Creación'} de Profesor exitosa."
        return
    } //save para grabar desde ajax

    /**
     * Acción llamada con ajax que permite eliminar un elemento
     * @render ERROR*[mensaje] cuando no se pudo eliminar correctamente, SUCCESS*[mensaje] cuando se eliminó correctamente
     */
    def delete_ajax() {
        if(params.id) {
            def profesorInstance = Profesor.get(params.id)
            if (!profesorInstance) {
                render "ERROR*No se encontró Profesor."
                return
            }
            try {
                profesorInstance.delete(flush: true)
                render "SUCCESS*Eliminación de Profesor exitosa."
                return
            } catch (DataIntegrityViolationException e) {
                render "ERROR*Ha ocurrido un error al eliminar Profesor"
                return
            }
        } else {
            render "ERROR*No se encontró Profesor."
            return
        }
    } //delete para eliminar via ajax

    def profesor () {
//        println("params profe " + params)
        def profesor
        if(params.id){
            profesor = Profesor.get(params.id)
        }
        return [profesorInstance: profesor]

    }


    def escuelaProfesor_ajax () {
//        println("params " + params)
        def facultad
        def escuelas
        def profesor

        if(params.id){
            facultad = Facultad.get(params.id)
            escuelas = Escuela.findAllByFacultad(facultad)
            profesor = Profesor.get(params.profe)

        }else{
            escuelas = null
        }

        return [escuelas: escuelas, profesor: profesor]
    }


    def saveProfesor_ajax() {
//        println("params guardar profesor " + params)
        def profesor
        def escuela

        if(params.id){
            profesor = Profesor.get(params.id)
            escuela = Escuela.get(params.escuela)
            profesor.escuela = escuela
            profesor.nombre = params.nombre.toUpperCase()
            profesor.apellido = params.apellido.toUpperCase()
            profesor.titulo = params.titulo.toUpperCase()
            profesor.cedula = params.cedula
            profesor.sexo = params.sexo.toString()
            profesor.evaluar = params.evalua
            profesor.observacion = params.observacion
            profesor.estado = 'N'

        }else{
            profesor = new Profesor()
            escuela = Escuela.get(params.escuela)
            profesor.escuela = escuela
            profesor.nombre = params.nombre.toUpperCase()
            profesor.apellido = params.apellido.toUpperCase()
            profesor.titulo = params.titulo.toUpperCase()
            profesor.cedula = params.cedula
            profesor.sexo = params.sexo.toString()
            profesor.evaluar = params.evalua
            profesor.observacion = params.observacion
            profesor.estado = 'N'
        }

        try {
            profesor.save(flush: true)
//            println("profesor " + profesor)
            render 'ok_'+ profesor?.id
        }catch (e){
            render 'no'
            println("error al guardar el profesor " + profesor.errors)
        }

    }


    def tablaMaterias_ajax () {
//        println("params tabla mat " + params)
        def periodo = Periodo.get(params.periodo)
        def profesor
        def materias
        if(params.idProfe){
            profesor = Profesor.get(params.idProfe)
            materias = Dictan.findAllByPeriodoAndProfesor(periodo, profesor, [sort: 'materia.nombre',order: 'asc'])
        }else{
            materias = null
        }

        return [materias:materias]
    }

    def materias_ajax () {
        def profesor = Profesor.get(params.id)
        def materias = Materia.findAllByEscuela(profesor.escuela, [sort: 'nombre', order: 'asc'])
        return [materias: materias]
    }

    def agregarMateria_ajax () {
        println("params agregar m " + params)
        def profesor = Profesor.get(params.id)
        def materia = Materia.get(params.materia)
        def curso = Curso.get(params.curso)
        def periodo = Periodo.get(params.periodo)
        def paralelo = params.paralelo.toInteger()

        def existente = Dictan.findAllByProfesorAndPeriodoAndCursoAndMateriaAndParalelo(profesor, periodo, curso, materia, paralelo)

        if(existente){
            render "no_No se puede asignar la materia, ya se encuentra asignada a este profesor!"
        }else{
            def dicta = new Dictan()
            dicta.profesor = profesor
            dicta.materia = materia
            dicta.curso = curso
            dicta.periodo = periodo
            dicta.paralelo = params.paralelo.toInteger()

            try {
                dicta.save(flush:true)
                render "ok_Materia asignada correctamente"
            }catch (e){
                render "no_Error al asignar la materia"
                println("error al guardar las materias del profesor " + dicta.errors)
            }
        }

    }

    def borrarMateria_ajax (){
        def dicta = Dictan.get(params.id)
        try{
            dicta.delete(flush: true)
            render "ok"
        }catch (e){
            render "no"
            println("error al desasignar una materia " + dicta.errors)
        }
    }

    def copiar_ajax () {
        def periodo = Periodo.get(params.periodo)
        def lista = Periodo.list() - periodo
        def profesor = Profesor.get(params.idProfe)

        return  [lista: lista, profesor: profesor, periodo: periodo]
    }

    def verificar_ajax () {
        def profesor = Profesor.get(params.profesor)
        def periodo = Periodo.get(params.periodo)

        def asignadas = Dictan.findAllByProfesorAndPeriodo(profesor, periodo)

        if(asignadas){
            render "no"
        }else{
            render "ok"
        }

    }

    def dialogoCopiar_ajax () {
        def periodoActual = Periodo.get(params.periodoActual)
        def periodoCopiar = Periodo.get(params.periodoCopiar)
        def profesor = Profesor.get(params.id)

        def lista = Dictan.findAllByProfesorAndPeriodo(profesor, periodoCopiar, [sort: 'materia.nombre', order: 'asc'] )


        return[actual: periodoActual, copiar: periodoCopiar, materias: lista]
    }


    def guardarCopia_ajax () {
        def periodoActual = Periodo.get(params.actual)
        def periodoCopiar = Periodo.get(params.copiar)
        def profesor = Profesor.get(params.idProfe)
        def errores = ''

        def lista = Dictan.findAllByProfesorAndPeriodo(profesor, periodoCopiar, [sort: 'materia.nombre', order: 'asc'] )
        def dicta
        lista.each { m->
            dicta = new Dictan()
            dicta.materia = m.materia
            dicta.profesor = profesor
            dicta.periodo = periodoActual
            dicta.curso = m.curso
            dicta.paralelo = m.paralelo

            try {
                dicta.save(flush: true)

            }catch (e){
                errores += dicta.errors
                println("error al copiar")
            }

        }

        if(errores == ''){
            render 'ok'
        }else{
            render "no"
        }
    }

}
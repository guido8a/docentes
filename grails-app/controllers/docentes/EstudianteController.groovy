package docentes

import org.springframework.dao.DataIntegrityViolationException
import seguridad.Shield


/**
 * Controlador que muestra las pantallas de manejo de Estudiante
 */
class EstudianteController extends Shield {

    def dbConnectionService

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
        params.sort = 'cedula'
        params.order = 'asc'
        if(all) {
            params.remove("max")
            params.remove("offset")
        }
        def list
        if(params.search) {
            def c = Estudiante.createCriteria()
            list = c.list(params) {
                or {
                    /* TODO: cambiar aqui segun sea necesario */

                    ilike("apellido", "%" + params.search + "%")
                    ilike("cedula", "%" + params.search + "%")
                    ilike("nombre", "%" + params.search + "%")
                }
            }
        } else {
            list = Estudiante.list(params)
        }
        if (!all && params.offset.toInteger() > 0 && list.size() == 0) {
            params.offset = params.offset.toInteger() - 1
            list = getList(params, all)
        }
        return list
    }

    def getList2(params, all, uni) {

        def universidad = Universidad.get(uni)

        params = params.clone()
//        params.max = params.max ? Math.min(params.max.toInteger(), 100) : 10
        params.max = 20
        params.offset = params.offset ?: 0
        params.sort = 'cedula'
        params.order = 'asc'
        if(all) {
            params.remove("max")
            params.remove("offset")
        }
        def list
        if(params.search) {

            def e = Matriculado.withCriteria{

                materiaDictada{
                    periodo{
                        eq("universidad", universidad)
                    }
                }
            }

            e.estudiante.asList()



//            def c = Estudiante.createCriteria()
//            list = c.list(params) {
//
//
//                or {
//                    /* TODO: cambiar aqui segun sea necesario */
//
//                    ilike("apellido", "%" + params.search + "%")
//                    ilike("cedula", "%" + params.search + "%")
//                    ilike("nombre", "%" + params.search + "%")
//                }
//            }
        } else {
            def e = Matriculado.withCriteria{

                materiaDictada{
                    periodo{
                        eq("universidad", universidad)
                    }
                }
            }

            list = e.estudiante.unique().asList(params)
        }
        if (!all && params.offset.toInteger() > 0 && list.size() == 0) {
            params.offset = params.offset.toInteger() - 1
            list = getList(params, all)
        }
        return list
    }

    /**
     * Acción que muestra la lista de elementos
     * @return estudianteInstanceList: la lista de elementos filtrados, estudianteInstanceCount: la cantidad total de elementos (sin máximo)
     */
    def list() {
//        params.max = 20
//
//        def estudianteInstanceList
//        def estudianteInstanceCount
//        def universidad
//
//        if(session.perfil.codigo == 'ADMG'){
//            estudianteInstanceList = getList(params, false)
//            estudianteInstanceCount = getList(params, true).size()
//        }else{
//            universidad = Universidad.get(seguridad.Persona.get(session.usuario.id)?.universidad?.id)
//            estudianteInstanceList = getList2(params, false, universidad.id)
//            estudianteInstanceCount = getList2(params, true, universidad.id).size()
//        }
//
//        return [estudianteInstanceList: estudianteInstanceList, estudianteInstanceCount: estudianteInstanceCount]
    }

    /**
     * Acción llamada con ajax que muestra la información de un elemento particular
     * @return estudianteInstance el objeto a mostrar cuando se encontró el elemento
     * @render ERROR*[mensaje] cuando no se encontró el elemento
     */
    def show_ajax() {
        if(params.id) {
            def estudianteInstance = Estudiante.get(params.id)
            if(!estudianteInstance) {
                render "ERROR*No se encontró Estudiante."
                return
            }
            return [estudianteInstance: estudianteInstance]
        } else {
            render "ERROR*No se encontró Estudiante."
        }
    } //show para cargar con ajax en un dialog

    /**
     * Acción llamada con ajax que muestra un formaulario para crear o modificar un elemento
     * @return estudianteInstance el objeto a modificar cuando se encontró el elemento
     * @render ERROR*[mensaje] cuando no se encontró el elemento
     */
    def form_ajax() {
        def estudianteInstance = new Estudiante()
        if(params.id) {
            estudianteInstance = Estudiante.get(params.id)
            if(!estudianteInstance) {
                render "ERROR*No se encontró Estudiante."
                return
            }
        }
        estudianteInstance.properties = params
        return [estudianteInstance: estudianteInstance]
    } //form para cargar con ajax en un dialog

    /**
     * Acción llamada con ajax que guarda la información de un elemento
     * @render ERROR*[mensaje] cuando no se pudo grabar correctamente, SUCCESS*[mensaje] cuando se grabó correctamente
     */
    def save_ajax() {
        def estudianteInstance = new Estudiante()
        if(params.id) {
            estudianteInstance = Estudiante.get(params.id)
            if(!estudianteInstance) {
                render "ERROR*No se encontró Estudiante."
                return
            }
        }
        estudianteInstance.properties = params
        estudianteInstance.nombre = params.nombre.toUpperCase()
        estudianteInstance.apellido = params.apellido.toUpperCase()

        if(!estudianteInstance.save(flush: true)) {
            render "ERROR*Ha ocurrido un error al guardar Estudiante: " + renderErrors(bean: estudianteInstance)
            return
        }
        render "OK*${params.id ? 'Actualización' : 'Creación'} de Estudiante exitosa."
        return
    } //save para grabar desde ajax

    /**
     * Acción llamada con ajax que permite eliminar un elemento
     * @render ERROR*[mensaje] cuando no se pudo eliminar correctamente, SUCCESS*[mensaje] cuando se eliminó correctamente
     */
    def delete_ajax() {
        if(params.id) {
            def estudianteInstance = Estudiante.get(params.id)
            if (!estudianteInstance) {
                render "ERROR*No se encontró Estudiante."
                return
            }
            try {
                estudianteInstance.delete(flush: true)
                render "SUCCESS*Eliminación de Estudiante exitosa."
                return
            } catch (DataIntegrityViolationException e) {
                render "ERROR*Ha ocurrido un error al eliminar Estudiante"
                return
            }
        } else {
            render "ERROR*No se encontró Estudiante."
            return
        }
    } //delete para eliminar via ajax


    def estudiante () {

//        println("estud " + params)
        def estudiante
        if(params.id){
            estudiante = Estudiante.get(params.id)
        }

        return [estudianteInstance: estudiante]
    }

    def saveEstudiante_ajax () {

        println("save est " + params)

        def existe = Estudiante.findByCedula(params.cedula)
        def band = true

        def estudiante
        if(params.id){
            estudiante = Estudiante.get(params.id)
            if(params.cedula == estudiante.cedula){
                band = true
            }else{
                if(existe){
                    band = false
                }else{
                    band = true
                }
            }
        }else{
            estudiante = new Estudiante()
            if(existe){
                band = false
            }
        }

        if(band){
            estudiante.nombre = params.nombre.toUpperCase()
            estudiante.apellido = params.apellido.toUpperCase()
            estudiante.cedula = params.cedula

            try {
                estudiante.save(flush: true)
                render 'ok_'+ "Información guardada correctamente_" + estudiante?.id
            }catch (e){
                render 'no_Error al guardar el estudiante'
                println("error al guardar el profesor " + estudiante.errors)
            }

        }else{
            render "no_El número de cédula ingresado ya se encuentra asignado a un alumno"
        }
    }

    def materias_ajax () {

        def estudiante = Estudiante.get(params.estudiante)
        def escuela = Escuela.get(params.escuela)
        def periodo = Periodo.get(params.periodo)

        def materias = Dictan.withCriteria {
            eq("escuela",escuela)
            eq("periodo",periodo)
        }

        def profesores = materias.profesor

        return [estudiante:estudiante, profesores: profesores.sort{it.apellido}, escuela: escuela]
    }

    def borrarMateriaMatriculada_ajax () {
        def matriculado = Matriculado.get(params.id)
        try{
            matriculado.delete(flush:true)
            render "ok"
        }catch (e){
            render "no"
            println ("error al borrar la materia matriculada " + matriculado.errors)
        }

    }

    def asignarMateria_ajax () {
        println("entro asignar materia " + params)
        def estudiante = Estudiante.get(params.estudiante)
        def dicta = Dictan.get(params.id)
//        def mat = Matriculado.findAllByEstudianteAndMateriaDictada(estudiante, dicta)
        def mat  = Matriculado.withCriteria {
            eq("estudiante",estudiante)
            materiaDictada {
                eq("materia", dicta.materia)
            }
        }

        def nueva

        if(mat){
            render "no_No se pudo asignar la materia. </br> Esta materia ya se encuentra asignada al estudiante"
        }else{
            nueva = new Matriculado()
            nueva.estudiante = estudiante
            nueva.materiaDictada = dicta
            try {
                nueva.save(flush: true)
                render "ok_Materia asignada correctamente"
            }catch (e){
                render "no_Error al asignar la materia"
                println("errro al asignar materia " + nueva.errors)
            }
        }

    }

    def tablaEstudiantes_ajax() {

        def estudiantes
        def universidad

        universidad = Universidad.get(params.universidad)

        estudiantes = Estudiante.withCriteria {

            and{
                ilike("apellido", "%" + params.apellido + "%")
                ilike("cedula", "" + params.cedula + "%")
                ilike("nombre", "%" + params.nombre + "%")
            }

            order("apellido","asc")
            maxResults(20)

        }

        return[estudiantes: estudiantes, universidad: universidad]
    }

    def periodo_ajax() {

        def universidad = Universidad.get(params.universidad)
        def periodos = Periodo.findAllByUniversidad(universidad)

        return [periodos: periodos]
    }

    def facultad_ajax() {

        def universidad = Universidad.get(params.universidad)
        def facultades = Facultad.findAllByUniversidad(universidad, [sort: 'nombre', order: 'asc'])

        return [facultades: facultades, universidad: universidad]
    }

    def escuelas_ajax() {

        def facultad = Facultad.get(params.facultad)
        def escuelas = Escuela.findAllByFacultad(facultad, [sort: 'nombre', order: 'asc'])

        return [escuelas: escuelas]
    }

    def tablaMateriasDicta_ajax () {

//        println("params tdicta " + params)

        def universidadE = Universidad.get(params.universidad)
        def escuelaE = Escuela.get(params.escuela)
        def periodoE = Periodo.get(params.periodo)
        def estudiante = Estudiante.get(params.estudiante)
        def profesorDic

        if(params.profesor != '-1'){
            profesorDic = Profesor.get(params.profesor)
        }

        def materiasMatriculadas = Matriculado.withCriteria {

            eq("estudiante",estudiante)
            materiaDictada{
                eq("periodo",periodoE)
            }
        }

        def materias = Dictan.withCriteria {

            eq("escuela",escuelaE)
            eq("periodo",periodoE)

            escuela{
                facultad{
                    eq("universidad",universidadE)
                }
            }

            and{
                materia{
                    ilike("codigo", "%" + params.codigo + "%")
                    ilike("nombre", "%" + params.materia + "%")
                }

                if(params.profesor != '-1'){
                    eq("profesor",profesorDic)
                }

            }

            order("materia","asc")
        }

        def filtradas = materias - materiasMatriculadas.materiaDictada

        return [materias: filtradas]
    }


    def saveAsignarMateria_ajax () {
//        println("params " + params)

        def dicta = Dictan.get(params.dicta)
        def curso = Curso.get(params.curso)
        def estudiante = Estudiante.get(params.estudiante)
        def matricula


        if(params.id){
            matricula = Matriculado.get(params.id)
        }else{
            matricula = new Matriculado()
        }

        matricula.estudiante = estudiante
        matricula.curso = curso
        matricula.materiaDictada = dicta

        try{
            matricula.save(flush: true)
            render "ok"
        }catch (e){
            println("error al agregar la materia al alumno " + e + "_ "+ matricula.errors)
            render "no"
        }
    }


}

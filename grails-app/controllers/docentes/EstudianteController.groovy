package docentes

import org.springframework.dao.DataIntegrityViolationException
import seguridad.Shield


/**
 * Controlador que muestra las pantallas de manejo de Estudiante
 */
class EstudianteController extends Shield {

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

    /**
     * Acción que muestra la lista de elementos
     * @return estudianteInstanceList: la lista de elementos filtrados, estudianteInstanceCount: la cantidad total de elementos (sin máximo)
     */
    def list() {
        params.max = 20
        def estudianteInstanceList = getList(params, false)
        def estudianteInstanceCount = getList(params, true).size()
        return [estudianteInstanceList: estudianteInstanceList, estudianteInstanceCount: estudianteInstanceCount]
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
        def estudiante
        if(params.id){
            estudiante = Estudiante.get(params.id)
        }
        return [estudianteInstance: estudiante]
    }

    def saveEstudiante_ajax () {

        def estudiante
        if(params.id){
            estudiante = Estudiante.get(params.id)
            estudiante.nombre = params.nombre.toUpperCase()
            estudiante.apellido = params.apellido.toUpperCase()
            estudiante.cedula = params.cedula
        }else{
            estudiante = new Estudiante()
            estudiante.nombre = params.nombre.toUpperCase()
            estudiante.apellido = params.apellido.toUpperCase()
            estudiante.cedula = params.cedula
        }

        try {
            estudiante.save(flush: true)
            render 'ok_'+ estudiante?.id
        }catch (e){
            render 'no'
            println("error al guardar el profesor " + estudiante.errors)
        }
    }


    def materias_ajax () {
        def periodo = Periodo.get(params.periodo)
        def dicta = Dictan.findAllByPeriodo(periodo, [sort: 'materia.nombre', order: 'asc'])
        def estudiante = Estudiante.get(params.id)

        return [dicta: dicta, periodo: periodo, estudiante:estudiante]
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



    
}

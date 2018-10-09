package docentes

import org.springframework.dao.DataIntegrityViolationException
import seguridad.Shield


/**
 * Controlador que muestra las pantallas de manejo de Materia
 */
class MateriaController extends Shield {

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
        params.sort = 'codigo'
        params.order = 'asc'
        if(all) {
            params.remove("max")
            params.remove("offset")
        }
        def list
        if(params.search) {
            def c = Materia.createCriteria()
            list = c.list(params) {
                or {
                    /* TODO: cambiar aqui segun sea necesario */

                    ilike("codigo", "%" + params.search + "%")
                    ilike("nombre", "%" + params.search + "%")
                }
            }
        } else {
            list = Materia.list(params)
        }
        if (!all && params.offset.toInteger() > 0 && list.size() == 0) {
            params.offset = params.offset.toInteger() - 1
            list = getList(params, all)
        }
        return list
    }

    /**
     * Acción que muestra la lista de elementos
     * @return materiaInstanceList: la lista de elementos filtrados, materiaInstanceCount: la cantidad total de elementos (sin máximo)
     */
    def list() {
        def materiaInstanceList = getList(params, false)
        def materiaInstanceCount = getList(params, true).size()
        return [materiaInstanceList: materiaInstanceList, materiaInstanceCount: materiaInstanceCount]
    }

    /**
     * Acción llamada con ajax que muestra la información de un elemento particular
     * @return materiaInstance el objeto a mostrar cuando se encontró el elemento
     * @render ERROR*[mensaje] cuando no se encontró el elemento
     */
    def show_ajax() {
        if(params.id) {
            def materiaInstance = Materia.get(params.id)
            if(!materiaInstance) {
                render "ERROR*No se encontró Materia."
                return
            }
            return [materiaInstance: materiaInstance]
        } else {
            render "ERROR*No se encontró Materia."
        }
    } //show para cargar con ajax en un dialog

    /**
     * Acción llamada con ajax que muestra un formaulario para crear o modificar un elemento
     * @return materiaInstance el objeto a modificar cuando se encontró el elemento
     * @render ERROR*[mensaje] cuando no se encontró el elemento
     */
    def form_ajax() {

        println("params form"  + params)

        if(params.escuela){
            def escuela = Escuela.get(params.id)

            def materiaInstance = new Materia()
            if(params.id) {
                materiaInstance = Materia.get(params.id)
                if(!materiaInstance) {
                    render "ERROR*No se encontró Materia."
                    return
                }
            }
            materiaInstance.properties = params
            return [materiaInstance: materiaInstance, escuela: escuela]
        }else{

        }


    } //form para cargar con ajax en un dialog

    /**
     * Acción llamada con ajax que guarda la información de un elemento
     * @render ERROR*[mensaje] cuando no se pudo grabar correctamente, SUCCESS*[mensaje] cuando se grabó correctamente
     */
    def save_ajax() {
        def materiaInstance = new Materia()
        if(params.id) {
            materiaInstance = Materia.get(params.id)
            if(!materiaInstance) {
                render "ERROR*No se encontró Materia."
                return
            }
        }
        materiaInstance.properties = params
        materiaInstance.nombre = params.nombre.toUpperCase()
        if(!materiaInstance.save(flush: true)) {
            render "ERROR*Ha ocurrido un error al guardar Materia: " + renderErrors(bean: materiaInstance)
            return
        }
        render "SUCCESS*${params.id ? 'Actualización' : 'Creación'} de Materia exitosa."
        return
    } //save para grabar desde ajax

    /**
     * Acción llamada con ajax que permite eliminar un elemento
     * @render ERROR*[mensaje] cuando no se pudo eliminar correctamente, SUCCESS*[mensaje] cuando se eliminó correctamente
     */
    def delete_ajax() {
        if(params.id) {
            def materiaInstance = Materia.get(params.id)
            if (!materiaInstance) {
                render "ERROR*No se encontró Materia."
                return
            }
            try {
                materiaInstance.delete(flush: true)
                render "SUCCESS*Eliminación de Materia exitosa."
                return
            } catch (DataIntegrityViolationException e) {
                render "ERROR*Ha ocurrido un error al eliminar Materia"
                return
            }
        } else {
            render "ERROR*No se encontró Materia."
            return
        }
    } //delete para eliminar via ajax

    /**
     * Acción llamada con ajax que valida que no se duplique la propiedad codigo
     * @render boolean que indica si se puede o no utilizar el valor recibido
     */
    def validar_unique_codigo_ajax() {
        params.codigo = params.codigo.toString().trim()
        if (params.id) {
            def obj = Materia.get(params.id)
            if (obj.codigo.toLowerCase() == params.codigo.toLowerCase()) {
                render true
                return
            } else {
                render Materia.countByCodigoIlike(params.codigo) == 0
                return
            }
        } else {
            render Materia.countByCodigoIlike(params.codigo) == 0
            return
        }
    }


    def escuela_ajax () {
//        println("params " + params)
        def facultad
        def escuelas

        if(params.id){
            facultad = Facultad.get(params.id)
            escuelas = Escuela.findAllByFacultad(facultad)
        }else{
            escuelas = null
        }

        return [escuelas: escuelas]
    }

    def tablaMaterias_ajax () {
        def escuela
        def materias
        if(params.id){
            escuela = Escuela.get(params.id)
            materias = Materia.findAllByEscuela(escuela, [sort: 'nombre'])
        }else{
            materias = null
        }

        return [materias: materias]
    }

    def buscarMateria_ajax () {
        def periodo = Periodo.get(params.periodo)
        def estudiante = Estudiante.get(params.id)
        return [periodo: periodo, estudiante: estudiante]
    }

    def tablaBusqueda_ajax () {

        def periodo = Periodo.get(params.periodo)
        def estudiante = Estudiante.get(params.id)
        def codigo = params.codigo.toString().trim()
        def nombreMateria = params.materia.toString().trim()

        def matriculadas = Matriculado.withCriteria {

            eq("estudiante", estudiante)

            materiaDictada{
                eq("periodo", periodo)
            }

        }


        def dicta = Dictan.withCriteria {

            eq("periodo",periodo)

            materia{
                ilike("codigo","%$codigo%")
                ilike("nombre","%$nombreMateria%")

                order("nombre","asc")
            }

            maxResults (30)
        }

        def filtrados = dicta - matriculadas.materiaDictada


        return [materias: filtrados, estudiante: estudiante]

    }

    def tablaMateriasAsignadas_ajax () {
        def estudiante = Estudiante.get(params.id)
        def periodo = Periodo.get(params.periodo)

        def matriculados = Matriculado.withCriteria {

            eq("estudiante",estudiante)

            materiaDictada {
                eq('periodo',periodo)
            }

        }

        return [materias: matriculados]

    }


}

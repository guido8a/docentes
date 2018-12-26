package docentes

import org.springframework.dao.DataIntegrityViolationException
import seguridad.Shield


/**
 * Controlador que muestra las pantallas de manejo de Escuela
 */
class EscuelaController extends Shield {

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
            def c = Escuela.createCriteria()
            list = c.list(params) {
                or {
                    /* TODO: cambiar aqui segun sea necesario */
                    
                    ilike("codigo", "%" + params.search + "%")  
                    ilike("nombre", "%" + params.search + "%")  
                }
            }
        } else {
            list = Escuela.list(params)
        }
        if (!all && params.offset.toInteger() > 0 && list.size() == 0) {
            params.offset = params.offset.toInteger() - 1
            list = getList(params, all)
        }
        return list
    }

    /**
     * Acción que muestra la lista de elementos
     * @return escuelaInstanceList: la lista de elementos filtrados, escuelaInstanceCount: la cantidad total de elementos (sin máximo)
     */
    def list() {
        def escuelaInstanceList = getList(params, false)
        def escuelaInstanceCount = getList(params, true).size()
        return [escuelaInstanceList: escuelaInstanceList, escuelaInstanceCount: escuelaInstanceCount]
    }

    /**
     * Acción llamada con ajax que muestra la información de un elemento particular
     * @return escuelaInstance el objeto a mostrar cuando se encontró el elemento
     * @render ERROR*[mensaje] cuando no se encontró el elemento
     */
    def show_ajax() {
        if(params.id) {
            def escuelaInstance = Escuela.get(params.id)
            if(!escuelaInstance) {
                render "ERROR*No se encontró Escuela."
                return
            }
            return [escuelaInstance: escuelaInstance]
        } else {
            render "ERROR*No se encontró Escuela."
        }
    } //show para cargar con ajax en un dialog

    /**
     * Acción llamada con ajax que muestra un formaulario para crear o modificar un elemento
     * @return escuelaInstance el objeto a modificar cuando se encontró el elemento
     * @render ERROR*[mensaje] cuando no se encontró el elemento
     */
    def form_ajax() {
        def escuelaInstance = new Escuela()
        if(params.id) {
            escuelaInstance = Escuela.get(params.id)
            if(!escuelaInstance) {
                render "ERROR*No se encontró Escuela."
                return
            }
        }
        escuelaInstance.properties = params
        return [escuelaInstance: escuelaInstance]
    } //form para cargar con ajax en un dialog


    def validar_codigoEscuela_ajax () {

        println("params " + params)

        def codigoIngresado = params.codigo.toString()
        def listaCodigos = Escuela.list().codigo
        def res
        if (params.id){
            def codigoActual = Escuela.get(params.id).codigo
            listaCodigos = listaCodigos - codigoActual
            res = !listaCodigos.contains(codigoIngresado)
            render res
            return

        }else{
            res = !listaCodigos.contains(codigoIngresado)
            render res
            return
        }



    }



    /**
     * Acción llamada con ajax que guarda la información de un elemento
     * @render ERROR*[mensaje] cuando no se pudo grabar correctamente, SUCCESS*[mensaje] cuando se grabó correctamente
     */
    def save_ajax() {
        def escuelaInstance = new Escuela()
        if(params.id) {
            escuelaInstance = Escuela.get(params.id)
            if(!escuelaInstance) {
                render "ERROR*No se encontró Escuela."
                return
            }
        }
        escuelaInstance.properties = params
        escuelaInstance.nombre = params.nombre
        if(!escuelaInstance.save(flush: true)) {
            render "ERROR*Ha ocurrido un error al guardar Escuela: " + renderErrors(bean: escuelaInstance)
            return
        }
        render "SUCCESS*${params.id ? 'Actualización' : 'Creación'} de Escuela exitosa."
        return
    } //save para grabar desde ajax

    /**
     * Acción llamada con ajax que permite eliminar un elemento
     * @render ERROR*[mensaje] cuando no se pudo eliminar correctamente, SUCCESS*[mensaje] cuando se eliminó correctamente
     */
    def delete_ajax() {
        if(params.id) {
            def escuelaInstance = Escuela.get(params.id)
            if (!escuelaInstance) {
                render "ERROR*No se encontró Escuela."
                return
            }
            try {
                escuelaInstance.delete(flush: true)
                render "SUCCESS*Eliminación de Escuela exitosa."
                return
            } catch (DataIntegrityViolationException e) {
                render "ERROR*Ha ocurrido un error al eliminar Escuela"
                return
            }
        } else {
            render "ERROR*No se encontró Escuela."
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
            def obj = Escuela.get(params.id)
            if (obj.codigo.toLowerCase() == params.codigo.toLowerCase()) {
                render true
                return
            } else {
                render Escuela.countByCodigoIlike(params.codigo) == 0
                return
            }
        } else {
            render Escuela.countByCodigoIlike(params.codigo) == 0
            return
        }
    }


    def tablaEscuela_ajax() {
        println("params " + params)
        def facultad
        def escuelas
        if(params.id){
            facultad = Facultad.get(params.id)
            escuelas = Escuela.findAllByFacultad(facultad, [sort: 'nombre', order: 'asc'])
        }else{
            escuelas = null
        }

        return [escuelas:escuelas]

    }
        
}

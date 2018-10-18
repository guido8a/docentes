package docentes

import org.springframework.dao.DataIntegrityViolationException
import seguridad.Shield


/**
 * Controlador que muestra las pantallas de manejo de Carrera
 */
class CarreraController extends Shield {

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
            def c = Carrera.createCriteria()
            list = c.list(params) {
                or {
                    /* TODO: cambiar aqui segun sea necesario */
                    
                    ilike("descripcion", "%" + params.search + "%")  
                }
            }
        } else {
            list = Carrera.list(params)
        }
        if (!all && params.offset.toInteger() > 0 && list.size() == 0) {
            params.offset = params.offset.toInteger() - 1
            list = getList(params, all)
        }
        return list
    }

    /**
     * Acción que muestra la lista de elementos
     * @return carreraInstanceList: la lista de elementos filtrados, carreraInstanceCount: la cantidad total de elementos (sin máximo)
     */
    def list() {
        def carreraInstanceList = getList(params, false)
        def carreraInstanceCount = getList(params, true).size()
        return [carreraInstanceList: carreraInstanceList, carreraInstanceCount: carreraInstanceCount]
    }

    /**
     * Acción llamada con ajax que muestra la información de un elemento particular
     * @return carreraInstance el objeto a mostrar cuando se encontró el elemento
     * @render ERROR*[mensaje] cuando no se encontró el elemento
     */
    def show_ajax() {
        if(params.id) {
            def carreraInstance = Carrera.get(params.id)
            if(!carreraInstance) {
                render "ERROR*No se encontró Carrera."
                return
            }
            return [carreraInstance: carreraInstance]
        } else {
            render "ERROR*No se encontró Carrera."
        }
    } //show para cargar con ajax en un dialog

    /**
     * Acción llamada con ajax que muestra un formaulario para crear o modificar un elemento
     * @return carreraInstance el objeto a modificar cuando se encontró el elemento
     * @render ERROR*[mensaje] cuando no se encontró el elemento
     */
    def form_ajax() {
        println("params " + params)
        def carreraInstance = new Carrera()
        if(params.id) {
            carreraInstance = Carrera.get(params.id)
            if(!carreraInstance) {
                render "ERROR*No se encontró Carrera."
                return
            }
        }
        carreraInstance.properties = params
        return [carreraInstance: carreraInstance]
    } //form para cargar con ajax en un dialog

    /**
     * Acción llamada con ajax que guarda la información de un elemento
     * @render ERROR*[mensaje] cuando no se pudo grabar correctamente, SUCCESS*[mensaje] cuando se grabó correctamente
     */
    def save_ajax() {
        def carreraInstance = new Carrera()
        if(params.id) {
            carreraInstance = Carrera.get(params.id)
            if(!carreraInstance) {
                render "no"
                return
            }
        }
        carreraInstance.properties = params
        if(!carreraInstance.save(flush: true)) {
            render "no"
            return
        }
        render "ok"
    } //save para grabar desde ajax

    /**
     * Acción llamada con ajax que permite eliminar un elemento
     * @render ERROR*[mensaje] cuando no se pudo eliminar correctamente, SUCCESS*[mensaje] cuando se eliminó correctamente
     */
    def delete_ajax() {
        if(params.id) {
            def carreraInstance = Carrera.get(params.id)
            if (!carreraInstance) {
                render "no"
                return
            }
            try {
                carreraInstance.delete(flush: true)
                render "ok"
                return
            } catch (DataIntegrityViolationException e) {
                render "no"
                return
            }
        } else {
            render "no"
            return
        }
    } //delete para eliminar via ajax
    
}

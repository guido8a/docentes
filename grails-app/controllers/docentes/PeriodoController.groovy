package docentes

import org.springframework.dao.DataIntegrityViolationException
import seguridad.Shield


/**
 * Controlador que muestra las pantallas de manejo de Periodo
 */
class PeriodoController extends Shield {

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
            def c = Periodo.createCriteria()
            list = c.list(params) {
                or {
                    /* TODO: cambiar aqui segun sea necesario */
                    
                    ilike("nombre", "%" + params.search + "%")  
                }
            }
        } else {
            list = Periodo.list(params)
        }
        if (!all && params.offset.toInteger() > 0 && list.size() == 0) {
            params.offset = params.offset.toInteger() - 1
            list = getList(params, all)
        }
        return list
    }

    /**
     * Acción que muestra la lista de elementos
     * @return periodoInstanceList: la lista de elementos filtrados, periodoInstanceCount: la cantidad total de elementos (sin máximo)
     */
    def list() {
        def periodoInstanceList = getList(params, false)
        def periodoInstanceCount = getList(params, true).size()
        return [periodoInstanceList: periodoInstanceList, periodoInstanceCount: periodoInstanceCount]
    }

    /**
     * Acción llamada con ajax que muestra la información de un elemento particular
     * @return periodoInstance el objeto a mostrar cuando se encontró el elemento
     * @render ERROR*[mensaje] cuando no se encontró el elemento
     */
    def show_ajax() {
        if(params.id) {
            def periodoInstance = Periodo.get(params.id)
            if(!periodoInstance) {
                render "ERROR*No se encontró Periodo."
                return
            }
            return [periodoInstance: periodoInstance]
        } else {
            render "ERROR*No se encontró Periodo."
        }
    } //show para cargar con ajax en un dialog

    /**
     * Acción llamada con ajax que muestra un formaulario para crear o modificar un elemento
     * @return periodoInstance el objeto a modificar cuando se encontró el elemento
     * @render ERROR*[mensaje] cuando no se encontró el elemento
     */
    def form_ajax() {
        def periodoInstance = new Periodo()
        if(params.id) {
            periodoInstance = Periodo.get(params.id)
            if(!periodoInstance) {
                render "ERROR*No se encontró Periodo."
                return
            }
        }
        periodoInstance.properties = params
        return [periodoInstance: periodoInstance]
    } //form para cargar con ajax en un dialog

    /**
     * Acción llamada con ajax que guarda la información de un elemento
     * @render ERROR*[mensaje] cuando no se pudo grabar correctamente, SUCCESS*[mensaje] cuando se grabó correctamente
     */
    def save_ajax() {
        def periodoInstance = new Periodo()
        if(params.id) {
            periodoInstance = Periodo.get(params.id)
            if(!periodoInstance) {
                render "no"
                return
            }
        }
        periodoInstance.properties = params
        if(!periodoInstance.save(flush: true)) {
            render "no" + renderErrors(bean: periodoInstance)
            return
        }
        render "ok"
        return
    } //save para grabar desde ajax

    /**
     * Acción llamada con ajax que permite eliminar un elemento
     * @render ERROR*[mensaje] cuando no se pudo eliminar correctamente, SUCCESS*[mensaje] cuando se eliminó correctamente
     */
    def delete_ajax() {
        if(params.id) {
            def periodoInstance = Periodo.get(params.id)
            if (!periodoInstance) {
                render "ERROR*No se encontró Periodo."
                return
            }
            try {
                periodoInstance.delete(flush: true)
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

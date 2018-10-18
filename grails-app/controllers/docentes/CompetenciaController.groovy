package docentes

import org.springframework.dao.DataIntegrityViolationException
import seguridad.Shield


/**
 * Controlador que muestra las pantallas de manejo de Competencia
 */
class CompetenciaController extends Shield {

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
            def c = Competencia.createCriteria()
            list = c.list(params) {
                or {
                    /* TODO: cambiar aqui segun sea necesario */
                    
                    ilike("descripcion", "%" + params.search + "%")  
                }
            }
        } else {
            list = Competencia.list(params)
        }
        if (!all && params.offset.toInteger() > 0 && list.size() == 0) {
            params.offset = params.offset.toInteger() - 1
            list = getList(params, all)
        }
        return list
    }

    /**
     * Acción que muestra la lista de elementos
     * @return competenciaInstanceList: la lista de elementos filtrados, competenciaInstanceCount: la cantidad total de elementos (sin máximo)
     */
    def list() {
        def competenciaInstanceList = getList(params, false)
        def competenciaInstanceCount = getList(params, true).size()
        return [competenciaInstanceList: competenciaInstanceList, competenciaInstanceCount: competenciaInstanceCount]
    }

    /**
     * Acción llamada con ajax que muestra la información de un elemento particular
     * @return competenciaInstance el objeto a mostrar cuando se encontró el elemento
     * @render ERROR*[mensaje] cuando no se encontró el elemento
     */
    def show_ajax() {
        if(params.id) {
            def competenciaInstance = Competencia.get(params.id)
            if(!competenciaInstance) {
                render "ERROR*No se encontró Competencia."
                return
            }
            return [competenciaInstance: competenciaInstance]
        } else {
            render "ERROR*No se encontró Competencia."
        }
    } //show para cargar con ajax en un dialog

    /**
     * Acción llamada con ajax que muestra un formaulario para crear o modificar un elemento
     * @return competenciaInstance el objeto a modificar cuando se encontró el elemento
     * @render ERROR*[mensaje] cuando no se encontró el elemento
     */
    def form_ajax() {
        def competenciaInstance = new Competencia()
        if(params.id) {
            competenciaInstance = Competencia.get(params.id)
            if(!competenciaInstance) {
                render "ERROR*No se encontró Competencia."
                return
            }
        }
        competenciaInstance.properties = params
        return [competenciaInstance: competenciaInstance]
    } //form para cargar con ajax en un dialog

    /**
     * Acción llamada con ajax que guarda la información de un elemento
     * @render ERROR*[mensaje] cuando no se pudo grabar correctamente, SUCCESS*[mensaje] cuando se grabó correctamente
     */
    def save_ajax() {
        def competenciaInstance = new Competencia()
        if(params.id) {
            competenciaInstance = Competencia.get(params.id)
            if(!competenciaInstance) {
                render "no"
                return
            }
        }
        competenciaInstance.properties = params
        if(!competenciaInstance.save(flush: true)) {
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
            def competenciaInstance = Competencia.get(params.id)
            if (!competenciaInstance) {
                render "no"
                return
            }
            try {
                competenciaInstance.delete(flush: true)
                render "ok"
                return
            } catch (DataIntegrityViolationException e) {
                render "no"
                return
            }
        } else {
            render "no"
        }
    } //delete para eliminar via ajax
    
}

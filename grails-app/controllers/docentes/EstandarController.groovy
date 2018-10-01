package docentes

import org.springframework.dao.DataIntegrityViolationException
import seguridad.Shield


/**
 * Controlador que muestra las pantallas de manejo de Estandar
 */
class EstandarController extends Shield {

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
            def c = Estandar.createCriteria()
            list = c.list(params) {
                or {
                    /* TODO: cambiar aqui segun sea necesario */
                    
                    ilike("codigo", "%" + params.search + "%")  
                    ilike("descripcion", "%" + params.search + "%")  
                }
            }
        } else {
            list = Estandar.list(params)
        }
        if (!all && params.offset.toInteger() > 0 && list.size() == 0) {
            params.offset = params.offset.toInteger() - 1
            list = getList(params, all)
        }
        return list
    }

    /**
     * Acción que muestra la lista de elementos
     * @return estandarInstanceList: la lista de elementos filtrados, estandarInstanceCount: la cantidad total de elementos (sin máximo)
     */
    def list() {
//        def estandarInstanceList = getList(params, false).sort{it.codigo}
        params.sort = 'codigo'
        def estandarInstanceList = Estandar.list(params)
        def estandarInstanceCount = getList(params, true).size()
        println "${estandarInstanceList.codigo}"
        return [estandarInstanceList: estandarInstanceList, estandarInstanceCount: estandarInstanceCount]
    }

    /**
     * Acción llamada con ajax que muestra la información de un elemento particular
     * @return estandarInstance el objeto a mostrar cuando se encontró el elemento
     * @render ERROR*[mensaje] cuando no se encontró el elemento
     */
    def show_ajax() {
        if(params.id) {
            def estandarInstance = Estandar.get(params.id)
            if(!estandarInstance) {
                render "ERROR*No se encontró Estandar."
                return
            }
            return [estandarInstance: estandarInstance]
        } else {
            render "ERROR*No se encontró Estandar."
        }
    } //show para cargar con ajax en un dialog

    /**
     * Acción llamada con ajax que muestra un formaulario para crear o modificar un elemento
     * @return estandarInstance el objeto a modificar cuando se encontró el elemento
     * @render ERROR*[mensaje] cuando no se encontró el elemento
     */
    def form_ajax() {
        def estandarInstance = new Estandar()
        if(params.id) {
            estandarInstance = Estandar.get(params.id)
            if(!estandarInstance) {
                render "ERROR*No se encontró Estandar."
                return
            }
        }
        estandarInstance.properties = params
        return [estandarInstance: estandarInstance]
    } //form para cargar con ajax en un dialog

    /**
     * Acción llamada con ajax que guarda la información de un elemento
     * @render ERROR*[mensaje] cuando no se pudo grabar correctamente, SUCCESS*[mensaje] cuando se grabó correctamente
     */
    def save_ajax() {
        def estandarInstance = new Estandar()
        if(params.id) {
            estandarInstance = Estandar.get(params.id)
            if(!estandarInstance) {
                render "no"
            }
        }
        estandarInstance.properties = params
        if(!estandarInstance.save(flush: true)) {
            render "no"
        }
        render "ok"
    } //save para grabar desde ajax

    /**
     * Acción llamada con ajax que permite eliminar un elemento
     * @render ERROR*[mensaje] cuando no se pudo eliminar correctamente, SUCCESS*[mensaje] cuando se eliminó correctamente
     */
    def delete_ajax() {
        if(params.id) {
            def estandarInstance = Estandar.get(params.id)
            if (!estandarInstance) {
                render "ERROR*No se encontró Estandar."
                return
            }
            try {
                estandarInstance.delete(flush: true)
                render "ok"

            } catch (DataIntegrityViolationException e) {
                render "no"
            }
        } else {
            render "no"
        }
    } //delete para eliminar via ajax
    
    /**
     * Acción llamada con ajax que valida que no se duplique la propiedad codigo
     * @render boolean que indica si se puede o no utilizar el valor recibido
     */
    def validar_unique_codigo_ajax() {
        params.codigo = params.codigo.toString().trim()
        if (params.id) {
            def obj = Estandar.get(params.id)
            if (obj.codigo.toLowerCase() == params.codigo.toLowerCase()) {
                render true
                return
            } else {
                render Estandar.countByCodigoIlike(params.codigo) == 0
                return
            }
        } else {
            render Estandar.countByCodigoIlike(params.codigo) == 0
            return
        }
    }
        
}

package docentes

import org.springframework.dao.DataIntegrityViolationException
import seguridad.Shield


/**
 * Controlador que muestra las pantallas de manejo de TipoEncuesta
 */
class TipoEncuestaController extends Shield {

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
            def c = TipoEncuesta.createCriteria()
            list = c.list(params) {
                or {
                    /* TODO: cambiar aqui segun sea necesario */
                    
                    ilike("codigo", "%" + params.search + "%")  
                    ilike("descripcion", "%" + params.search + "%")  
                    ilike("estado", "%" + params.search + "%")  
                }
            }
        } else {
            list = TipoEncuesta.list(params)
        }
        if (!all && params.offset.toInteger() > 0 && list.size() == 0) {
            params.offset = params.offset.toInteger() - 1
            list = getList(params, all)
        }
        return list
    }

    /**
     * Acción que muestra la lista de elementos
     * @return tipoEncuestaInstanceList: la lista de elementos filtrados, tipoEncuestaInstanceCount: la cantidad total de elementos (sin máximo)
     */
    def list() {
        def tipoEncuestaInstanceList = getList(params, false)
        def tipoEncuestaInstanceCount = getList(params, true).size()
        return [tipoEncuestaInstanceList: tipoEncuestaInstanceList, tipoEncuestaInstanceCount: tipoEncuestaInstanceCount]
    }

    /**
     * Acción llamada con ajax que muestra la información de un elemento particular
     * @return tipoEncuestaInstance el objeto a mostrar cuando se encontró el elemento
     * @render ERROR*[mensaje] cuando no se encontró el elemento
     */
    def show_ajax() {
        if(params.id) {
            def tipoEncuestaInstance = TipoEncuesta.get(params.id)
            if(!tipoEncuestaInstance) {
                render "ERROR*No se encontró TipoEncuesta."
                return
            }
            return [tipoEncuestaInstance: tipoEncuestaInstance]
        } else {
            render "ERROR*No se encontró TipoEncuesta."
        }
    } //show para cargar con ajax en un dialog

    /**
     * Acción llamada con ajax que muestra un formaulario para crear o modificar un elemento
     * @return tipoEncuestaInstance el objeto a modificar cuando se encontró el elemento
     * @render ERROR*[mensaje] cuando no se encontró el elemento
     */
    def form_ajax() {
        def tipoEncuestaInstance = new TipoEncuesta()
        if(params.id) {
            tipoEncuestaInstance = TipoEncuesta.get(params.id)
            if(!tipoEncuestaInstance) {
                render "ERROR*No se encontró TipoEncuesta."
                return
            }
        }
        tipoEncuestaInstance.properties = params
        return [tipoEncuestaInstance: tipoEncuestaInstance]
    } //form para cargar con ajax en un dialog

    /**
     * Acción llamada con ajax que guarda la información de un elemento
     * @render ERROR*[mensaje] cuando no se pudo grabar correctamente, SUCCESS*[mensaje] cuando se grabó correctamente
     */
    def save_ajax() {
        def tipoEncuestaInstance = new TipoEncuesta()
        if(params.id) {
            tipoEncuestaInstance = TipoEncuesta.get(params.id)
            if(!tipoEncuestaInstance) {
                render "ERROR*No se encontró TipoEncuesta."
                return
            }
        }
        tipoEncuestaInstance.properties = params
        tipoEncuestaInstance.descripcion = params.descripcion.toUpperCase()
        tipoEncuestaInstance.codigo = params.codigo.toUpperCase()
        if(!tipoEncuestaInstance.save(flush: true)) {
            render "ERROR*Ha ocurrido un error al guardar TipoEncuesta: " + renderErrors(bean: tipoEncuestaInstance)
            return
        }
        render "SUCCESS*${params.id ? 'Actualización' : 'Creación'} de TipoEncuesta exitosa."
        return
    } //save para grabar desde ajax

    /**
     * Acción llamada con ajax que permite eliminar un elemento
     * @render ERROR*[mensaje] cuando no se pudo eliminar correctamente, SUCCESS*[mensaje] cuando se eliminó correctamente
     */
    def delete_ajax() {
        if(params.id) {
            def tipoEncuestaInstance = TipoEncuesta.get(params.id)
            if (!tipoEncuestaInstance) {
                render "ERROR*No se encontró TipoEncuesta."
                return
            }
            try {
                tipoEncuestaInstance.delete(flush: true)
                render "SUCCESS*Eliminación de TipoEncuesta exitosa."
                return
            } catch (DataIntegrityViolationException e) {
                render "ERROR*Ha ocurrido un error al eliminar TipoEncuesta"
                return
            }
        } else {
            render "ERROR*No se encontró TipoEncuesta."
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
            def obj = TipoEncuesta.get(params.id)
            if (obj.codigo.toLowerCase() == params.codigo.toLowerCase()) {
                render true
                return
            } else {
                render TipoEncuesta.countByCodigoIlike(params.codigo) == 0
                return
            }
        } else {
            render TipoEncuesta.countByCodigoIlike(params.codigo) == 0
            return
        }
    }
        
}

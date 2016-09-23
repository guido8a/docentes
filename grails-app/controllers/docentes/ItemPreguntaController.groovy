package docentes

import org.springframework.dao.DataIntegrityViolationException
import seguridad.Shield


/**
 * Controlador que muestra las pantallas de manejo de ItemPregunta
 */
class ItemPreguntaController extends Shield {

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
            def c = ItemPregunta.createCriteria()
            list = c.list(params) {
                or {
                    /* TODO: cambiar aqui segun sea necesario */
                    
                    ilike("descripcion", "%" + params.search + "%")  
                    ilike("tipo", "%" + params.search + "%")  
                }
            }
        } else {
            list = ItemPregunta.list(params)
        }
        if (!all && params.offset.toInteger() > 0 && list.size() == 0) {
            params.offset = params.offset.toInteger() - 1
            list = getList(params, all)
        }
        return list
    }

    /**
     * Acción que muestra la lista de elementos
     * @return itemPreguntaInstanceList: la lista de elementos filtrados, itemPreguntaInstanceCount: la cantidad total de elementos (sin máximo)
     */
    def list() {
        def itemPreguntaInstanceList = getList(params, false)
        def itemPreguntaInstanceCount = getList(params, true).size()
        return [itemPreguntaInstanceList: itemPreguntaInstanceList, itemPreguntaInstanceCount: itemPreguntaInstanceCount]
    }

    /**
     * Acción llamada con ajax que muestra la información de un elemento particular
     * @return itemPreguntaInstance el objeto a mostrar cuando se encontró el elemento
     * @render ERROR*[mensaje] cuando no se encontró el elemento
     */
    def show_ajax() {
        if(params.id) {
            def itemPreguntaInstance = ItemPregunta.get(params.id)
            if(!itemPreguntaInstance) {
                render "ERROR*No se encontró ItemPregunta."
                return
            }
            return [itemPreguntaInstance: itemPreguntaInstance]
        } else {
            render "ERROR*No se encontró ItemPregunta."
        }
    } //show para cargar con ajax en un dialog

    /**
     * Acción llamada con ajax que muestra un formaulario para crear o modificar un elemento
     * @return itemPreguntaInstance el objeto a modificar cuando se encontró el elemento
     * @render ERROR*[mensaje] cuando no se encontró el elemento
     */
    def form_ajax() {
        def itemPreguntaInstance = new ItemPregunta()
        if(params.id) {
            itemPreguntaInstance = ItemPregunta.get(params.id)
            if(!itemPreguntaInstance) {
                render "ERROR*No se encontró ItemPregunta."
                return
            }
        }
        itemPreguntaInstance.properties = params
        return [itemPreguntaInstance: itemPreguntaInstance]
    } //form para cargar con ajax en un dialog

    /**
     * Acción llamada con ajax que guarda la información de un elemento
     * @render ERROR*[mensaje] cuando no se pudo grabar correctamente, SUCCESS*[mensaje] cuando se grabó correctamente
     */
    def save_ajax() {
        def itemPreguntaInstance = new ItemPregunta()
        if(params.id) {
            itemPreguntaInstance = ItemPregunta.get(params.id)
            if(!itemPreguntaInstance) {
                render "ERROR*No se encontró ItemPregunta."
                return
            }
        }
        itemPreguntaInstance.properties = params
        if(!itemPreguntaInstance.save(flush: true)) {
            render "ERROR*Ha ocurrido un error al guardar ItemPregunta: " + renderErrors(bean: itemPreguntaInstance)
            return
        }
        render "SUCCESS*${params.id ? 'Actualización' : 'Creación'} de ItemPregunta exitosa."
        return
    } //save para grabar desde ajax

    /**
     * Acción llamada con ajax que permite eliminar un elemento
     * @render ERROR*[mensaje] cuando no se pudo eliminar correctamente, SUCCESS*[mensaje] cuando se eliminó correctamente
     */
    def delete_ajax() {
        if(params.id) {
            def itemPreguntaInstance = ItemPregunta.get(params.id)
            if (!itemPreguntaInstance) {
                render "ERROR*No se encontró ItemPregunta."
                return
            }
            try {
                itemPreguntaInstance.delete(flush: true)
                render "SUCCESS*Eliminación de ItemPregunta exitosa."
                return
            } catch (DataIntegrityViolationException e) {
                render "ERROR*Ha ocurrido un error al eliminar ItemPregunta"
                return
            }
        } else {
            render "ERROR*No se encontró ItemPregunta."
            return
        }
    } //delete para eliminar via ajax
    
}

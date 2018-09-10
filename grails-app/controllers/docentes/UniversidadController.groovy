package docentes

import org.springframework.dao.DataIntegrityViolationException
import seguridad.Shield


/**
 * Controlador que muestra las pantallas de manejo de Universidad
 */
class UniversidadController extends Shield {

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
            def c = Universidad.createCriteria()
            list = c.list(params) {
                or {
                    /* TODO: cambiar aqui segun sea necesario */
                    
                    ilike("apellidoContacto", "%" + params.search + "%")  
                    ilike("logo", "%" + params.search + "%")  
                    ilike("nombre", "%" + params.search + "%")  
                    ilike("nombreContacto", "%" + params.search + "%")  
                }
            }
        } else {
            list = Universidad.list(params)
        }
        if (!all && params.offset.toInteger() > 0 && list.size() == 0) {
            params.offset = params.offset.toInteger() - 1
            list = getList(params, all)
        }
        return list
    }

    /**
     * Acción que muestra la lista de elementos
     * @return universidadInstanceList: la lista de elementos filtrados, universidadInstanceCount: la cantidad total de elementos (sin máximo)
     */
    def list() {
        def universidadInstanceList = getList(params, false)
        def universidadInstanceCount = getList(params, true).size()
        return [universidadInstanceList: universidadInstanceList, universidadInstanceCount: universidadInstanceCount]
    }

    /**
     * Acción llamada con ajax que muestra la información de un elemento particular
     * @return universidadInstance el objeto a mostrar cuando se encontró el elemento
     * @render ERROR*[mensaje] cuando no se encontró el elemento
     */
    def show_ajax() {
        if(params.id) {
            def universidadInstance = Universidad.get(params.id)
            if(!universidadInstance) {
                render "ERROR*No se encontró Universidad."
                return
            }
            return [universidadInstance: universidadInstance]
        } else {
            render "ERROR*No se encontró Universidad."
        }
    } //show para cargar con ajax en un dialog

    /**
     * Acción llamada con ajax que muestra un formaulario para crear o modificar un elemento
     * @return universidadInstance el objeto a modificar cuando se encontró el elemento
     * @render ERROR*[mensaje] cuando no se encontró el elemento
     */
    def form_ajax() {
        def universidadInstance = new Universidad()
        if(params.id) {
            universidadInstance = Universidad.get(params.id)
            if(!universidadInstance) {
                render "ERROR*No se encontró Universidad."
                return
            }
        }
        universidadInstance.properties = params
        return [universidadInstance: universidadInstance]
    } //form para cargar con ajax en un dialog

    /**
     * Acción llamada con ajax que guarda la información de un elemento
     * @render ERROR*[mensaje] cuando no se pudo grabar correctamente, SUCCESS*[mensaje] cuando se grabó correctamente
     */
    def save_ajax() {
        def universidadInstance

        if(params.id){
            universidadInstance = Universidad.get(params.id)
        }else{
            universidadInstance = new Universidad()
        }

        universidadInstance.properties = params

        try{
            universidadInstance.save(flush: true)
            render "ok"
        }catch (e){
            println("error al guardar la universidad " + e + universidadInstance.errors)
            render "no"
        }
    } //save para grabar desde ajax

    /**
     * Acción llamada con ajax que permite eliminar un elemento
     * @render ERROR*[mensaje] cuando no se pudo eliminar correctamente, SUCCESS*[mensaje] cuando se eliminó correctamente
     */
    def delete_ajax() {
        if(params.id) {
            def universidadInstance = Universidad.get(params.id)
            if (!universidadInstance) {
                render "ERROR*No se encontró Universidad."
                return
            }
            try {
                universidadInstance.delete(flush: true)
                render "SUCCESS*Eliminación de Universidad exitosa."
                return
            } catch (DataIntegrityViolationException e) {
                render "ERROR*Ha ocurrido un error al eliminar Universidad"
                return
            }
        } else {
            render "ERROR*No se encontró Universidad."
            return
        }
    } //delete para eliminar via ajax
    
}

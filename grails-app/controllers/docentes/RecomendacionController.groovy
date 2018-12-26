package docentes

import org.springframework.dao.DataIntegrityViolationException
import seguridad.Shield


/**
 * Controlador que muestra las pantallas de manejo de Recomendacion
 */
class RecomendacionController extends Shield {

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
            def c = Recomendacion.createCriteria()
            list = c.list(params) {
                or {
                    /* TODO: cambiar aqui segun sea necesario */
                    
                    ilike("descripcion", "%" + params.search + "%")  
                }
            }
        } else {
            list = Recomendacion.list(params)
        }
        if (!all && params.offset.toInteger() > 0 && list.size() == 0) {
            params.offset = params.offset.toInteger() - 1
            list = getList(params, all)
        }
        return list
    }

    /**
     * Acción que muestra la lista de elementos
     * @return recomendacionInstanceList: la lista de elementos filtrados, recomendacionInstanceCount: la cantidad total de elementos (sin máximo)
     */
    def list() {
        def recomendacionInstanceList = getList(params, false)
        def recomendacionInstanceCount = getList(params, true).size()
        return [recomendacionInstanceList: recomendacionInstanceList, recomendacionInstanceCount: recomendacionInstanceCount]
    }

    /**
     * Acción llamada con ajax que muestra la información de un elemento particular
     * @return recomendacionInstance el objeto a mostrar cuando se encontró el elemento
     * @render ERROR*[mensaje] cuando no se encontró el elemento
     */
    def show_ajax() {
        if(params.id) {
            def recomendacionInstance = Recomendacion.get(params.id)
            if(!recomendacionInstance) {
                render "ERROR*No se encontró Recomendacion."
                return
            }
            return [recomendacionInstance: recomendacionInstance]
        } else {
            render "ERROR*No se encontró Recomendacion."
        }
    } //show para cargar con ajax en un dialog

    /**
     * Acción llamada con ajax que muestra un formaulario para crear o modificar un elemento
     * @return recomendacionInstance el objeto a modificar cuando se encontró el elemento
     * @render ERROR*[mensaje] cuando no se encontró el elemento
     */
    def form_ajax() {
        def recomendacionInstance = new Recomendacion()
        if(params.id) {
            recomendacionInstance = Recomendacion.get(params.id)
            if(!recomendacionInstance) {
                render "ERROR*No se encontró Recomendacion."
                return
            }
        }
        recomendacionInstance.properties = params
        return [recomendacionInstance: recomendacionInstance]
    } //form para cargar con ajax en un dialog

    /**
     * Acción llamada con ajax que guarda la información de un elemento
     * @render ERROR*[mensaje] cuando no se pudo grabar correctamente, SUCCESS*[mensaje] cuando se grabó correctamente
     */
    def save_ajax() {

        def recomendacion
        def errores = ''
        def texto = ''

        if(params.id){
            recomendacion = Recomendacion.get(params.id)
            texto = 'Recomendación actualizada correctamente'
        }else{
            recomendacion = new Recomendacion()
            texto = "Recomedación creada correctamente"
        }

//        recomendacion.descripcion = params.descripcion.toUpperCase();
        recomendacion.descripcion = params.descripcion

        try{
            recomendacion.save(flush: true)
        }catch (e){
            errores += e
        }


        if(errores == ''){
            render "OK_" + texto
        }else{
            render "NO"
        }

    } //save para grabar desde ajax

    /**
     * Acción llamada con ajax que permite eliminar un elemento
     * @render ERROR*[mensaje] cuando no se pudo eliminar correctamente, SUCCESS*[mensaje] cuando se eliminó correctamente
     */
    def delete_ajax() {

        def recomendacionInstance = Recomendacion.get(params.id)

        try {
            recomendacionInstance.delete(flush: true)
            render "OK"
        } catch (DataIntegrityViolationException e) {
            render "NO"
        }


    } //delete para eliminar via ajax

    def recomendacion_ajax () {

        def pregunta = Pregunta.get(params.id)
        def rcpr = Rcpr.findByPregunta(pregunta)

        return [rcpr: rcpr, pregunta: pregunta]
    }
    
}

package docentes

import org.springframework.dao.DataIntegrityViolationException
import seguridad.Shield


/**
 * Controlador que muestra las pantallas de manejo de Variables
 */
class VariablesController extends Shield {

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
            def c = Variables.createCriteria()
            list = c.list(params) {
                or {
                    /* TODO: cambiar aqui segun sea necesario */
                    
                    ilike("codigo", "%" + params.search + "%")  
                    ilike("descripcion", "%" + params.search + "%")  
                }
            }
        } else {
            list = Variables.list(params)
        }
        if (!all && params.offset.toInteger() > 0 && list.size() == 0) {
            params.offset = params.offset.toInteger() - 1
            list = getList(params, all)
        }
        return list
    }

    /**
     * Acción que muestra la lista de elementos
     * @return variablesInstanceList: la lista de elementos filtrados, variablesInstanceCount: la cantidad total de elementos (sin máximo)
     */
    def list() {
        def variablesInstanceList = getList(params, false)
        def variablesInstanceCount = getList(params, true).size()
        return [variablesInstanceList: variablesInstanceList, variablesInstanceCount: variablesInstanceCount]
    }

    /**
     * Acción llamada con ajax que muestra la información de un elemento particular
     * @return variablesInstance el objeto a mostrar cuando se encontró el elemento
     * @render ERROR*[mensaje] cuando no se encontró el elemento
     */
    def show_ajax() {
        if(params.id) {
            def variablesInstance = Variables.get(params.id)
            if(!variablesInstance) {
                render "ERROR*No se encontró Variables."
                return
            }
            return [variablesInstance: variablesInstance]
        } else {
            render "ERROR*No se encontró Variables."
        }
    } //show para cargar con ajax en un dialog

    /**
     * Acción llamada con ajax que muestra un formaulario para crear o modificar un elemento
     * @return variablesInstance el objeto a modificar cuando se encontró el elemento
     * @render ERROR*[mensaje] cuando no se encontró el elemento
     */
    def form_ajax() {
        def variablesInstance = new Variables()
        if(params.id) {
            variablesInstance = Variables.get(params.id)
            if(!variablesInstance) {
                render "ERROR*No se encontró Variables."
                return
            }
        }
        variablesInstance.properties = params
        return [variablesInstance: variablesInstance]
    } //form para cargar con ajax en un dialog

    /**
     * Acción llamada con ajax que guarda la información de un elemento
     * @render ERROR*[mensaje] cuando no se pudo grabar correctamente, SUCCESS*[mensaje] cuando se grabó correctamente
     */
    def save_ajax() {

        def variables
        def errores = ''
        def texto = ''

        if(params.id){
            variables = Variables.get(params.id)
            texto = "Variable actualizada correctamente"
        }else{
            variables = new Variables()
            texto =  "Variable creada correctamente"
        }

        variables.codigo = params.codigo.toUpperCase()
        variables.descripcion = params.descripcion

        try{
            variables.save(flush:true)
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

            def variablesInstance = Variables.get(params.id)

            try {
                variablesInstance.delete(flush: true)
                render "OK"
            } catch (DataIntegrityViolationException e) {
                render "NO"
            }

    } //delete para eliminar via ajax
    
    /**
     * Acción llamada con ajax que valida que no se duplique la propiedad codigo
     * @render boolean que indica si se puede o no utilizar el valor recibido
     */
    def validar_unique_codigo_ajax() {
        params.codigo = params.codigo.toString().trim()
        if (params.id) {
            def obj = Variables.get(params.id)
            if (obj.codigo.toLowerCase() == params.codigo.toLowerCase()) {
                render true
                return
            } else {
                render Variables.countByCodigoIlike(params.codigo) == 0
                return
            }
        } else {
            render Variables.countByCodigoIlike(params.codigo) == 0
            return
        }
    }
        
}

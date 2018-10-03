package docentes

import org.springframework.dao.DataIntegrityViolationException
import seguridad.Shield


/**
 * Controlador que muestra las pantallas de manejo de Facultad
 */
class FacultadController extends Shield {

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
            def c = Facultad.createCriteria()
            list = c.list(params) {
                or {
                    /* TODO: cambiar aqui segun sea necesario */
                    
                    ilike("codigo", "%" + params.search + "%")  
                    ilike("nombre", "%" + params.search + "%")  
                }
            }
        } else {
            list = Facultad.list(params)
        }
        if (!all && params.offset.toInteger() > 0 && list.size() == 0) {
            params.offset = params.offset.toInteger() - 1
            list = getList(params, all)
        }
        return list
    }

    def getList2(params, all, uni) {

        def universidad = Universidad.get(uni)

        params = params.clone()
        params.max = params.max ? Math.min(params.max.toInteger(), 100) : 10
        params.offset = params.offset ?: 0
        if(all) {
            params.remove("max")
            params.remove("offset")
        }
        def list
        if(params.search) {
            def c = Facultad.createCriteria()
            list = c.list(params) {


                eq("universidad", universidad)

                or {
                    /* TODO: cambiar aqui segun sea necesario */

                    ilike("codigo", "%" + params.search + "%")
                    ilike("nombre", "%" + params.search + "%")
                }
            }
        } else {
//            list = Facultad.list(params)
            def c = Facultad.createCriteria()
            list = c.list(params) {
                eq("universidad", universidad)
            }
        }
        if (!all && params.offset.toInteger() > 0 && list.size() == 0) {
            params.offset = params.offset.toInteger() - 1
            list = getList(params, all)
        }
        return list
    }

    /**
     * Acción que muestra la lista de elementos
     * @return facultadInstanceList: la lista de elementos filtrados, facultadInstanceCount: la cantidad total de elementos (sin máximo)
     */
    def list() {

        def universidad
        def facultadInstanceList
        def facultadInstanceCount

        if(session.perfil.codigo == 'ADMG'){
            facultadInstanceList = getList(params, false)
            facultadInstanceCount = getList(params, true).size()
        }else{
            universidad = Universidad.get(seguridad.Persona.get(session.usuario.id)?.universidad?.id)
            facultadInstanceList = getList2(params, false, universidad.id)
            facultadInstanceCount = getList2(params, true, universidad.id).size()
        }

        return [facultadInstanceList: facultadInstanceList, facultadInstanceCount: facultadInstanceCount]
    }

    /**
     * Acción llamada con ajax que muestra la información de un elemento particular
     * @return facultadInstance el objeto a mostrar cuando se encontró el elemento
     * @render ERROR*[mensaje] cuando no se encontró el elemento
     */
    def show_ajax() {
        if(params.id) {
            def facultadInstance = Facultad.get(params.id)
            if(!facultadInstance) {
                render "ERROR*No se encontró Facultad."
                return
            }
            return [facultadInstance: facultadInstance]
        } else {
            render "ERROR*No se encontró Facultad."
        }
    } //show para cargar con ajax en un dialog

    /**
     * Acción llamada con ajax que muestra un formaulario para crear o modificar un elemento
     * @return facultadInstance el objeto a modificar cuando se encontró el elemento
     * @render ERROR*[mensaje] cuando no se encontró el elemento
     */
    def form_ajax() {
        def facultadInstance = new Facultad()
        if(params.id) {
            facultadInstance = Facultad.get(params.id)
            if(!facultadInstance) {
                render "ERROR*No se encontró Facultad."
                return
            }
        }
        facultadInstance.properties = params
        return [facultadInstance: facultadInstance]
    } //form para cargar con ajax en un dialog


    def validar_codigo_ajax () {
        def codigoIngresado = params.codigo.toString()
        def listaFacultades = Facultad.list().codigo
        def res
        if (params.id){
           def codigoActual = Facultad.get(params.id).codigo
            listaFacultades = listaFacultades - codigoActual
            res = !listaFacultades.contains(codigoIngresado)
            render res
            return

        }else{
            res = !listaFacultades.contains(codigoIngresado)
            render res
            return
        }
    }



    /**
     * Acción llamada con ajax que guarda la información de un elemento
     * @render ERROR*[mensaje] cuando no se pudo grabar correctamente, SUCCESS*[mensaje] cuando se grabó correctamente
     */
    def save_ajax() {

        def facultadInstance = new Facultad()
        if(params.id) {
            facultadInstance = Facultad.get(params.id)
            if(!facultadInstance) {
                render "ERROR*No se encontró Facultad."
                return
            }
        }
        facultadInstance.properties = params
        facultadInstance.nombre = params.nombre.toUpperCase()
        if(!facultadInstance.save(flush: true)) {
            render "ERROR*Ha ocurrido un error al guardar Facultad: " + renderErrors(bean: facultadInstance)
            return
        }
        render "SUCCESS*${params.id ? 'Actualización' : 'Creación'} de Facultad exitosa."
        return
    } //save para grabar desde ajax

    /**
     * Acción llamada con ajax que permite eliminar un elemento
     * @render ERROR*[mensaje] cuando no se pudo eliminar correctamente, SUCCESS*[mensaje] cuando se eliminó correctamente
     */
    def delete_ajax() {
        if(params.id) {
            def facultadInstance = Facultad.get(params.id)
            if (!facultadInstance) {
                render "ERROR*No se encontró Facultad."
                return
            }
            try {
                facultadInstance.delete(flush: true)
                render "SUCCESS*Eliminación de Facultad exitosa."
                return
            } catch (DataIntegrityViolationException e) {
                render "ERROR*Ha ocurrido un error al eliminar Facultad"
                return
            }
        } else {
            render "ERROR*No se encontró Facultad."
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
            def obj = Facultad.get(params.id)
            if (obj.codigo.toLowerCase() == params.codigo.toLowerCase()) {
                render true
                return
            } else {
                render Facultad.countByCodigoIlike(params.codigo) == 0
                return
            }
        } else {
            render Facultad.countByCodigoIlike(params.codigo) == 0
            return
        }
    }
        
}

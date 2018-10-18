package docentes

import org.springframework.dao.DataIntegrityViolationException
import seguridad.Shield


/**
 * Controlador que muestra las pantallas de manejo de EscuelaCarrera
 */
class EscuelaCarreraController extends Shield {

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
            def c = EscuelaCarrera.createCriteria()
            list = c.list(params) {
                or {
                    /* TODO: cambiar aqui segun sea necesario */

                }
            }
        } else {
            list = EscuelaCarrera.list(params)
        }
        if (!all && params.offset.toInteger() > 0 && list.size() == 0) {
            params.offset = params.offset.toInteger() - 1
            list = getList(params, all)
        }
        return list
    }

    /**
     * Acción que muestra la lista de elementos
     * @return escuelaCarreraInstanceList: la lista de elementos filtrados, escuelaCarreraInstanceCount: la cantidad total de elementos (sin máximo)
     */
    def list() {
        def escuelaCarreraInstanceList = getList(params, false)
        def escuelaCarreraInstanceCount = getList(params, true).size()
        return [escuelaCarreraInstanceList: escuelaCarreraInstanceList, escuelaCarreraInstanceCount: escuelaCarreraInstanceCount]
    }

    /**
     * Acción llamada con ajax que muestra la información de un elemento particular
     * @return escuelaCarreraInstance el objeto a mostrar cuando se encontró el elemento
     * @render ERROR*[mensaje] cuando no se encontró el elemento
     */
    def show_ajax() {
        if(params.id) {
            def escuelaCarreraInstance = EscuelaCarrera.get(params.id)
            if(!escuelaCarreraInstance) {
                render "ERROR*No se encontró EscuelaCarrera."
                return
            }
            return [escuelaCarreraInstance: escuelaCarreraInstance]
        } else {
            render "ERROR*No se encontró EscuelaCarrera."
        }
    } //show para cargar con ajax en un dialog

    /**
     * Acción llamada con ajax que muestra un formaulario para crear o modificar un elemento
     * @return escuelaCarreraInstance el objeto a modificar cuando se encontró el elemento
     * @render ERROR*[mensaje] cuando no se encontró el elemento
     */
    def form_ajax() {
        def escuelaCarreraInstance = new EscuelaCarrera()
        if(params.id) {
            escuelaCarreraInstance = EscuelaCarrera.get(params.id)
            if(!escuelaCarreraInstance) {
                render "ERROR*No se encontró EscuelaCarrera."
                return
            }
        }
        escuelaCarreraInstance.properties = params
        return [escuelaCarreraInstance: escuelaCarreraInstance]
    } //form para cargar con ajax en un dialog

    /**
     * Acción llamada con ajax que guarda la información de un elemento
     * @render ERROR*[mensaje] cuando no se pudo grabar correctamente, SUCCESS*[mensaje] cuando se grabó correctamente
     */
    def save_ajax() {
        def escuelaCarreraInstance
        def carrera = Carrera.get(params."carrera.id")
        def escuela = Escuela.get(params.escuelaF_name)
        def texto = ''
        if(params.id) {
            escuelaCarreraInstance = EscuelaCarrera.get(params.id)
            texto = 'Registro actualizado correctamente'
        }else{
            escuelaCarreraInstance = new EscuelaCarrera()
            texto = "Registro creado correctamente"
        }

        escuelaCarreraInstance.carrera = carrera
        escuelaCarreraInstance.escuela = escuela

        try{
            escuelaCarreraInstance.save(flush: true)
            render "ok_" + texto
        }catch (e){
            println("Error al guardar escuelaCarrera " + e + "_ " + escuelaCarreraInstance?.errors)
            render "no"
        }

    } //save para grabar desde ajax

    /**
     * Acción llamada con ajax que permite eliminar un elemento
     * @render ERROR*[mensaje] cuando no se pudo eliminar correctamente, SUCCESS*[mensaje] cuando se eliminó correctamente
     */
    def delete_ajax() {
        if(params.id) {
            def escuelaCarreraInstance = EscuelaCarrera.get(params.id)
            if (!escuelaCarreraInstance) {
                render "no"
                return
            }
            try {
                escuelaCarreraInstance.delete(flush: true)
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


    def tablaEscuelaCarreras_ajax () {
        def facultadE
        def escuelas
        def universidad = Universidad.get(params.universidad)
        if(params.facultad == '0'){
            escuelas = Escuela.withCriteria {
                facultad{
                    eq("universidad", universidad)
                }
                order("nombre", "asc")
              }
        }else{
            facultadE = Facultad.get(params.facultad)
            escuelas = Escuela.findAllByFacultad(facultadE)
        }

        def escuelaCarrera = EscuelaCarrera.findAllByEscuelaInList(escuelas)
        return[escuelaCarreraInstanceList : escuelaCarrera]
    }

    def facultad_ajax () {

        def universidad = Universidad.get(params.universidad)
        def facultades = Facultad.findAllByUniversidad(universidad)
        def escuelaCarrera
        if(params.xCarr){
            escuelaCarrera = EscuelaCarrera.get(params.xCarr)
        }

        return [facultades: facultades, escuelaCarrera: escuelaCarrera]

    }

    def escuela_ajax () {

        def facultad = Facultad.get(params.facultad)
        def escuelas = Escuela.findAllByFacultad(facultad)
        def escuelaCarrera
        if(params.xCarr){
            escuelaCarrera = EscuelaCarrera.get(params.xCarr)
        }

        return [escuelas: escuelas, escuelaCarrera: escuelaCarrera]
    }

}

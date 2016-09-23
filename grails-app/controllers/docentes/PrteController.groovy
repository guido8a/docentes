package docentes

import org.springframework.dao.DataIntegrityViolationException
import seguridad.Shield


/**
 * Controlador que muestra las pantallas de manejo de Prte
 */
class PrteController extends Shield {

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
            def c = Prte.createCriteria()
            list = c.list(params) {
                or {
                    /* TODO: cambiar aqui segun sea necesario */

                }
            }
        } else {
            list = Prte.list(params)
        }
        if (!all && params.offset.toInteger() > 0 && list.size() == 0) {
            params.offset = params.offset.toInteger() - 1
            list = getList(params, all)
        }
        return list
    }

    /**
     * Acción que muestra la lista de elementos
     * @return prteInstanceList: la lista de elementos filtrados, prteInstanceCount: la cantidad total de elementos (sin máximo)
     */
    def list() {
        def prteInstanceList = getList(params, false)
        def prteInstanceCount = getList(params, true).size()
        return [prteInstanceList: prteInstanceList, prteInstanceCount: prteInstanceCount]
    }

    /**
     * Acción llamada con ajax que muestra la información de un elemento particular
     * @return prteInstance el objeto a mostrar cuando se encontró el elemento
     * @render ERROR*[mensaje] cuando no se encontró el elemento
     */
    def show_ajax() {
        if(params.id) {
            def prteInstance = Prte.get(params.id)
            if(!prteInstance) {
                render "ERROR*No se encontró Prte."
                return
            }
            return [prteInstance: prteInstance]
        } else {
            render "ERROR*No se encontró Prte."
        }
    } //show para cargar con ajax en un dialog

    /**
     * Acción llamada con ajax que muestra un formaulario para crear o modificar un elemento
     * @return prteInstance el objeto a modificar cuando se encontró el elemento
     * @render ERROR*[mensaje] cuando no se encontró el elemento
     */
    def form_ajax() {
        def prteInstance = new Prte()
        if(params.id) {
            prteInstance = Prte.get(params.id)
            if(!prteInstance) {
                render "ERROR*No se encontró Prte."
                return
            }
        }
        prteInstance.properties = params
        return [prteInstance: prteInstance]
    } //form para cargar con ajax en un dialog

    /**
     * Acción llamada con ajax que guarda la información de un elemento
     * @render ERROR*[mensaje] cuando no se pudo grabar correctamente, SUCCESS*[mensaje] cuando se grabó correctamente
     */
    def save_ajax() {
        def prteInstance = new Prte()
        if(params.id) {
            prteInstance = Prte.get(params.id)
            if(!prteInstance) {
                render "ERROR*No se encontró Prte."
                return
            }
        }
        prteInstance.properties = params
        if(!prteInstance.save(flush: true)) {
            render "ERROR*Ha ocurrido un error al guardar Prte: " + renderErrors(bean: prteInstance)
            return
        }
        render "SUCCESS*${params.id ? 'Actualización' : 'Creación'} de Prte exitosa."
        return
    } //save para grabar desde ajax

    /**
     * Acción llamada con ajax que permite eliminar un elemento
     * @render ERROR*[mensaje] cuando no se pudo eliminar correctamente, SUCCESS*[mensaje] cuando se eliminó correctamente
     */
    def delete_ajax() {
        if(params.id) {
            def prteInstance = Prte.get(params.id)
            if (!prteInstance) {
                render "ERROR*No se encontró Prte."
                return
            }
            try {
                prteInstance.delete(flush: true)
                render "SUCCESS*Eliminación de Prte exitosa."
                return
            } catch (DataIntegrityViolationException e) {
                render "ERROR*Ha ocurrido un error al eliminar Prte"
                return
            }
        } else {
            render "ERROR*No se encontró Prte."
            return
        }
    } //delete para eliminar via ajax

    def definir () {
        def tipoEncuesta = TipoEncuesta.get(params.id)
        def prte = Prte.findAllByTipoEncuesta(tipoEncuesta)

        return [tipoEncuesta: tipoEncuesta, prte: prte]
    }

    def codigo_ajax () {
        def tipoEncuesta = TipoEncuesta.get(params.id)
        return [tipoEncuesta: tipoEncuesta]
    }

    def buscarPregunta_ajax() {
        def tipoEncuesta = TipoEncuesta.get(params.id)
        return [tipoEncuesta: tipoEncuesta]
    }

    def tablaBusquedaPregunta_ajax () {

//        println("params tbp " + params)

        def tipoEncuesta = TipoEncuesta.get(params.tipoEncuesta)
        def listaPrte = Prte.findAllByTipoEncuesta(tipoEncuesta).pregunta.id



        def codigo = params.codigo.toUpperCase().toString().trim()
        def descripcion = params.pregunta.toString()

        def preguntas = Pregunta.withCriteria {

            and{
                ilike("codigo","%$codigo%")
                ilike("descripcion","%$descripcion%")
            }


            order("codigo",'asc')
        }

//        def idFiltradas = buscadas.id - listaPrte
//        def preguntas = Pregunta.findAllByIdInList(idFiltradas)


        return [preguntas: preguntas, lista: listaPrte, tipoEncuesta: tipoEncuesta]


    }

    def tablaPrte_ajax () {
        def tipoEncuesta = TipoEncuesta.get(params.id)
        def preguntas = Prte.findAllByTipoEncuesta(tipoEncuesta, [sort: 'numero', order: 'asc'])
        return [preguntas: preguntas]
    }

    def verificarPregunta_ajax () {

//        println("params verificar " + params)

        def pregunta = Pregunta.get(params.id)
        def encuesta = TipoEncuesta.get(params.encuesta)
        def prte = Prte.findAllByTipoEncuesta(encuesta).pregunta.id

        def res = prte.contains(pregunta.id)

        if(res){
            render "ok"
        }else{
            render "no"
        }
    }

    def orden_ajax () {
        def pregunta = Pregunta.get(params.id)
        return [pregunta: pregunta]
    }

    def asignarPregunta_ajax () {

        def pregunta = Pregunta.get(params.pregunta)
        def encuesta = TipoEncuesta.get(params.encuesta)
        def prte

        if(params.id){
            prte = Prte.get(params.id)
            prte.numero = params.orden.toInteger()
        }else{
            prte = new Prte()
            prte.pregunta = pregunta
            prte.tipoEncuesta = encuesta
            prte.numero = params.orden.toInteger()
          }

        try {
           prte.save(flush: true)
            render "ok"
        }catch (e){
            render "no"
            println("error al guardar el prte " + prte.errors)
        }

    }

    def borrarPregunta_ajax () {

    }

}

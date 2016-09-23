package docentes

import org.springframework.dao.DataIntegrityViolationException
import seguridad.Shield


/**
 * Controlador que muestra las pantallas de manejo de Pregunta
 */
class PreguntaController extends Shield {

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
            def c = Pregunta.createCriteria()
            list = c.list(params) {
                or {
                    /* TODO: cambiar aqui segun sea necesario */

                    ilike("codigo", "%" + params.search + "%")
                    ilike("descripcion", "%" + params.search + "%")
                    ilike("estado", "%" + params.search + "%")
                    ilike("estrategia", "%" + params.search + "%")
                }
            }
        } else {
            list = Pregunta.list(params)
        }
        if (!all && params.offset.toInteger() > 0 && list.size() == 0) {
            params.offset = params.offset.toInteger() - 1
            list = getList(params, all)
        }
        return list
    }

    /**
     * Acción que muestra la lista de elementos
     * @return preguntaInstanceList: la lista de elementos filtrados, preguntaInstanceCount: la cantidad total de elementos (sin máximo)
     */
    def list() {
        def preguntaInstanceList = getList(params, false)
//        def preguntaInstanceList = Pregunta.list([sort: 'codigo', order: 'asc'])
        def preguntaInstanceCount = getList(params, true).size()
        return [preguntaInstanceList: preguntaInstanceList, preguntaInstanceCount: preguntaInstanceCount]
    }

    /**
     * Acción llamada con ajax que muestra la información de un elemento particular
     * @return preguntaInstance el objeto a mostrar cuando se encontró el elemento
     * @render ERROR*[mensaje] cuando no se encontró el elemento
     */
    def show_ajax() {
        if(params.id) {
            def preguntaInstance = Pregunta.get(params.id)
            if(!preguntaInstance) {
                render "ERROR*No se encontró Pregunta."
                return
            }
            return [preguntaInstance: preguntaInstance]
        } else {
            render "ERROR*No se encontró Pregunta."
        }
    } //show para cargar con ajax en un dialog

    /**
     * Acción llamada con ajax que muestra un formaulario para crear o modificar un elemento
     * @return preguntaInstance el objeto a modificar cuando se encontró el elemento
     * @render ERROR*[mensaje] cuando no se encontró el elemento
     */
    def form_ajax() {
        def preguntaInstance = new Pregunta()
        if(params.id) {
            preguntaInstance = Pregunta.get(params.id)
            if(!preguntaInstance) {
                render "ERROR*No se encontró Pregunta."
                return
            }
        }
        preguntaInstance.properties = params
        return [preguntaInstance: preguntaInstance]
    } //form para cargar con ajax en un dialog

    /**
     * Acción llamada con ajax que guarda la información de un elemento
     * @render ERROR*[mensaje] cuando no se pudo grabar correctamente, SUCCESS*[mensaje] cuando se grabó correctamente
     */
    def save_ajax() {
        def preguntaInstance = new Pregunta()
        if(params.id) {
            preguntaInstance = Pregunta.get(params.id)
            if(!preguntaInstance) {
                render "ERROR*No se encontró Pregunta."
                return
            }
        }
        preguntaInstance.properties = params
        if(!preguntaInstance.save(flush: true)) {
            render "ERROR*Ha ocurrido un error al guardar Pregunta: " + renderErrors(bean: preguntaInstance)
            return
        }
        render "SUCCESS*${params.id ? 'Actualización' : 'Creación'} de Pregunta exitosa."
        return
    } //save para grabar desde ajax

    /**
     * Acción llamada con ajax que permite eliminar un elemento
     * @render ERROR*[mensaje] cuando no se pudo eliminar correctamente, SUCCESS*[mensaje] cuando se eliminó correctamente
     */
    def delete_ajax() {
        if(params.id) {
            def preguntaInstance = Pregunta.get(params.id)
            if (!preguntaInstance) {
                render "ERROR*No se encontró Pregunta."
                return
            }
            try {
                preguntaInstance.delete(flush: true)
                render "SUCCESS*Eliminación de Pregunta exitosa."
                return
            } catch (DataIntegrityViolationException e) {
                render "ERROR*Ha ocurrido un error al eliminar Pregunta"
                return
            }
        } else {
            render "ERROR*No se encontró Pregunta."
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
            def obj = Pregunta.get(params.id)
            if (obj.codigo.toLowerCase() == params.codigo.toLowerCase()) {
                render true
                return
            } else {
                render Pregunta.countByCodigoIlike(params.codigo) == 0
                return
            }
        } else {
            render Pregunta.countByCodigoIlike(params.codigo) == 0
            return
        }
    }


    def pregunta () {
        def pregunta
        if(params.id){
            pregunta = Pregunta.get(params.id)
        }
        return [preguntaInstance: pregunta]
    }

    def tablaRespuestas_ajax () {
        def pregunta = Pregunta.get(params.id)
        def respuestas = RespuestaPregunta.findAllByPregunta(pregunta)
        return [respuestas: respuestas, pregunta: pregunta]
    }

    def valoracion_ajax () {
        def respuesta = Respuesta.get(params.id)
        return [respuesta: respuesta]
    }

    def codigo_ajax () {
        def respuesta = Respuesta.get(params.id)
        return [respuesta: respuesta]
    }

    def respuesta_ajax () {
        def pregunta
        def respuestas
        def lista
        def filtrados
        if(params.id){
            pregunta = Pregunta.get(params.id)
            respuestas = RespuestaPregunta.findAllByPregunta(pregunta).respuesta
            lista = Respuesta.list([sort: 'descripcion', order: 'asc']).id - respuestas.id
            filtrados = Respuesta.findAllByIdInList(lista)
        }
        return [preguntaInstance: pregunta, lista: filtrados]
    }

    def agregarRespuesta_ajax () {

//        println("params " + params)

        def respuesta = Respuesta.get(params.respuesta)
        def pregunta = Pregunta.get(params.id)
        def preguntaRespuesta

        preguntaRespuesta = new RespuestaPregunta()
        preguntaRespuesta.respuesta = respuesta
        preguntaRespuesta.pregunta = pregunta
        preguntaRespuesta.valor = params.valor.toDouble()

        try {
            preguntaRespuesta.save(flush: true)
            render "ok"

        }catch (e){
            render "no"
            println("error al guardar la respuesta" + preguntaRespuesta.errors)
        }
    }

    def borrarRespuesta_ajax () {
        def respuestaPregunta = RespuestaPregunta.get(params.id)
        try{
            respuestaPregunta.delete(flush: true)
            render "ok"
        }catch (e){
            render "no"
            println("error al borrar la respuesta " + respuestaPregunta.errors)
        }
    }

    def guardarPregunta_ajax () {
//        println("params guardar " + params)
        def pregunta
        def tipoRespuesta = TipoRespuesta.get(params.valoracion)
        def variable = Variables.get(params.variable)
        if(params.id){
            pregunta = Pregunta.get(params.id)
            pregunta.codigo = params.codigo
            pregunta.descripcion = params.pregunta
            pregunta.estrategia = params.estrategia
            pregunta.tipoRespuesta = tipoRespuesta
            pregunta.variables = variable
            pregunta.numeroRespuestas = params.numero.toInteger()

        }else{
            pregunta = new Pregunta()
            pregunta.codigo = params.codigo
            pregunta.descripcion = params.pregunta
            pregunta.estrategia = params.estrategia
            pregunta.tipoRespuesta = tipoRespuesta
            pregunta.variables = variable
            pregunta.numeroRespuestas = params.numero.toInteger()
            pregunta.estado = 'N'
        }

        try {
            pregunta.save(flush: true)
            render "ok_" + pregunta?.id
        }catch (e){
            render "no_error"
            println("error al guardar la pregunta " + pregunta.errors)
        }
    }

    def desregistrar_ajax () {
        def pregunta = Pregunta.get(params.id)
        pregunta.estado = 'N'

        try {
            pregunta.save(flush: true)
            render "ok"
        }catch (e){
            render "no"
            println("error al desregistrar " + pregunta.errors)
        }
    }

    def registrar_ajax () {
        def pregunta = Pregunta.get(params.id)
        pregunta.estado = 'R'

        try {
            pregunta.save(flush: true)
            render "ok"
        }catch (e){
            render "no"
            println("error al registrar " + pregunta.errors)
        }
    }

    def editarRespuesta_ajax () {
        def respuesta = RespuestaPregunta.get(params.id)
        return [respuesta: respuesta]
    }

    def editarSave_ajax () {
        println(params)
        def respuesta = RespuestaPregunta.get(params.id)
        if(params.valor != " " || params.valor != null){
            respuesta.valor = params.valor.toDouble();
            try{
                respuesta.save(flush: true)
                render "ok"
            }catch (e){
                render "no"
            }
        }else{
            render 'no'
        }
    }

    def tablaItems_ajax() {
        def pregunta = Pregunta.get(params.id)
//        def items = ItemPregunta.findAllByPregunta(pregunta)
        def items = ItemPregunta.withCriteria {
            eq("pregunta",pregunta)
            ne("descripcion",'ITEM_UNICO')

            order("orden","asc")
        }

        return [items: items, pregunta: pregunta]
    }


    def guardarItem_ajax () {
        println("params g item " + params)
        def pregunta = Pregunta.get(params.pregunta)
        def itemPregunta
        def ordenActual = params.orden.toInteger()

        def itemsFiltrados
        def items = ItemPregunta.findAllByPregunta(pregunta)
        def orden = items.orden


        itemsFiltrados = ItemPregunta.findAllByPreguntaAndOrdenGreaterThanEquals(pregunta, ordenActual, [sort: 'orden', order: 'desc'])
        def itemsFiltrados2 = ItemPregunta.findAllByPreguntaAndOrdenGreaterThan(pregunta, ordenActual, [sort: 'orden', order: 'desc'])
        println("items " + itemsFiltrados.orden)




        if(params.id){
            itemPregunta = ItemPregunta.get(params.id)

            if(itemPregunta.orden != ordenActual){
                itemsFiltrados.each {p->
                    if(p.id != itemPregunta.id){
                        p.orden = p.orden + 1
                        p.save(flush: true)
                    }else{
                        println("no hace nada, mismo id")
                    }
                }
            }else{
                println("no hace nada, mismo orden")
            }


            itemPregunta.descripcion = params.descripcion
            itemPregunta.orden = params.orden.toInteger()
            itemPregunta.tipo = params.tipo.toUpperCase()
        }else {
            itemPregunta = new ItemPregunta()

            itemsFiltrados.each{q->
                q.orden = q.orden + 1
                q.save(flush: true)
            }

            itemPregunta.pregunta = pregunta
            itemPregunta.descripcion = params.descripcion
            itemPregunta.orden = params.orden.toInteger()
            itemPregunta.tipo = params.tipo.toUpperCase()
        }




        try {
            itemPregunta.save(flush: true)
           render "ok"
        }catch (e){
            render "no"
            println("error al guardar el item "  +  itemPregunta.errors )
        }
    }


    def borrarItem_ajax () {
        def item = ItemPregunta.get(params.id)
        try{
            item.delete(flush: true)
            render "ok"
        }catch (e){
            render "no"
        }
    }

    def editarItem_ajax () {

        def item = ItemPregunta.get(params.id)

        return [item: item]
    }

}

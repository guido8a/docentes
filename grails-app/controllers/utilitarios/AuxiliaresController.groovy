package utilitarios

import docentes.Periodo
import org.springframework.dao.DataIntegrityViolationException
import seguridad.Shield


/**
 * Controlador que muestra las pantallas de manejo de Auxiliares
 */
class AuxiliaresController extends Shield {

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
            def c = Auxiliares.createCriteria()
            list = c.list(params) {
                or {
                    /* TODO: cambiar aqui segun sea necesario */
                    
                    ilike("curso", "%" + params.search + "%")  
                }
            }
        } else {
            list = Auxiliares.list(params)
        }
        if (!all && params.offset.toInteger() > 0 && list.size() == 0) {
            params.offset = params.offset.toInteger() - 1
            list = getList(params, all)
        }
        return list
    }

    /**
     * Acción que muestra la lista de elementos
     * @return auxiliaresInstanceList: la lista de elementos filtrados, auxiliaresInstanceCount: la cantidad total de elementos (sin máximo)
     */
    def list() {
        def auxiliaresInstanceList = getList(params, false)
        def auxiliaresInstanceCount = getList(params, true).size()
        return [auxiliaresInstanceList: auxiliaresInstanceList, auxiliaresInstanceCount: auxiliaresInstanceCount]
    }

    /**
     * Acción llamada con ajax que muestra la información de un elemento particular
     * @return auxiliaresInstance el objeto a mostrar cuando se encontró el elemento
     * @render ERROR*[mensaje] cuando no se encontró el elemento
     */
    def show_ajax() {
        if(params.id) {
            def auxiliaresInstance = Auxiliares.get(params.id)
            if(!auxiliaresInstance) {
                render "ERROR*No se encontró Auxiliares."
                return
            }
            return [auxiliaresInstance: auxiliaresInstance]
        } else {
            render "ERROR*No se encontró Auxiliares."
        }
    } //show para cargar con ajax en un dialog

    /**
     * Acción llamada con ajax que muestra un formaulario para crear o modificar un elemento
     * @return auxiliaresInstance el objeto a modificar cuando se encontró el elemento
     * @render ERROR*[mensaje] cuando no se encontró el elemento
     */
    def form_ajax() {
        def auxiliaresInstance = new Auxiliares()
        if(params.id) {
            auxiliaresInstance = Auxiliares.get(params.id)
            if(!auxiliaresInstance) {
                render "ERROR*No se encontró Auxiliares."
                return
            }
        }
        auxiliaresInstance.properties = params
        return [auxiliaresInstance: auxiliaresInstance]
    } //form para cargar con ajax en un dialog

    /**
     * Acción llamada con ajax que guarda la información de un elemento
     * @render ERROR*[mensaje] cuando no se pudo grabar correctamente, SUCCESS*[mensaje] cuando se grabó correctamente
     */
    def save_ajax() {

        println("Auxiliares " + params)

        def dia = new Date().parse("dd-MM-yyyy", params.fechaCierre_input)


        def auxiliaresInstance = new Auxiliares()
        if(params.id) {
            auxiliaresInstance = Auxiliares.get(params.id)
            if(!auxiliaresInstance) {
                render "ERROR*No se encontró Auxiliares."
                return
            }
        }
        auxiliaresInstance.properties = params
        auxiliaresInstance.fechaCierre = dia
        if(!auxiliaresInstance.save(flush: true)) {
            render "no"

        }else{
            render "ok"
        }

    } //save para grabar desde ajax

    /**
     * Acción llamada con ajax que permite eliminar un elemento
     * @render ERROR*[mensaje] cuando no se pudo eliminar correctamente, SUCCESS*[mensaje] cuando se eliminó correctamente
     */
    def delete_ajax() {
        if(params.id) {
            def auxiliaresInstance = Auxiliares.get(params.id)
            if (!auxiliaresInstance) {
                render "no"
                return
            }
            try {
                auxiliaresInstance.delete(flush: true)
                render "ok"
                return
            } catch (DataIntegrityViolationException e) {
                render "no"
                return
            }
        } else {
            render "no"
            return
        }
    } //delete para eliminar via ajax

    def auxiliares () {
        def auxiliar = Auxiliares.get(params.id)
        return [auxiliar: auxiliar]
    }

    def grafico_ajax () {
        println("params " + params)
        return [valor: params.valor]
    }

    def guardarValores_ajax () {
        println("parametros " + params)

        def auxiliar
        if(params.id){
            auxiliar = Auxiliares.get(params.id)
            auxiliar.factorExito = params.exito.toInteger()
            auxiliar.ajusteExagerado = params.exagerado.toInteger()
            auxiliar.ajusteModerado = params.moderado.toInteger()
            auxiliar.cuelloBotella = params.botella.toInteger()
            auxiliar.maximoAutoevaluacion = params.auto.toInteger()
            auxiliar.maximoDirectivos = params.directivos.toInteger()
            auxiliar.maximoEstudiantes = params.estudiantes.toInteger()
            auxiliar.maximoPares = params.pares.toInteger()
            auxiliar.optimo = params.optimo.toInteger()
            auxiliar.minimo = params.minimo.toInteger()

            if(auxiliar.save(flush: true)){
                render "ok_Información actualizada correctamente_${auxiliar?.id}"
            }else{
                render "no_Error al actualizar la información"
                println("error save auxiliar" + auxiliar.errors)
            }


        }else{

            def per = Periodo.get(params.periodo)

            def auxiliares = Auxiliares.list()

            if(per in auxiliares.periodo){

                render "no_Ya existen parámetros auxiliares para este período!"

            }else{
                auxiliar = new Auxiliares()
                auxiliar.factorExito = params.exito.toInteger()
                auxiliar.ajusteExagerado = params.exagerado.toInteger()
                auxiliar.ajusteModerado = params.moderado.toInteger()
                auxiliar.cuelloBotella = params.botella.toInteger()
                auxiliar.maximoAutoevaluacion = params.auto.toInteger()
                auxiliar.maximoDirectivos = params.directivos.toInteger()
                auxiliar.maximoEstudiantes = params.estudiantes.toInteger()
                auxiliar.maximoPares = params.pares.toInteger()
                auxiliar.optimo = params.optimo.toInteger()
                auxiliar.minimo = params.minimo.toInteger()

                auxiliar.periodo = per


                if(auxiliar.save(flush: true)){
                    render "ok_Parámetros auxiliares creados correctamente_${auxiliar?.id}"
                }else{
                    render "no_Error crear los parámetros auxiliares"
                    println("error save auxiliar" + auxiliar.errors)
                }
            }
        }

    }

}

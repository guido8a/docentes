package utilitarios

class Auxiliares {

    int numeroRondas
    int maximoProfesores
    int dias
    String curso
    int paralelo
    Double minimo
    Double optimo
    Date fechaCierre
    int ajusteModerado
    int ajusteExagerado
    int maximoAutoevaluacion
    int maximoPares
    int maximoDirectivos
    int maximoEstudiantes



    static mapping = {
        table 'auxl'
        cache usage: 'read-write', include: 'non-lazy'
        id generator: 'identity'
        version false

        columns {
            id column: 'auxl__id'
            numeroRondas column: 'rndanmro'
            maximoProfesores column: 'max_prof'
            dias column: 'dias'
            curso column: 'crso'
            paralelo column: 'prll'
            minimo column: 'estdmini'
            optimo column: 'estdoptm'
            fechaCierre column: 'fcha'
            ajusteModerado column: 'ajstpnmo'
            ajusteExagerado column: 'ajstpnex'
            maximoAutoevaluacion column: 'auxlauto'
            maximoPares column: 'auxl_para'
            maximoDirectivos column: 'auxldire'
            maximoEstudiantes column: 'auxlestd'
        }
    }


    static constraints = {
    }
}

package utilitarios

import docentes.Periodo

class Auxiliares {

    int numeroRondas = 0
    int maximoProfesores = 0
    int dias = 0
    String curso
    int paralelo = 0
    Double minimo
    Double optimo
    Date fechaCierre
    int ajusteModerado
    int ajusteExagerado
    int maximoAutoevaluacion
    int maximoPares
    int maximoDirectivos
    int maximoEstudiantes
    String password
    Periodo periodo
    int cuelloBotella
    int factorExito

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
            maximoPares column: 'auxl_par'
            maximoDirectivos column: 'auxldire'
            maximoEstudiantes column: 'auxlestd'
            password column: 'pass'
            periodo column: 'prdo__id'
            cuelloBotella column: 'pcntccbb'
            factorExito column: 'pcntfcex'
        }
    }


    static constraints = {
        curso(nullable: true, blank: true)
        password(nullable: true, blank: true)
        fechaCierre(nullable: true)
    }
}

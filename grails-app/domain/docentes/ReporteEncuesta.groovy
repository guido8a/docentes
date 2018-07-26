package docentes

class ReporteEncuesta {

    Profesor profesor
    Periodo periodo
    TipoEncuesta tipoEncuesta
    Dictan dictan
    Double ddsc
    Double ddac
    Double ddhd
    Double ddci
    Double dcni
    Double d_ea
    Double promedio
    String clase
    String materia
    String factor
    String materiaCuello
    String causaCuello
    Double valorAjustado
    int recomendacion


    static mapping = {
        table 'rpec'
        cache usage: 'read-write', include: 'non-lazy'
        id generator: 'identity'
        version false

        columns {
            id column: 'rpec__id'
            profesor column: 'prof__id'
            periodo column: 'prdo__id'
            tipoEncuesta column: 'tpen__id'
            dictan column: 'dcta__id'
            ddsc column: 'ddsc'
            ddac column: 'ddac'
            ddhd column: 'ddhd'
            ddci column: 'ddci'
            dcni column: 'dcni'
            d_ea column: 'd_ea'
            promedio column: 'promedio'
            clase column: 'clase'
            materia column: 'extomatr'
            factor column: 'f_exito'
            materiaCuello column: 'cb_matr'
            causaCuello column: 'cb_causa'
            valorAjustado column: 'ajst'
            recomendacion column: 'con_rcmn'
        }
    }

    static constraints = {
        dictan(blank: true, nullable: true)
    }
}

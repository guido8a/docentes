package docentes

class Teti {

    TipoEncuesta tipoEncuesta
    TipoInformante tipoInformante

    static mapping = {
        table 'teti'
        cache usage: 'read-write', include: 'non-lazy'
        id generator: 'identity'
        version false

        columns {
            id column: 'teti__id'
            tipoEncuesta column: 'tpen__id'
            tipoInformante column: 'tpif__id'
        }
    }

    static constraints = {
    }
}

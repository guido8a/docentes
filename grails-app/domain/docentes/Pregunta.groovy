package docentes

class Pregunta {

    TipoRespuesta tipoRespuesta
    Variables variables
    String codigo
    String descripcion
    int numeroRespuestas
    String estado
    String estrategia
    Indicador indicador

    static mapping = {
        table 'preg'
        cache usage: 'read-write', include: 'non-lazy'
        id generator: 'identity'
        version false

        columns {
            id column: 'preg__id'
            tipoRespuesta column: 'tprp__id'
            variables column: 'vrbl__id'
            codigo column: 'pregcdgo'
            descripcion column: 'pregdscr'
            numeroRespuestas column: 'pregnmrp'
            estado column: 'pregetdo'
            estrategia column: 'pregestt'
            indicador column: 'indi__id'
        }
    }

    static constraints = {
        codigo(nullable: false, blank: false, size: 1..8)
        descripcion(nullable: false, blank: false, size: 1..255)
        estrategia(nullable: true, blank: true)
        indicador(nullable: true, blank:true)
    }
}

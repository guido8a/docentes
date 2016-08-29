package docentes

class TipoRespuesta {

    String codigo
    String descripcion

    static mapping = {
        table 'tprp'
        cache usage: 'read-write', include: 'non-lazy'
        id generator: 'identity'
        version false

        columns {
            id column: 'tprp__id'
            codigo column: 'tprpcdgo'
            descripcion column: 'tprpdscr'
        }
    }

    static constraints = {
        codigo(nullable: false, blank: false)
        descripcion (nullable: false, blank: false, size: 1..12)
    }
}

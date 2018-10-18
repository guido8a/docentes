package docentes

class Carrera {

    String descripcion

    static mapping = {
        table 'carr'
        cache usage: 'read-write', include: 'non-lazy'
        id generator: 'identity'
        version false
        columns {
            id column: 'carr__id'
            descripcion column: 'carrdscr'

        }
    }

    static constraints = {
        descripcion(blank: false, nullable: false, size: 1..127)
    }
}

package docentes

class Competencia {

    Carrera carrera
    String descripcion

    static mapping = {
        table 'cmpt'
        cache usage: 'read-write', include: 'non-lazy'
        id generator: 'identity'
        version false
        columns {
            id column: 'cmpt__id'
            carrera column: 'carr__id'
            descripcion column: 'cmptdscr'
        }
    }

    static constraints = {
        descripcion(nullable: false, blank: false)
    }
}

package docentes

class EscuelaCarrera {

    Escuela escuela
    Carrera carrera

    static mapping = {
        table 'escr'
        cache usage: 'read-write', include: 'non-lazy'
        id generator: 'identity'
        version false
        columns {
            id column: 'escr__id'
            escuela column: 'escl__id'
            carrera column: 'carr__id'

        }
    }

    static constraints = {
        escuela(nullable: false, blank:false)
        carrera(nullable: false, blank:false)
    }
}

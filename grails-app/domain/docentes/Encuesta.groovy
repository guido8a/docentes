package docentes

class Encuesta {

    Teti teti
    Profesor profesor
    Estudiante estudiante
    Dictan materiaDictada
    Profesor directivo
    Profesor par
    Date fecha
    String estado = 'N'


    static mapping = {
        table 'encu'
        cache usage: 'read-write', include: 'non-lazy'
        id generator: 'identity'
        version false

        columns {
            id column: 'encu__id'
            teti column: 'teti__id'
            profesor column: 'prof__id'
            estudiante column: 'estd__id'
            materiaDictada column: 'dcta__id'
            directivo column: 'profdrtv'
            par column: 'prof_par'
            fecha column: 'encufcha'
            estado column: 'encuetdo'
        }
    }

    static constraints = {
        teti(blank: false, nullable: false)
        profesor(blank: true, nullable: true)
        estudiante(blank: true, nullable: true)
        materiaDictada(blank: true, nullable: true)
        directivo(blank: true, nullable: true)
        par(blank: true, nullable: true)
        fecha(nullable: false)
        estado(nullable: false)
    }
}

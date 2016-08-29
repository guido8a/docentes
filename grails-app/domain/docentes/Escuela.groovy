package docentes

class Escuela {

    Facultad facultad
    String codigo
    String nombre



    static mapping = {
        table 'escl'
        cache usage: 'read-write', include: 'non-lazy'
        id generator: 'identity'
        version false

        columns {
            id column: 'escl__id'
            facultad column: 'facl__id'
            codigo column: 'esclcdgo'
            nombre column: 'escldscr'
        }
    }

    static constraints = {
        codigo(blank: false, nullable: false, size: 1..8)
        nombre(blank: false, nullable: false, size: 1..127)
    }
}

package docentes

class ItemPregunta {

    Pregunta pregunta
    int orden
    String descripcion
    String tipo

    static mapping = {
        table 'prit'
        cache usage: 'read-write', include: 'non-lazy'
        id generator: 'identity'
        version false

        columns {
            id column: 'prit__id'
            pregunta column: 'preg__id'
            orden column: 'pritordn'
            descripcion column: 'pritdscr'
            tipo column: 'prittipo'
        }
    }

    static constraints = {

        tipo inList: ['A','B']
    }
}

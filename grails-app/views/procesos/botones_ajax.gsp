<div class="list-group">
    <a href="#" class="list-group-item ${boton == '1' ? "list-group-item-warning" : "disabled"} btnFormato" data-id="1">Facultades</a>
    <a href="#" class="list-group-item btnFormato" data-id="2">Escuelas</a>
    <a href="#" class="list-group-item btnFormato" data-id="3">Profesor</a>
    <a href="#" class="list-group-item btnFormato" data-id="4">Estudiantes</a>
    <a href="#" class="list-group-item btnFormato" data-id="5">Materias</a>
    <a href="#" class="list-group-item btnFormato" data-id="6">Dictan</a>
    <a href="#" class="list-group-item btnFormato" data-id="7">Matriculados</a>
</div>

<script type="text/javascript">

    $(".btnFormato").click(function () {
        var boton = $(this).data('id');
        cargarFormato(boton);
    });

</script>
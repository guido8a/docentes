<%--
  Created by IntelliJ IDEA.
  User: gato
  Date: 03/02/17
  Time: 14:30
--%>

<div class="list-group">
    <a href="#" class="list-group-item ${boton == '1' ? "list-group-item-warning" : "disabled"} btnFormato" data-id="1">Facultades</a>
    <a href="#" class="list-group-item btnFormato" data-id="2">Escuelas</a>
    <a href="#" class="list-group-item btnFormato" data-id="3">Profesor</a>
    <a href="#" class="list-group-item btnFormato" data-id="4">Cursos</a>
    <a href="#" class="list-group-item btnFormato" data-id="5">Estudiantes</a>
    <a href="#" class="list-group-item btnFormato" data-id="6">Materias</a>
    <a href="#" class="list-group-item btnFormato" data-id="7">Dictan</a>
    <a href="#" class="list-group-item btnFormato" data-id="8">Matriculados</a>
</div>

<script type="text/javascript">

    $(".btnFormato").click(function () {
        var boton = $(this).data('id');
        cargarFormato(boton);
    });

</script>
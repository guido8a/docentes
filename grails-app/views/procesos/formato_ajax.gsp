<style type="text/css">

    .cabecera{
        background-color: #5c6e80;
        text-align: center;
        font-weight: bold;
        color: WHITE;
    }

</style>

<input type="text" hidden id="tabla" value="${tabla}">
<input type="text" hidden id="tablaTipo" value="${tipo}">
<table class="table table-condensed table-bordered table-striped ${tipo == '1' ? '' : 'hidden'}">
    <thead>
    <tr>
        <th colspan="2">Nombre del archivo: facultades.xls</th>
    </tr>
    </thead>
    <tbody>
    <tr>
        <td class="cabecera">Código</td>
        <td class="cabecera"><i class="fa fa-institution"></i> Facultad</td>
    </tr>
    <tr>
        <td>Numérico</td>
        <td>Texto: Nombre de la Facultad</td>
    </tr>
    </tbody>
</table>

<table class="table table-condensed table-bordered table-striped ${tipo == '2' ? '' : 'hidden'}">
    <thead>
    <tr>
        <th colspan="3">Nombre del archivo: escuelas.xls</th>
    </tr>
    </thead>
    <tbody>
    <tr class="cabecera">
        <td class="cabecera">Código</td>
        <td class="cabecera">Dependencia</td>
        <td class="cabecera">Facultad</td>
    </tr>
    <tr>
        <td>Numérico</td>
        <td>Texto: Nombre de la Escuela o dependencia</td>
        <td>Numérico</td>
    </tr>
    </tbody>
</table>

<table class="table table-condensed table-bordered table-striped ${tipo == '3' ? '' : 'hidden'}">
    <thead>
    <tr>
        <th colspan="7">Nombre del archivo: profesores.xls</th>
    </tr>
    </thead>
    <tbody>
    <tr>
        <td class="cabecera">Facultad</td>
        <td class="cabecera">Escuela</td>
        <td class="cabecera">Cédula</td>
        <td class="cabecera">Nombres</td>
        <td class="cabecera">Apellidos</td>
        <td class="cabecera">Sexo</td>
        <td class="cabecera">Título</td>
    </tr>
    <tr>
        <td>Numérico</td>
        <td>Numérico</td>
        <td>Texto</td>
        <td>Texto: Nombres</td>
        <td>Texto: Apellidos</td>
        <td>Texto</td>
        <td>Texto: 4c</td>
    </tr>
    </tbody>
</table>

<table class="table table-condensed table-bordered table-striped ${tipo == '4' ? '' : 'hidden'}">
    <thead>
    <tr>
        <th colspan="3">Nombre del archivo: estudiantes.xls</th>
    </tr>
    </thead>
    <tbody>
    <tr>
        <td class="cabecera">Cédula</td>
        <td class="cabecera">Nombres</td>
        <td class="cabecera">Apellidos</td>
    </tr>
    <tr>
        <td>Texto</td>
        <td>Texto: Nombres</td>
        <td>Texto: Apellidos</td>
    </tr>
    </tbody>
</table>

<table class="table table-condensed table-bordered table-striped ${tipo == '5' ? '' : 'hidden'}">
    <thead>
    <tr>
        <th colspan="4">Nombre del archivo: materias.xls</th>
    </tr>
    </thead>
    <tbody>
    <tr>
        <td class="cabecera">Código</td>
        <td class="cabecera">Nombre de la materia</td>
        <td class="cabecera">Facultad</td>
        <td class="cabecera">Escuela</td>
    </tr>
    <tr>
        <td>Numérico</td>
        <td>Texto: Nombre de la materia</td>
        <td>Númerico</td>
        <td>Númerico</td>
    </tr>
    </tbody>
</table>

<table class="table table-condensed table-bordered table-striped ${tipo == '6' ? '' : 'hidden'}">
    <thead>
    <tr>
        <th colspan="2">Nombre del archivo: cursos.xls</th>
    </tr>
    </thead>
    <tbody>
    <tr>
        <td class="cabecera">Código</td>
        <td class="cabecera">Nombre del Curso</td>
    </tr>
    <tr>
        <td>Numérico</td>
        <td>Texto: Nombre del curso</td>
    </tr>
    </tbody>
</table>

<table class="table table-condensed table-bordered table-striped ${tipo == '7' ? '' : 'hidden'}">
    <thead>
    <tr>
        <th colspan="4">Nombre del archivo: dictan.xls</th>
    </tr>
    </thead>
    <tbody>
    <tr>
        <td class="cabecera">Cédula Profesor</td>
        <td class="cabecera">Materia</td>
        <td class="cabecera">Curso</td>
        <td class="cabecera">Paralelo</td>
    </tr>
    <tr>
        <td>Texto: 04...</td>
        <td>Numérico: código de materia</td>
        <td>Numérico: código curso</td>
        <td>Texto: Char(1)</td>
    </tr>
    </tbody>
</table>
<table class="table table-condensed table-bordered table-striped ${tipo == '8' ? '' : 'hidden'}">
    <thead>
    <tr>
        <th colspan="5">Nombre del archivo: matriculados.xls</th>
    </tr>
    </thead>
    <tbody>
    <tr>
        <td class="cabecera">Cédula Estudiante</td>
        <td class="cabecera">Cédula Profesor</td>
        <td class="cabecera">Materia</td>
        <td class="cabecera">Curso</td>
        <td class="cabecera">Paralelo</td>
    </tr>
    <tr>
        <td>Texto</td>
        <td>Texto</td>
        <td>Numérico: código</td>
        <td>Numérico: código</td>
        <td>Texto: char(1)</td>
    </tr>
    </tbody>
</table>
<table class="table table-condensed table-bordered table-striped ${tipo == '9' ? '' : 'hidden'}">
    <thead>
    <tr>
        <th colspan="5">Nombre del archivo: todo.xls</th>
    </tr>
    </thead>
    <tbody>
    <tr>
        <td class="cabecera">Código Estudiante</td>
        <td class="cabecera">Apellidos</td>
        <td class="cabecera">Nombres</td>
        <td class="cabecera">Facultad</td>
        <td class="cabecera">Carrera</td>
    </tr>
    <tr>
        <td>Numérico: código</td>
        <td>Texto</td>
        <td>Texto</td>
        <td>Texto</td>
        <td>Texto</td>
    </tr>
    <tr>
        <td class="cabecera">Materia</td>
        <td class="cabecera">Código Materia</td>
        <td class="cabecera">Curso</td>
        <td class="cabecera">Paralelo</td>
        <td class="cabecera">Nombre Profesor</td>
    </tr>
    <tr>
        <td>Texto</td>
        <td>Texto: código</td>
        <td>Texto</td>
        <td>Numérico</td>
        <td>Texto</td>
    </tr>
    <tr>
        <td class="cabecera">Apellido Profesor</td>
        <td class="cabecera">Sexo Profesor</td>
        <td class="cabecera">Título Profesor</td>
    </tr>
    <tr>
        <td>Texto</td>
        <td>Texto: char(1)</td>
        <td>Texto</td>
    </tr>
    </tbody>
</table>
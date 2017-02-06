<%--
  Created by IntelliJ IDEA.
  User: gato
  Date: 03/02/17
  Time: 12:04
--%>

<style type="text/css">

    .cabecera{
        background-color: #5c6e80;
        text-align: center;
        font-weight: bold;
        color: WHITE;
    }

    /*tbody tr td{*/
        /*background-color: #5c6e80;*/
        /*text-align: center;*/
    /*}*/

</style>

<table class="table table-condensed table-bordered table-striped ${tipo == '1' ? '' : 'hidden'}">
    <thead>
    <tr>
        <th>Facultades.xls</th>
    </tr>
    </thead>
    <tbody>
    <tr>
        <td class="cabecera">Código</td>
        <td class="cabecera">Facultad</td>
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
        <th>Escuelas.xls</th>
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
        <th>Profesores.xls</th>
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
        <th>Cursos.xls</th>
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
<table class="table table-condensed table-bordered table-striped ${tipo == '5' ? '' : 'hidden'}">
    <thead>
    <tr>
        <th>Estudiantes.xls</th>
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
<table class="table table-condensed table-bordered table-striped ${tipo == '6' ? '' : 'hidden'}">
    <thead>
    <tr>
        <th>Materias.xls</th>
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
<table class="table table-condensed table-bordered table-striped ${tipo == '7' ? '' : 'hidden'}">
    <thead>
    <tr>
        <th>Dictan.xls</th>
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
        <th>Matriculados.xls</th>
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
<%--
  Created by IntelliJ IDEA.
  User: gato
  Date: 27/12/18
  Time: 14:23
--%>

<script type="text/javascript" src="${resource(dir: 'js/plugins/bootstrap-select-1.6.3/dist/js', file: 'bootstrap-select.js')}"></script>
<link rel="stylesheet" href="${resource(dir: 'js/plugins/bootstrap-select-1.6.3/dist/css', file: 'bootstrap-select.css')}"/>

<g:select from="${preguntasF}" optionKey="id" optionValue="descripcion" name="preguntaF_name" id="preguntaF" class="form-control selectpicker" data-divider="true"/>

<script type="text/javascript">

    $(function () {
        $('.selectpicker').selectpicker({
            width      : "100%",
            limitWidth : true,
            style      : "btn-primary",
            size: 'auto',
            header: 'Seleccione..'
        });
    })
</script>

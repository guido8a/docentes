<%--
  Created by IntelliJ IDEA.
  User: fabricio
  Date: 19/02/19
  Time: 14:31
--%>

<div class="col-md-12">
    <g:select from="${escuelas}" optionValue="nombre" optionKey="id"  name="escuela_name" id="escuelaId" class="form-control"/>
</div>
%{--</div>--}%

<script type="text/javascript">

    $(function () {
        $(document).ready(function () {
            $("#escuelaId").change();
        });

        $("#escuelaId").change(function () {
            var esc = $(this).val();
            $.ajax({
                type: 'POST',
                url: '${createLink(controller: 'reportes', action: 'asignatura_ajax')}',
                data:{
                    escuela: esc,
                    periodo: '${periodo?.id}'
                },
                success: function (msg) {
                    $("#divMaterias").html(msg)
                }
            });

        });
    });

</script>
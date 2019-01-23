<%--
  Created by IntelliJ IDEA.
  User: gato
  Date: 21/01/19
  Time: 14:40
--%>

<%--
  Created by IntelliJ IDEA.
  User: gato
  Date: 22/10/18
  Time: 11:22
--%>

<div class="col-md-12">
    <g:select from="${escuelas}" optionValue="nombre" optionKey="id"  name="escuela_name" id="escuelaE" class="form-control"/>
</div>

<script type="text/javascript">

    $(function () {
        $(document).ready(function () {
            $("#escuelaE").change();
        });
    });

</script>
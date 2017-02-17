<%--
  Created by IntelliJ IDEA.
  User: gato
  Date: 10/02/17
  Time: 14:31
--%>
<div id='gauge_${valor}' class="js-gauge demo gauge" data-id="nada"></div>


<script type="text/javascript">

    $(".demo").kumaGauge({
        value: Math.floor(${valor}),
        max : 100,
        min : 0,
        showNeedle : false,
        label:{
            display: true,
            left: 'Mínimo',
            right: 'Máximo'
        }
    })
</script>
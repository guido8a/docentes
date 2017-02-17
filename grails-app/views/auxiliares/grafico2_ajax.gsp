<%--
  Created by IntelliJ IDEA.
  User: gato
  Date: 13/02/17
  Time: 11:25
--%>

<div class="js-gauge demo2 gauge"></div>


<script type="text/javascript">

    $(".demo2").kumaGauge({
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
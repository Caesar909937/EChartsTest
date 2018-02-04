<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%
String path = request.getContextPath();
String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+path+"/";
%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
  <head>
    <meta charset="utf-8">
    <title>ECharts</title>
    <script src="js/esl.js"></script>
	<script src="js/jquery-1.3.2.min.js"></script>
	<script type="text/javascript">

      var d1 = [];//x轴年月
	  var d2 = [];//增值税
	  var d3 = [];//营业税
	  var d4 = [];//企业所得税(合计)
	  var d5 = [];//合计
    function showECharts(){
        $.ajax({
			  type: 'POST',
			  url: 'test.do?reqCode=openTax',
			  data: {"orgName":orgName},
			  async: false,  
			  dataType: 'json',
			  success: function(data){
			     $.each(data,function(i,value) {  
			         //年月日
					 d1.push(value.month);
			         //增值税
			         d2.push(value.zzs);
			         //营业税
			         d3.push(value.yys);
			         //企业所得税(合计)
			         d4.push(value.sds);
			         //合计
			         d5.push(value.total);
			     });
			  }
			});

	}


    require.config({
        paths:{ 
            echarts:'./js/echarts',
            'echarts/chart/bar' : './js/echarts-map',
            'echarts/chart/line': './js/echarts-map',
            'echarts/chart/map' : './js/echarts-map'
        }
    });
    
    require(
        [
            'echarts',
            'echarts/chart/bar',
            'echarts/chart/line',
            'echarts/chart/map'
        ],
        function(ec) {
            //--- 折柱 ---
            var myChart = ec.init(document.getElementById('main'));
            myChart.setOption({
                tooltip : {
                    trigger: 'axis'
                },
                legend: {
                    data:['增值税','营业税','企业所得税(合计)','合计']
                },
                toolbox: {
                    show : true,
                    feature : {
                        mark : {show: true},
                        dataView : {show: true, readOnly: false},
                        magicType : {show: true, type: ['line', 'bar']},
                        restore : {show: true},
                        saveAsImage : {show: true}
                    }
                },
                calculable : true,
                xAxis : [
                    {
                        type : 'category',
                        data : d1
                    }
                ],
                yAxis : [
                    {
                        type : 'value',
                        splitArea : {show : true}
                    }
                ],
                series : [
                    {
                        name:'增值税',
						type:'bar',
						data:d2
                    },
                    {
                        name:'营业税',
						type:'bar',
						data:d3
                    },
                    {
                        name:'企业所得税(合计)',
						type:'bar',
						data:d4
                    },
                    {
                        name:'合计',
						type:'bar',
						data:d5
                    }
                ]
            });
        }
    );
    </script>
  </head>
  
 <body onload="showECharts()">
    <div id="main" style="height:500px;border:1px solid #ccc;padding:10px;"></div>
</body>
</html>

<%@ page language="java" contentType="text/html; charset=EUC-KR"
	pageEncoding="EUC-KR"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta name="viewport" content="initial-scale=1.0, user-scalable=no" />
<style type="text/css">
html {
	height: 100%
}

body {
	height: 100%;
	margin: 0;
	padding: 0
}

#map_canvas {
	height: 100%
}
</style>
<script type="text/javascript"
	src="https://maps.googleapis.com/maps/api/js?key=AIzaSyCxr-yAOK1Cwb8y0oIIe_rgclFaiwEfIqw">
	
</script>
<script type="text/javascript"
	src="//apis.daum.net/maps/maps3.js?apikey=c0d9ac4370b8842337ef232ad3102774"></script>
<script type="text/javascript"
	src="http://openapi.map.naver.com/openapi/naverMap.naver?ver=2.0&key=a11d2d2a3a8c4bcb87b307db718209e5"></script>

<script type="text/javascript" src="HandiJs.js"></script>

</head>
<body>
	<div id="map_canvas" style="width: 100%; height: 100%"></div>

	<script type="text/javascript">
		var handiJS = new HandiMap('naver','map_canvas');
		handiJS.initMap();
		
		

		function initGoogleMap() {

			//kml 생성
			function libraryload() {
				loadKmlLayer(src, map);
				google.maps.event.addDomListener(window, 'load');
				//google.maps.event.addDomListener(window, 'load', initialize);
			}

			var kmlLayer;

			function loadKmlLayer(src, map) {
				kmlLayer = new google.maps.KmlLayer({
					url : src,
					suppressInfoWindows : false,
					//  preserveViewport: false,
					map : map
				});
			}

			function libraryloadremove() {
				kmlLayer.setMap(null);
			}

			var xhrObject;
			var defaultLevel = 10;
			var markers = [];

			var zo;

			// 디비 받기
			function connDB() {
				createXHR();
				var url = "http://210.107.208.21:8080/NAVER_API/JDBCExample.jsp?";
				xhrObject.onreadystatechange = resultQuery;
				xhrObject.open("Get", url, true);
				xhrObject.send(null);
			}

			var result, resultArray, k;

			function resultQuery() {
				if (xhrObject.readyState == 4) {
					if (xhrObject.status == 200) {

						result = trim(xhrObject.responseText).split("$");
						resultArray = [];

						for (var i = 0; i < result.length; i++) {
							resultArray.push(result[i].split(","));

							addMarker(eval(resultArray[i][2]),
									eval(resultArray[i][1]), {
										title : resultArray[i][0]
									});

							/*	if(resultArray[i][0]=="복지관"){
								    k="ok";
								}else{
									//addMarker(eval(resultArray[i][3]),eval(resultArray[i][2]),{title:resultArray[i][1]});
								    k="not ok";
								}*/

						}

						console.log(resultArray.length);
						/* re_array = new Array();
						re_array = result.split("&");
						PlaceMark(re_array); */

					}
				}
			}

			//지도 모드 : 위성지도
			/* function mapmode(x) {

				// 0 : 일반 지도	1 : 겹침 지도  2 : 위성 지도  3: 등고선지도
				if (x == 0) {
					map.setMapTypeId(google.maps.MapTypeId.ROADMAP);
				} else if (x == 1) {
					map.setMapTypeId(google.maps.MapTypeId.HYBRID);
				} else if (x == 2) {
					map.setMapTypeId(google.maps.MapTypeId.SATELLITE);
				} else if (x == 3) {
					map.setMapTypeId(google.maps.MapTypeId.TERRAIN);
				}
			} */

			//확대
			function zoomin() {
				if (defaultLevel > -10 && defaultLevel < 21) {
					defaultLevel++;
					map.setZoom(defaultLevel);
				}

			}

			//많이확대
			function zoomin() {
				if (defaultLevel > -10 && defaultLevel < 21) {
					defaultLevel += 3;
					map.setZoom(defaultLevel);
				}
			}

			//축소
			function zoomout() {
				if (defaultLevel > 1 && defaultLevel < 26) {
					defaultLevel--;
					map.setZoom(defaultLevel);
				}
			}

			//많이 축소
			function zzoomout() {
				if (defaultLevel > 1 && defaultLevel < 26) {
					defaultLevel -= 3;
					map.setZoom(defaultLevel);
				}
			}

			//위로
			function Nmove() {
				if (map.getZoom() < 7) {
					var tempCenter = map.getCenter();
					tempCenter.jb += (0.8 / map.getZoom());
					map.setCenter(tempCenter);
				} else {
					var tempCenter = map.getCenter();
					tempCenter.jb += (0.08 / map.getZoom());
					map.setCenter(tempCenter);
				}
			}

			//아래로
			function Smove() {
				if (map.getZoom() < 7) {
					var tempCenter = map.getCenter();
					tempCenter.jb -= (0.8 / map.getZoom());
					map.setCenter(tempCenter);
				} else {
					var tempCenter = map.getCenter();
					tempCenter.jb -= (0.08 / map.getZoom());
					map.setCenter(tempCenter);
				}
			}

			//왼쪽
			function Wmove() {
				if (map.getZoom() < 7) {
					var tempCenter = map.getCenter();
					tempCenter.kb -= (0.8 / map.getZoom());
					map.setCenter(tempCenter);
				} else {
					var tempCenter = map.getCenter();
					tempCenter.kb -= (0.08 / map.getZoom());
					map.setCenter(tempCenter);
				}
			}

			//오른쪽
			function Emove() {
				if (map.getZoom() < 7) {
					var tempCenter = map.getCenter();
					tempCenter.kb += (0.8 / map.getZoom());
					map.setCenter(tempCenter);
				} else {
					var tempCenter = map.getCenter();
					tempCenter.kb += (0.08 / map.getZoom());
					map.setCenter(tempCenter);
				}
			}

			// 북동
			function NEmove() {
				if (map.getZoom() < 7) {
					var tempCenter = map.getCenter();
					tempCenter.jb += (0.8 / map.getZoom());
					tempCenter.kb += (0.8 / map.getZoom());
					map.setCenter(tempCenter);
				} else {
					var tempCenter = map.getCenter();
					tempCenter.jb += (0.08 / map.getZoom());
					tempCenter.kb += (0.08 / map.getZoom());
					map.setCenter(tempCenter);
				}
			}

			//북서
			function NWmove() {
				if (map.getZoom() < 7) {
					var tempCenter = map.getCenter();
					tempCenter.jb += (0.8 / map.getZoom());
					tempCenter.kb -= (0.8 / map.getZoom());
					map.setCenter(tempCenter);
				} else {
					var tempCenter = map.getCenter();
					tempCenter.jb += (0.08 / map.getZoom());
					tempCenter.kb -= (0.08 / map.getZoom());
					map.setCenter(tempCenter);
				}
			}

			//남서
			function SWmove() {
				if (map.getZoom() < 7) {
					var tempCenter = map.getCenter();
					tempCenter.jb -= (0.8 / map.getZoom());
					tempCenter.kb -= (0.8 / map.getZoom());
					map.setCenter(tempCenter);
				} else {
					var tempCenter = map.getCenter();
					tempCenter.jb -= (0.08 / map.getZoom());
					tempCenter.kb -= (0.08 / map.getZoom());
					map.setCenter(tempCenter);
				}
			}

			//남동
			function SEmove() {
				if (map.getZoom() < 7) {
					var tempCenter = map.getCenter();
					tempCenter.jb -= (0.8 / map.getZoom());
					tempCenter.kb += (0.8 / map.getZoom());
					map.setCenter(tempCenter);
				} else {
					var tempCenter = map.getCenter();
					tempCenter.jb -= (0.08 / map.getZoom());
					tempCenter.kb += (0.08 / map.getZoom());
					map.setCenter(tempCenter);
				}
			}

			//서울 
			function Seoul() {
				var oPoint = new google.maps.LatLng(37.575348, 126.97674);
				map.setCenter(oPoint);
				map.setZoom(12);
			}

			//대구
			function Deagu() {
				var oPoint = new google.maps.LatLng(35.8713424, 128.6017878);
				map.setCenter(oPoint);
				map.setZoom(14);
			}

			//동대구역
			function DongDeagu() {
				var oPoint = new google.maps.LatLng(35.8788084, 128.6278964);
				map.setCenter(oPoint);
				map.setZoom(12);
			}

			//우리집
			function Myhome() {
				var oPoint = new google.maps.LatLng(35.9279271, 128.5503635);
				map.setCenter(oPoint);
				map.setZoom(19);
			}

			//부산		
			function Busan() {
				var oPoint = new google.maps.LatLng(35.149466588343486,
						129.10390373287657);
				map.setCenter(oPoint);
				map.setZoom(13);
			}

			//부경대학교 정문
			function pknuFront() {
				var oPoint = new google.maps.LatLng(35.133534909628466,
						129.10138656137704);
				map.setCenter(oPoint);
				map.setZoom(19);
			}

			//부경대학교
			function Pknu() {
				var oPoint = new google.maps.LatLng(35.133395574244226,
						129.10586294841008);
				map.setCenter(oPoint);
				map.setZoom(18);
			}
		}
	</script>
</body>
</html>
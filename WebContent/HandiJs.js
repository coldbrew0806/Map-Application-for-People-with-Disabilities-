var HandiMap = function(t, eid, mapoptions){
	
	this.vendor = t;
	
	this.TYPE_ROAD = 0;
	this.TYPE_SATELLITE = 1;
	this.TYPE_HYBRID = 2;
	this.TYPE_TRAFFIC = 3;
	this.TYPE_BICYCLE = 4;
	this.TYPE_TERRAIN = 5;
	
	this.zoomrange = {
			'google':[0,22],
			'daum':[1,14],
			'naver':[1,14]
			};
		
	this.elementId = eid;
	if(t == 'google')
		this.mapObject = google.maps;
	else if(t == 'daum')
		this.mapObject = daum.maps;
	else
		this.mapObject = nhn.api.map;
	
	if(t == 'naver')
		this.zoom = 11;
	else if(t=='daum')
		this.zoom = 15-11;
	else
		this.zoom = 16;
	
	this.draggable = true;
	this.doubleclick = true;
	this.wheelenable = true;
	this.maptype = this.TYPE_ROAD;
	
	this.centerpoint = new this.mapObject.LatLng(35.133395574244226, 129.10586294841008); 
}
HandiMap.prototype.controlFuntions = function(){
	return ["zoomIn", "zoomOut", "setMapType", "move"];
}
HandiMap.prototype.getMapTypeNo = function(){
	
	var googleType = ['roadmap', 'satellite', 'hybrid', 'roadmap','roadmap','terrain'];
	var daumType = [1,2,3,1,1,1];
	var naverType = [0,2,1,0,0,0];
	
	switch(this.vendor){
	case 'google':
		return googleType[this.maptype];
	case 'daum':
		return daumType[this.maptype];
	case 'naver':
		return naverType[this.maptype];
	}
}
HandiMap.prototype.getDaumOverlayLayer = function(t){
	var daumType = [0,0,0,6,8,7];
	return daumType[t];
}

HandiMap.prototype.initMap = function(){
	// google
	var option;
	
	switch(this.vendor){
		case 'google':
			option = {
				center: this.centerpoint,
				zoom : this.zoom,
				draggable : this.draggable,
				scrollwheel : this.wheelenable,
				disableDoubleClickZoom : this.doubleclick,
				};
			break;
		case 'daum':
			option = {
				center: this.centerpoint,
				level: this.zoom,
				draggable : this.draggable,
				scrollwheel : this.wheelenable,
				disableDoubleClick : this.doubleclick,
				};
			break;
		case 'naver':
			option = {
				point: this.centerpoint,
				zoom : this.zoom,
				enableDragPan : this.draggable,
				enableWheelZoom : this.wheelenable,
				enableDblClickZoom : this.doubleclick,
				activateTrafficMap : false,
				activateBicycleMap : false,
				};
			break;
	}
	
	this.map = new this.mapObject.Map(document.getElementById(this.elementId), option);
}
HandiMap.prototype.setMapType = function(t){
	
	this.maptype = t;
	
	switch(this.vendor){
	case 'google':
		this.map.setMapTypeId(this.getMapTypeNo());
		
		if(this.overlaidLayer){
			this.overlaidLayer.setMap(null);
			this.overlaidLayer = null;
		}
		switch(t){
		case 3:
			this.overlaidLayer = new this.mapObject.TrafficLayer();
			this.overlaidLayer.setMap(this.map);
			break;
		case 4:
			this.overlaidLayer = new this.mapObject.BicyclingLayer();
			this.overlaidLayer.setMap(this.map);
			break;
		}
		
		break;
	case 'daum':
		this.map.setMapTypeId(this.getMapTypeNo());
		if(this.overlaidLayer){
			this.map.removeOverlayMapTypeId(this.overlaidLayer);
			this.overlaidLayer = null;
		}
		if(t>2){
			var changeMapType = this.getDaumOverlayLayer(t);
			this.map.addOverlayMapTypeId(changeMapType);
			this.overlaidLayer = changeMapType;
		}
		
		break;
	case 'naver':
		if(this.map.isTrafficMapActivated||this.map.isBicycleMapActivated){
			this.map.activateTrafficMap(false);
			this.map.activateBicycleMap(false);
		}
		this.map.setMapMode(this.getMapTypeNo());
		switch(t){
		case 3:
			this.map.activateTrafficMap(true);
			break;
		case 4:
			this.map.activateBicycleMap(true);
			break;
		}
		break;
	}
}
HandiMap.prototype.zoomIn = function(a){
	var zoomRange = this.zoomrange[this.vendor];
	
}
HandiMap.prototype.zoomOut = function(a){
	var zoomRange = this.zoomrange[this.vendor];
	
}
HandiMap.prototype.move = function(v){
	
}
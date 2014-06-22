window.addEventListener('load', function() {

    var modes = {
        upload: false,
        about: false,
        ruler: false
    };

    var curPark = null;

    var blurInt;
    var blurMap = function() {
        var blur = document.getElementById("map").style["-webkit-filter"];
        var x = blur.split("(")[1].split("px)")[0];
        x = parseFloat(x) + parseFloat(1);
        document.getElementById("map").style["-webkit-filter"] = "blur(" + x + "px)";
        if (x >= 5) {
            clearInterval(blurInt);
        }
    };


    var uAButton = document.getElementById("userAction");
    uAButton.addEventListener("click", function() { 
        document.getElementById("aboutus").style.display = "none"
        if (document.getElementById("upload").style.display === "block")  {
            clearDialogs();
        } else {
            modes.upload = true;
            document.getElementById("upload").style.display = "block";
            document.getElementById("map").style["-webkit-filter"] = "blur(0px)";
            blurInt = setInterval(blurMap, 50);
        }
    });

    var aUButton = document.getElementById("about");
    aUButton.addEventListener("click", function() { 
        document.getElementById("upload").style.display = "none"
        if (document.getElementById("aboutus").style.display === "block")  {
            clearDialogs();
        } else {
            modes.about = true;
            document.getElementById("aboutus").style.display = "block";
            document.getElementById("map").style["-webkit-filter"] = "blur(0px)";
            blurInt = setInterval(blurMap, 50);
        }
    });

    var proj = new OpenLayers.Projection("EPSG:4326");

    var map = new OpenLayers.Map('map', {
        projection: 'EPSG:3857',
        layers: [
            new OpenLayers.Layer.OSM("OSM", "", { opacity: 0.6 }
            )
        ],
        center: new OpenLayers.LonLat(-75.1667, 39.95)
            .transform(proj, 'EPSG:3857'),
        zoom: 13 
    });

    var trailStyle = {
    }

    var trailsLayer = new OpenLayers.Layer.Vector("Trails Layer", { 
      eventListeners: {
        'featureselected':function(evt){
          var feature = evt.feature;
          var popup = new OpenLayers.Popup.FramedCloud(
            "popup",
            feature.geometry.getBounds().getCenterLonLat(),
            OpenLayers.Size(400,800),
            "<div style='font-size:.8em'>Name: " + feature.attributes.name +"<br>Length: " + feature.attributes.length+"</div>",
            null,
            null
          );
          popup.fixedRelativePosition = true;
          feature.popup = popup;
          map.addPopup(popup);
        },
        'featureunselected':function(evt){
          var feature = evt.feature;
          map.removePopup(feature.popup);
          feature.popup.destroy();
          feature.popup = null;
        }
    },
      styleMap: new OpenLayers.StyleMap({
        "default": new OpenLayers.Style(OpenLayers.Util.applyDefaults({
          strokeColor: "${strokeColor}",
          strokeWidth: 3,
          graphicName: "linestring"
        }, OpenLayers.Feature.Vector.style["default"])),
        "select": new OpenLayers.Style(OpenLayers.Util.applyDefaults({
          graphicName: "linestring",
          strokeColor: "#000000 ",
          strokeWidth: 5
        }, OpenLayers.Feature.Vector.style["select"]))
      }) 
    });
    var parksLayer = new OpenLayers.Layer.Vector("Parks Layer", { 
      eventListeners: {
        'featureselected':function(evt){
          var feature = evt.feature;
          curPark = evt.feature;
          var popup = new OpenLayers.Popup.FramedCloud(
            "popup",
            feature.geometry.getBounds().getCenterLonLat(),
            OpenLayers.Size(400,800),
            "<div style='font-size:.8em'>Park: " + feature.attributes.name +"<br>Size: " + feature.attributes.acres+" acres</div>",
            null,
            null
          );
          popup.fixedRelativePosition = true;
          feature.popup = popup;
          map.addPopup(popup);
        },
        'featureunselected':function(evt){
          var feature = evt.feature;
          curPark = null;
          map.removePopup(feature.popup);
          feature.popup.destroy();
          feature.popup = null;
        },
        'mouseup': function(evt) {
            alert("hey arnold!");
        }
    },
      styleMap: new OpenLayers.StyleMap({
        "default": new OpenLayers.Style(OpenLayers.Util.applyDefaults({
          fill: true,
          fillColor: "#00FF00",
          fillOpacity: 0.3,
          strokeColor: "#008800",
          strokeOpacity: 0.7,
          strokeDashstyle: "dot",
          graphicName: "polygon"
        }, OpenLayers.Feature.Vector.style["default"])),
        "select": new OpenLayers.Style(OpenLayers.Util.applyDefaults({
          graphicName: "polygon",
          fill: true,
          fillColor: "#A55D35",
          fillOpacity: 0.7,
          strokeColor: "#DABD95",
          strokeOpacity: 0.9,
          strokeDashstyle: "dot",
        }, OpenLayers.Feature.Vector.style["select"]))
      }) 
    });
    var park_selector = new OpenLayers.Control.SelectFeature([parksLayer],{
      hover:true,
      autoActivate:true
    });
    var trail_selector = new OpenLayers.Control.SelectFeature([trailsLayer],{
      clickout: true,
      toggle: false,
      multiple: false,
      hover: false,
      toggleKey: "ctrlKey", // ctrl key removes from selection
      multipleKey: "shiftKey", // shift key adds to selection
    });
//Step 4 - add the layer and control to the map
    var markers = new OpenLayers.Layer.Markers("Markers");
    map.addLayer(parksLayer);
    map.addLayer(trailsLayer);
    map.addLayer(markers);

    /* Picture of Aaron
    var size = new OpenLayers.Size(80,80);
    var offset = new OpenLayers.Pixel(-(size.w/2), -size.h);
    var icon = new OpenLayers.Icon('http://i.imgur.com/9Bw1rLa.png', size, offset);
    markers.addMarker(new OpenLayers.Marker(new OpenLayers.LonLat(-75.1667,39.95).transform(proj, map.getProjectionObject()),icon));
    markers.addMarker(new OpenLayers.Marker(new OpenLayers.LonLat(-75.1667, 39.95).transform(proj, map.getProjectionObject()),icon.clone()));
    */

    function handler(request) {

        var geojson_format = new OpenLayers.Format.GeoJSON({
            'internalProjection': map.baseLayer.projection,
            'externalProjection': new OpenLayers.Projection("EPSG:4326")
        });

        var collection = $('.data').data(request.data);
        for (ii = 0; ii < collection.length; ii++) { 
          var object = collection[ii];
          object.properties.strokeColor = gimmeColor(object.properties.climb,0,50);
          console.log(object);
          request.layer.addFeatures(geojson_format.read(object));
        }
    }

    var GeoJSONs = [
        {
            data: "parks",
            layer: parksLayer
        },
        {
            data: "parkAreas",
            layer: parksLayer
        },
        {
            data: "trails",
            layer: trailsLayer
        }
    ];

    // var GeoJSONs = [
    //     {
    //         url: "assets/PPR_Boundaries.geojson",
    //         layer: parksLayer
    //     },
    //     {
    //         url:"assets/trails.geojson",
    //         layer: trailsLayer
    //     }
    // ];        

    for (var i = 0; i < GeoJSONs.length; i++) {
      handler(GeoJSONs[i]);
        // OpenLayers.Request.GET({
        //     url: GeoJSONs[i].url,
        //     callback: handler,
        //     scope: {
        //         layer: GeoJSONs[i].layer
        //     }
        // });
    }

    var report = function(e) {
      //OpenLayers.Console.log(e.type, e.feature.id);
    }; 

    map.addControl(new OpenLayers.Control.LayerSwitcher());
    selectControl = new OpenLayers.Control.SelectFeature(
      [parksLayer, trailsLayer], {
      clickout: true,
      toggle: false,
      multiple: false,
      hover: false,
      toggleKey: "ctrlKey", // ctrl key removes from selection
      multipleKey: "shiftKey", // shift key adds to selection
      }
    );
    map.addControl(selectControl);
    map.addControl(park_selector);
    map.addControl(trail_selector);
    selectControl.activate(); 

    // var clicked = false;
    // var startMarker = new OpenLayers.Marker(new OpenLayers.LonLat(0, 0));
    // startMarker.display(false);
    // var endMarker = new OpenLayers.Marker(new OpenLayers.LonLat(0, 0));
    // endMarker.display(false);


    OpenLayers.Control.Click = OpenLayers.Class(OpenLayers.Control, {                
        defaultHandlerOptions: {
            'single': true,
            'double': false,
            'pixelTolerance': 0,
            'stopSingle': false,
            'stopDouble': false
        },
   
        initialize: function(options) {
            this.handlerOptions = OpenLayers.Util.extend(
                {}, this.defaultHandlerOptions
            );
            OpenLayers.Control.prototype.initialize.apply(
                this, arguments
            ); 
            this.handler = new OpenLayers.Handler.Click(
                this, {
                    'click': this.trigger
                }, this.handlerOptions
            );
        }, 
    
        trigger: function(e) {
            if (curPark) {
                map.zoomToExtent(curPark.geometry.getBounds());
            }
        }
    
    });
    
    var click = new OpenLayers.Control.Click();
    map.addControl(click);
    click.activate();

    // if ("geolocation" in navigator) {
    //     navigator.geolocation.getCurrentPosition(function(position) {
    //           map.setCenter(new OpenLayers.LonLat(position.coords.longitude, position.coords.latitude).transform(proj, map.getProjectionObject()));
    //     });
    // }

    var clearDialogs = function() {
        document.getElementById("map").style["-webkit-filter"] = "blur(0px)";
        document.getElementById("aboutus").style.display = "none";
        document.getElementById("upload").style.display = "none";
        modes.upload = false;
        modes.about = false;
    };

    window.onkeyup = function(e) {
        var key = e.keyCode ? e.keyCode : e.which;

        if (key === 27) {
            clearDialogs();
            startMarker.erase();
            endMarker.erase();
            clicked = false;
        }
    }



    /* XHR Image Upload */
    var form = document.getElementById('imgUp');
    var photo = document.getElementById('photo');
    var uploadButton = document.getElementById('upBtn');

    form.onsubmit = function(event) {
        event.preventDefault();

        // Update button text.
        uploadButton.innerHTML = 'Uploading...';

        // The rest of the code will go here...

        var files = photo.files;
        var formData = new FormData();

        // Loop through each of the selected files.
        for (var i = 0; i < files.length; i++) {
            var file = files[i];

            // Check the file type.
            if (!file.type.match('image.*')) {
            continue;
            }

            // Add the file to the request.
            formData.append('photos[]', file, file.name);
        }

        // Set up the request.
        var xhr = new XMLHttpRequest();
        // Open the connection.
        xhr.open('POST', '/test-test', true);
        // Set up a handler for when the request finishes.
        xhr.onload = function () {
            if (xhr.status === 200) {
                // File(s) uploaded.
                uploadButton.innerHTML = 'Upload';
            } else {
                alert('An error occurred!');
            }
        };
        // Send the Data.
        xhr.send(formData);

    }
}, false);

var gimmeColor = function(x, min, max) {
    var r = Math.floor((255 * (x - min))/(max - min));
    var b = Math.floor((255 * (max - x))/(max - min));

    var R = r.toString(16);
    if (R.length === 1) {
        R = "0" + R;
    }

    var B = b.toString(16);
    if (B.length === 1) {
        B = "0" + B;
    }

   return ("#" + R + "00" + B); 
};

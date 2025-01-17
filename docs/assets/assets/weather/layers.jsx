// Loop through each layer
var doc = app.activeDocument;
var layers = doc.layers;

for (var i = 0; i < layers.length; i++) {
    // Make all layers invisible
    for (var j = 0; j < layers.length; j++) {
        layers[j].visible = false;
    }

    // Make the current layer visible
    layers[i].visible = true;

    // Export as PNG
    var exportOptions = new ExportOptionsSaveForWeb();
    exportOptions.format = SaveDocumentType.PNG;
    exportOptions.PNG8 = false; // Change this to true if you want PNG-8

    var file = new File("~/Desktop/" + layers[i].name + ".png"); // Change the destination folder as needed
    doc.exportDocument(file, ExportType.SAVEFORWEB, exportOptions);

    // Make the current layer invisible again
    layers[i].visible = false;
}

// Make all layers visible again
for (var k = 0; k < layers.length; k++) {
    layers[k].visible = true;
}

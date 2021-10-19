function labelFormat(string){
    var outerArguments = arguments;
    return string.replace(/\{(\d+)\}/g, function() {
        return outerArguments[parseInt(arguments[1]) + 1];
    });
}

export {labelFormat}
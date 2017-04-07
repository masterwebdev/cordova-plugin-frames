cordova.define("com.autovitalsinc.frames.frames", function(require, exports, module) {
/*global cordova, module*/

module.exports = {
    getframe: function (path, position, successCallback, errorCallback) {
        cordova.exec(successCallback, errorCallback, "Frames", "getframe", [path, position]);
    }
};

});

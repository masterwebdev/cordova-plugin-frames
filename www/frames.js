module.exports = {
    getframe: function (path, position, successCallback, errorCallback) {
        cordova.exec(successCallback, errorCallback, "Frames", "getframe", [path, position]);
    }
};
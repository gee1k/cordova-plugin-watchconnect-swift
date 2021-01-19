var exec = require('cordova/exec');

module.exports = {
    initialize: function (onSuccess, onError) {
        exec(onSuccess, onError, "WatchConnect", "initialize", []);
    },

    deinitialize: function (message, onSuccess, onError) {
        exec(onSuccess, onError, "WatchConnect", "deinitialize", []);
    },

    sendMessage: function (message, onSuccess, onError) {
        exec(onSuccess, onError, "WatchConnect", "sendMessage", [message]);
    },

    listenMessage: function (onMessage) {
        exec(onMessage, null, "WatchConnect", "listenMessage", []);
    },

    checkConnection: function (onSuccess, onError) {
        exec(onSuccess, onError, "WatchConnect", "checkConnection", []);
    }
};
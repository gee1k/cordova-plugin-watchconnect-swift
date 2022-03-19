var exec = require('cordova/exec');
module.exports = {
    updateApplicationContext: function (keyString, valueString, success, error) {
        exec(success, error, "WatchConnect", "updateApplicationContext", [keyString, valueString]);
    },
    transferUserInfo: function (keyString, valueString, success, error) {
        exec(success, error, "WatchConnect", "transferUserInfo", [keyString, valueString]);
    },
    initialize: function (success, error) {
        exec(success, error, "WatchConnect", "initialize", []);
    },
    deinitialize: function (success, error) {
        exec(success, error, "WatchConnect", "deinitialize", []);
    },
    sendMessage: function (message, success, error) {
        exec(success, error, "WatchConnect", "sendMessage", [message]);
    },
    listenMessage: function (onMessage) {
        exec(onMessage, null, "WatchConnect", "listenMessage", []);
    },
    checkConnection: function (success, error) {
        exec(success, error, "WatchConnect", "checkConnection", []);
    }
};

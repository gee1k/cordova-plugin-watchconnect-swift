var exec = require('cordova/exec');
module.exports = {
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
    updateApplicationContext: function (message, success, error) {
        exec(success, error, "WatchConnect", "updateApplicationContext", [message]);
    },
    transferUserInfo: function (message, success, error) {
        exec(success, error, "WatchConnect", "transferUserInfo", [message]);
    },
    checkConnection: function (success, error) {
        exec(success, error, "WatchConnect", "checkConnection", []);
    }
};

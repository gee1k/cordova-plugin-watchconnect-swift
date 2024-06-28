var exec = require('cordova/exec');
module.exports = {
    initialize: function (success, error) {
        exec(success, error, "WatchConnect", "initialize", []);
    },
    deinitialize: function (success, error) {
        exec(success, error, "WatchConnect", "deinitialize", []);
    },
    sendMessage: function (message, replyRequired, success, error) {
        exec(success, error, "WatchConnect", "sendMessage", [message, replyRequired]);
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
    },
    isWatchPaired: function (success, error) {
        exec(success, error, "WatchConnect", "isWatchPaired", []);
    }
};

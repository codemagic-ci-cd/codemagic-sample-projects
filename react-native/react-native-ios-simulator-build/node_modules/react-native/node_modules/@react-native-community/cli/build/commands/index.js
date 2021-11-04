"use strict";

Object.defineProperty(exports, "__esModule", {
  value: true
});
exports.detachedCommands = exports.projectCommands = void 0;

function _cliPluginMetro() {
  const data = require("@react-native-community/cli-plugin-metro");

  _cliPluginMetro = function () {
    return data;
  };

  return data;
}

var _link = _interopRequireDefault(require("./link/link"));

var _unlink = _interopRequireDefault(require("./link/unlink"));

var _install = _interopRequireDefault(require("./install/install"));

var _uninstall = _interopRequireDefault(require("./install/uninstall"));

var _upgrade = _interopRequireDefault(require("./upgrade/upgrade"));

var _info = _interopRequireDefault(require("./info/info"));

var _config = _interopRequireDefault(require("./config/config"));

var _init = _interopRequireDefault(require("./init"));

var _doctor = _interopRequireDefault(require("./doctor"));

function _cliHermes() {
  const data = _interopRequireDefault(require("@react-native-community/cli-hermes"));

  _cliHermes = function () {
    return data;
  };

  return data;
}

function _interopRequireDefault(obj) { return obj && obj.__esModule ? obj : { default: obj }; }

const projectCommands = [..._cliPluginMetro().commands, _link.default, _unlink.default, _install.default, _uninstall.default, _upgrade.default, _info.default, _config.default, _cliHermes().default];
exports.projectCommands = projectCommands;
const detachedCommands = [_init.default, _doctor.default];
exports.detachedCommands = detachedCommands;

//# sourceMappingURL=index.js.map